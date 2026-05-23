import 'dart:io';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:archive/archive_io.dart';
import '../models/project/build_config.dart';

/// Service for building and packaging desktop applications
class BuildService {
  final String outputDir;

  BuildService({required this.outputDir});

  /// Executes the full build pipeline
  Future<BuildResult> build(BuildConfig config) async {
    final steps = <String>[];
    final stopwatch = Stopwatch()..start();

    try {
      // Step 1: Validate
      steps.add('Validating project...');
      await _validateProject(config);

      // Step 2: Prepare output directory
      steps.add('Preparing output directory...');
      await _prepareOutput(config);

      // Step 3: Copy web assets
      steps.add('Copying web assets...');
      await _copyAssets(config);

      // Step 4: Generate Flutter wrapper
      steps.add('Generating Flutter wrapper...');
      await _generateWrapper(config);

      // Step 5: Compile for target platform
      steps.add('Compiling for ${config.targetPlatform}...');
      await _compile(config);

      // Step 6: Package and compress
      steps.add('Packaging application...');
      final outputPath = await _package(config);

      stopwatch.stop();
      
      return BuildResult(
        success: true,
        outputPath: outputPath,
        steps: steps,
        duration: stopwatch.elapsed,
        fileSize: await _getFileSize(outputPath),
      );
    } catch (e) {
      stopwatch.stop();
      return BuildResult(
        success: false,
        outputPath: null,
        steps: steps,
        duration: stopwatch.elapsed,
        error: e.toString(),
      );
    }
  }

  Future<void> _validateProject(BuildConfig config) async {
    final sourceDir = Directory(config.sourcePath);
    if (!await sourceDir.exists()) {
      throw Exception('Source directory does not exist: ${config.sourcePath}');
    }

    // Check for build directory or index.html
    final buildDir = config.buildDirectory ?? config.sourcePath;
    final indexHtml = File(path.join(buildDir, 'index.html'));
    if (!await indexHtml.exists()) {
      throw Exception('No index.html found in project. Please build your web app first.');
    }
  }

  Future<void> _prepareOutput(BuildConfig config) async {
    final outputDirectory = Directory(outputDir);
    if (await outputDirectory.exists()) {
      await outputDirectory.delete(recursive: true);
    }
    await outputDirectory.create(recursive: true);

    // Create temp build directory
    final tempDir = Directory(path.join(outputDir, '.capsule_build'));
    await tempDir.create(recursive: true);
  }

  Future<void> _copyAssets(BuildConfig config) async {
    final buildDir = config.buildDirectory ?? config.sourcePath;
    final targetDir = path.join(outputDir, '.capsule_build', 'web_assets');

    await _copyDirectory(Directory(buildDir), Directory(targetDir));
  }

  Future<void> _generateWrapper(BuildConfig config) async {
    // Create Flutter project structure
    final flutterDir = Directory(path.join(outputDir, '.capsule_build', 'flutter_app'));
    await flutterDir.create(recursive: true);

    // Generate pubspec.yaml
    final pubspec = File(path.join(flutterDir.path, 'pubspec.yaml'));
    await pubspec.writeAsString(_generatePubspec(config));

    // Generate main.dart
    final libDir = Directory(path.join(flutterDir.path, 'lib'));
    await libDir.create();
    final mainDart = File(path.join(libDir.path, 'main.dart'));
    await mainDart.writeAsString(_generateMainDart(config));

    // Copy web assets to Flutter assets
    final assetsDir = Directory(path.join(flutterDir.path, 'assets'));
    await assetsDir.create();
    await _copyDirectory(
      Directory(path.join(outputDir, '.capsule_build', 'web_assets')),
      Directory(path.join(assetsDir.path, 'web')),
    );
  }

  Future<void> _compile(BuildConfig config) async {
    final flutterDir = path.join(outputDir, '.capsule_build', 'flutter_app');
    
    // Run flutter build based on target platform
    final process = await Process.start(
      'flutter',
      ['build', _getBuildTarget(config.targetPlatform), '--release'],
      workingDirectory: flutterDir,
      runInShell: true,
    );

    // Wait for completion
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      final stderr = await process.stderr.transform(utf8.decoder).join();
      throw Exception('Flutter build failed: $stderr');
    }
  }

  Future<String> _package(BuildConfig config) async {
    final platform = config.targetPlatform;
    final appName = config.appName.replaceAll(' ', '_').toLowerCase();
    
    String executablePath;
    String extension;
    
    switch (platform) {
      case TargetPlatform.windows:
        executablePath = path.join(outputDir, '.capsule_build', 'flutter_app', 'build', 'windows', 'runner', 'Release');
        extension = 'exe';
        break;
      case TargetPlatform.macos:
        executablePath = path.join(outputDir, '.capsule_build', 'flutter_app', 'build', 'macos', 'Build', 'Products', 'Release');
        extension = 'app';
        break;
      case TargetPlatform.linux:
        executablePath = path.join(outputDir, '.capsule_build', 'flutter_app', 'build', 'linux', 'x64', 'bundle');
        extension = 'AppImage';
        break;
    }

    final outputFile = path.join(outputDir, '${appName}_$platform.$extension');
    
    // For now, just copy the executable/bundle
    // In production, you'd create a proper installer or self-contained package
    final sourceDir = Directory(executablePath);
    if (await sourceDir.exists()) {
      await _copyDirectory(sourceDir, Directory(path.join(outputDir, '${appName}_$platform')));
    }

    return path.join(outputDir, '${appName}_$platform');
  }

  Future<void> _copyDirectory(Directory source, Directory target) async {
    if (!await target.exists()) {
      await target.create(recursive: true);
    }

    await for (final entity in source.list(recursive: true)) {
      final relativePath = path.relative(entity.path, from: source.path);
      final targetPath = path.join(target.path, relativePath);

      if (entity is File) {
        final targetFile = File(targetPath);
        await targetFile.parent.create(recursive: true);
        await entity.copy(targetPath);
      } else if (entity is Directory && !await targetFile.parent.exists()) {
        await Directory(targetPath).create(recursive: true);
      }
    }
  }

  String _generatePubspec(BuildConfig config) {
    return '''
name: ${config.appName.replaceAll(' ', '_').toLowerCase()}
description: ${config.description ?? 'Desktop application built with Capsule'}
publish_to: 'none'
version: ${config.version ?? '1.0.0'}

environment:
  sdk: '>=3.2.0 <4.0.0'
  flutter: '>=3.16.0'

dependencies:
  flutter:
    sdk: flutter
  webview_flutter: ^4.4.2
  path_provider: ^2.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1

flutter:
  uses-material-design: true
  assets:
    - assets/web/
''';
  }

  String _generateMainDart(BuildConfig config) {
    return '''
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const CapsuleApp());
}

class CapsuleApp extends StatelessWidget {
  const CapsuleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${config.appName}',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ${_colorFromHex(config.primaryColor ?? '#2196F3')}),
        useMaterial3: true,
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('file:///assets/web/index.html'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('${config.appName}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
''';
  }

  String _colorFromHex(String hexColor) {
    // Simple conversion for common colors
    switch (hexColor.toUpperCase()) {
      case '#2196F3':
        return 'Colors.blue';
      case '#4CAF50':
        return 'Colors.green';
      case '#FF5722':
        return 'Colors.deepOrange';
      case '#9C27B0':
        return 'Colors.purple';
      case '#FFC107':
        return 'Colors.amber';
      default:
        return 'Colors.blue';
    }
  }

  String _getBuildTarget(TargetPlatform platform) {
    switch (platform) {
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.macos:
        return 'macos';
      case TargetPlatform.linux:
        return 'linux';
    }
  }

  Future<int> _getFileSize(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        return await file.length();
      }
    } catch (_) {}
    return 0;
  }
}

class BuildResult {
  final bool success;
  final String? outputPath;
  final List<String> steps;
  final Duration duration;
  final String? error;
  final int fileSize;

  BuildResult({
    required this.success,
    this.outputPath,
    required this.steps,
    required this.duration,
    this.error,
    this.fileSize = 0,
  });

  String get formattedDuration {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes}m ${seconds}s';
  }

  String get formattedFileSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
