import 'dart:io';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import '../lib/services/project_service.dart';
import '../lib/services/build_engine.dart';
import '../lib/models/build/build_config.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('input',
        abbr: 'i', help: 'Input directory containing web assets')
    ..addOption('output',
        abbr: 'o',
        help: 'Output executable path or directory',
        defaultsTo: 'build')
    ..addOption('name', abbr: 'n', help: 'Application name')
    ..addOption('port',
        abbr: 'p', help: 'Default port for the server', defaultsTo: '8080')
    ..addOption('platform',
        help: 'Target platform (windows, macos, linux)',
        allowed: ['windows', 'macos', 'linux'])
    ..addFlag('help', abbr: 'h', negatable: false, help: 'Show usage information')
    ..addFlag('verbose',
        abbr: 'v', negatable: false, help: 'Show detailed build logs');

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

  final inputPath = argResults['input'] as String;
  final outputPath = argResults['output'] as String;
  final appName = argResults['name'] as String?;
  final platform = argResults['platform'] as String?;
  final verbose = argResults['verbose'] as bool;

  try {
    print('╔═══════════════════════════════════════════════════════╗');
    print('║              Capsule 2.0 - Build System              ║');
    print('╚═══════════════════════════════════════════════════════╝');
    print('');

    // Step 1: Create project from directory
    print('📁 Creating project from directory: $inputPath');
    final projectService = ProjectService();
    final project = await projectService.createFromDirectory(
      inputPath,
      name: appName,
    );

    print('✓ Project created: ${project.name}');
    print('  - Assets: ${project.assets.length} files');
    final totalSize = project.assets.fold<int>(0, (sum, asset) => sum + asset.size);
    print('  - Total size: ${_formatSize(totalSize)}');
    print('');

    // Step 2: Create build configuration
    print('⚙️  Configuring build...');
    final buildEngine = BuildEngine();
    final buildConfig = buildEngine.createDefaultBuildConfig(
      project,
      outputDir: outputPath,
      platform: platform,
    );

    print('✓ Build configuration ready');
    print('  - Platform: ${buildConfig.platform}');
    print('  - Architecture: ${buildConfig.architecture}');
    print('  - Output: ${buildConfig.outputDir}');
    print('');

    // Step 3: Execute build
    print('🔨 Starting build pipeline...');
    print('');

    // Listen to build progress
    if (verbose) {
      buildEngine.progressStream.listen((progress) {
        final percentage = progress.percentage.toString().padLeft(3);
        print('  [$percentage%] ${progress.stage}: ${progress.message}');
        if (progress.hasError) {
          print('  ERROR: ${progress.error}');
        }
      });
    } else {
      buildEngine.progressStream.listen((progress) {
        stdout.write('\r  Building... ${progress.percentage}% - ${progress.stage}');
      });
    }

    final result = await buildEngine.build(project, buildConfig);

    if (!verbose) {
      print(''); // New line after progress indicator
    }
    print('');

    if (result.isSuccess) {
      print('═══════════════════════════════════════════════════════');
      print('✅ BUILD SUCCESSFUL');
      print('═══════════════════════════════════════════════════════');
      print('');
      print('📦 Output: ${result.outputPath}');
      if (result.metadata.containsKey('fileSize')) {
        print('📊 Size: ${_formatSize(result.metadata['fileSize'] as int)}');
      }
      if (result.duration != null) {
        print('⏱️  Time: ${result.duration!.inSeconds}s');
      }
      print('');
      print('🚀 To run your application:');
      print('   ${result.outputPath}');
      print('');
    } else {
      print('═══════════════════════════════════════════════════════');
      print('❌ BUILD FAILED');
      print('═══════════════════════════════════════════════════════');
      print('');
      print('Error: ${result.errorMessage}');
      print('');

      if (verbose) {
        print('Build logs:');
        for (final log in result.logs) {
          print('  [${log.level.name.toUpperCase()}] ${log.stage}: ${log.message}');
        }
        print('');
      }

      exit(1);
    }

    buildEngine.dispose();
  } catch (e, stackTrace) {
    print('');
    print('═══════════════════════════════════════════════════════');
    print('❌ FATAL ERROR');
    print('═══════════════════════════════════════════════════════');
    print('');
    print('Error: $e');
    if (verbose) {
      print('');
      print('Stack trace:');
      print(stackTrace);
    }
    print('');
    exit(1);
  }
}

String _formatSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
}

void _printUsage(ArgParser parser) {
  print('');
  print('Capsule 2.0 - Desktop App Bundler');
  print('');
  print('Transform web applications into standalone desktop executables');
  print('');
  print('Usage: capsule -i <input_dir> [options]');
  print('');
  print('Options:');
  print(parser.usage);
  print('');
  print('Examples:');
  print('  # Basic usage');
  print('  capsule -i ./my-web-app');
  print('');
  print('  # Specify output and name');
  print('  capsule -i ./dist -o ./build -n "My App"');
  print('');
  print('  # Build for specific platform');
  print('  capsule -i ./dist --platform macos');
  print('');
  print('  # Verbose output');
  print('  capsule -i ./dist -v');
  print('');
}
