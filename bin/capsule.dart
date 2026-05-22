import 'dart:io';
import 'dart:convert';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Input directory containing web assets')
    ..addOption('output', abbr: 'o', help: 'Output executable path', defaultsTo: 'capsule_server')
    ..addOption('port', abbr: 'p', help: 'Default port for the server', defaultsTo: '8080')
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage information');

  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);
  } catch (e) {
    print(e);
    _printUsage(parser);
    return;
  }

  if (argResults['help'] || argResults['input'] == null) {
    _printUsage(parser);
    return;
  }

  final inputPath = argResults['input'];
  final outputPath = argResults['output'];
  final defaultPort = argResults['port'];

  final inputDir = Directory(inputPath);
  if (!await inputDir.exists()) {
    print('Error: Input directory "$inputPath" does not exist.');
    return;
  }

  print('Reading and compressing assets from $inputPath...');
  final assets = <String, String>{};
  await for (final file in inputDir.list(recursive: true)) {
    if (file is File) {
      final relativePath = p.relative(file.path, from: inputDir.path);
      final bytes = await file.readAsBytes();
      
      // Compress using Gzip
      final compressedBytes = gzip.encode(bytes);
      assets[relativePath] = base64Encode(compressedBytes);
    }
  }

  print('Preparing Capsule server code...');
  final templateFile = File(p.join(p.dirname(Platform.script.toFilePath()), '../lib/templates/server_template.dart'));
  String template;
  try {
    template = await templateFile.readAsString();
  } catch (e) {
    final fallbackTemplatePath = p.join(Directory.current.path, 'lib/templates/server_template.dart');
    template = await File(fallbackTemplatePath).readAsString();
  }

  final assetsBuffer = StringBuffer();
  assets.forEach((path, content) {
    assetsBuffer.writeln("  '$path': '$content',");
  });

  var serverCode = template
      .replaceFirst('{{ASSETS}}', assetsBuffer.toString())
      .replaceFirst('{{DEFAULT_PORT}}', defaultPort)
      .replaceFirst('{{DEFAULT_PORT}}', defaultPort);

  final tempDir = await Directory.systemTemp.createTemp('capsule_');
  final tempDartFile = File(p.join(tempDir.path, 'main.dart'));
  await tempDartFile.writeAsString(serverCode);

  print('Compiling compressed executable to $outputPath...');
  final result = await Process.run('dart', [
    'compile',
    'exe',
    tempDartFile.path,
    '-o',
    outputPath,
  ]);

  if (result.exitCode == 0) {
    print('Success! Capsule generated at: $outputPath');
    final originalSize = await _getDirSize(inputDir);
    final exeSize = await File(outputPath).length();
    print('Original assets size: ${_formatSize(originalSize)}');
    print('Compressed executable size: ${_formatSize(exeSize)}');
  } else {
    print('Error during compilation:');
    print(result.stderr);
  }

  await tempDir.delete(recursive: true);
}

Future<int> _getDirSize(Directory dir) async {
  var size = 0;
  await for (final file in dir.list(recursive: true)) {
    if (file is File) {
      size += await file.length();
    }
  }
  return size;
}

String _formatSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
}

void _printUsage(ArgParser parser) {
  print('Usage: capsule -i <input_dir> [options]');
  print(parser.usage);
}
