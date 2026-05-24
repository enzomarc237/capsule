import 'dart:io';
import 'package:path/path.dart' as p;
import '../models/project/project.dart';
import '../models/build/build_config.dart';
import '../build/pipeline/build_pipeline.dart';
import 'asset_processor.dart';

/// Main build engine that orchestrates the build process
class BuildEngine {
  final AssetProcessor _assetProcessor;
  final BuildPipeline _pipeline;

  BuildEngine({
    AssetProcessor? assetProcessor,
    BuildPipeline? pipeline,
  })  : _assetProcessor = assetProcessor ?? AssetProcessor(),
        _pipeline = pipeline ?? BuildPipeline();

  Stream<BuildProgress> get progressStream => _pipeline.progressStream;

  /// Build a project with the given configuration
  Future<BuildResult> build(Project project, BuildConfig config) async {
    return await _pipeline.execute(project, config);
  }

  /// Generate the Dart code for the bundled application
  Future<String> generateApplicationCode(
    Project project,
    BuildConfig config,
    String assetsDir,
  ) async {
    // Compress and encode all assets
    final assets = await _assetProcessor.compressAndEncodeAssets(assetsDir);

    // Load the server template
    final template = await _loadServerTemplate();

    // Generate assets code
    final assetsCode = _assetProcessor.generateAssetsCode(assets);

    // Replace placeholders
    final code = template
        .replaceFirst('{{ASSETS}}', assetsCode)
        .replaceFirst('{{DEFAULT_PORT}}', '8080')
        .replaceFirst('{{DEFAULT_PORT}}', '8080')
        .replaceFirst('{{APP_NAME}}', project.name)
        .replaceFirst('{{APP_VERSION}}', project.version);

    return code;
  }

  /// Load the server template
  Future<String> _loadServerTemplate() async {
    // Try loading from the package location first
    final scriptPath = Platform.script.toFilePath();
    final packageTemplatePath =
        p.join(p.dirname(scriptPath), '../lib/templates/server_template.dart');

    try {
      return await File(packageTemplatePath).readAsString();
    } catch (e) {
      // Fallback to current directory
      final fallbackPath =
          p.join(Directory.current.path, 'lib/templates/server_template.dart');
      return await File(fallbackPath).readAsString();
    }
  }

  /// Create default build configuration for a project
  BuildConfig createDefaultBuildConfig(
    Project project, {
    String? outputDir,
    String? platform,
  }) {
    final currentPlatform = platform ?? _detectCurrentPlatform();

    return BuildConfig(
      projectId: project.id,
      appName: project.name.replaceAll(' ', '_').toLowerCase(),
      outputDir: outputDir ?? p.join(Directory.current.path, 'build'),
      platform: currentPlatform,
      architecture: _detectArchitecture(),
      compression: CompressionLevel.high,
      optimize: true,
    );
  }

  String _detectCurrentPlatform() {
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    return 'unknown';
  }

  String _detectArchitecture() {
    // This is a simplified detection
    // In a real implementation, we'd check the actual architecture
    return 'x64';
  }

  void dispose() {
    _pipeline.dispose();
  }
}
