import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as p;
import '../models/project/project.dart';
import 'asset_processor.dart';

/// Service for managing projects
class ProjectService {
  final AssetProcessor _assetProcessor;

  ProjectService({AssetProcessor? assetProcessor})
      : _assetProcessor = assetProcessor ?? AssetProcessor();

  /// Create a new project from a web app directory
  Future<Project> createFromDirectory(
    String sourcePath, {
    String? name,
    String? description,
  }) async {
    final dir = Directory(sourcePath);
    if (!await dir.exists()) {
      throw Exception('Source directory does not exist: $sourcePath');
    }

    // Detect app type and extract metadata
    final detectedName = name ?? p.basename(sourcePath);
    final appType = await _detectAppType(sourcePath);

    // Process assets
    final assets = await _assetProcessor.processDirectory(sourcePath);

    // Create default configuration
    final config = _createDefaultConfig(detectedName);

    final project = Project(
      id: const Uuid().v4(),
      name: detectedName,
      description: description ?? 'Web application bundled with Capsule',
      version: '1.0.0',
      author: '',
      license: 'MIT',
      sourcePath: sourcePath,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      config: config,
      assets: assets,
    );

    return project;
  }

  /// Detect the type of web application
  Future<String> _detectAppType(String sourcePath) async {
    // Check for index.html
    if (await File('$sourcePath/index.html').exists()) {
      // Check for common framework markers
      final packageJson = File('$sourcePath/package.json');
      if (await packageJson.exists()) {
        final content = await packageJson.readAsString();
        if (content.contains('"react"')) return 'React';
        if (content.contains('"vue"')) return 'Vue';
        if (content.contains('"@angular/core"')) return 'Angular';
        if (content.contains('"svelte"')) return 'Svelte';
        return 'Node.js Web App';
      }
      return 'Static Website';
    }

    return 'Unknown';
  }

  /// Create default project configuration
  ProjectConfig _createDefaultConfig(String appName) {
    return ProjectConfig(
      window: WindowConfig(
        width: 1280,
        height: 720,
        minWidth: 800,
        minHeight: 600,
        resizable: true,
        frameless: false,
        alwaysOnTop: false,
        title: appName,
      ),
      platforms: {
        'windows': PlatformConfig(
          enabled: true,
          architectures: ['x64'],
        ),
        'macos': PlatformConfig(
          enabled: true,
          architectures: ['x64', 'arm64'],
        ),
        'linux': PlatformConfig(
          enabled: true,
          architectures: ['x64'],
        ),
      },
      environment: {},
      permissions: [],
    );
  }

  /// Validate project structure
  Future<bool> validateProject(Project project) async {
    final dir = Directory(project.sourcePath);
    if (!await dir.exists()) {
      return false;
    }

    // Check for index.html
    final indexFile = File('${project.sourcePath}/index.html');
    return await indexFile.exists();
  }

  /// Update project
  Project updateProject(
    Project project, {
    String? name,
    String? description,
    String? version,
    String? author,
    String? license,
    ProjectConfig? config,
  }) {
    return project.copyWith(
      name: name,
      description: description,
      version: version,
      author: author,
      license: license,
      config: config,
    );
  }
}
