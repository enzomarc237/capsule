import 'dart:io';
import 'package:path/path.dart' as path;

/// Service for detecting web project types and structures
class ProjectDetector {
  final String projectPath;

  ProjectDetector({required this.projectPath});

  /// Detects the type of web project
  Future<ProjectType> detectType() async {
    final directory = Directory(projectPath);
    if (!await directory.exists()) {
      throw Exception('Project path does not exist: $projectPath');
    }

    // Check for package.json (React, Vue, Angular, etc.)
    final packageJson = File(path.join(projectPath, 'package.json'));
    if (await packageJson.exists()) {
      final content = await packageJson.readAsString();
      
      if (content.contains('"react"') || content.contains('"react-dom"')) {
        return ProjectType.react;
      } else if (content.contains('"vue"')) {
        return ProjectType.vue;
      } else if (content.contains('"@angular/core"')) {
        return ProjectType.angular;
      } else if (content.contains('"svelte"')) {
        return ProjectType.svelte;
      } else if (content.contains('"next"')) {
        return ProjectType.nextjs;
      } else if (content.contains('"nuxt"')) {
        return ProjectType.nuxt;
      } else {
        return ProjectType.generic;
      }
    }

    // Check for index.html (static site)
    final indexHtml = File(path.join(projectPath, 'index.html'));
    if (await indexHtml.exists()) {
      return ProjectType.static;
    }

    // Check for dist/build folders
    if (await Directory(path.join(projectPath, 'dist')).exists() ||
        await Directory(path.join(projectPath, 'build')).exists()) {
      return ProjectType.built;
    }

    return ProjectType.unknown;
  }

  /// Finds the build output directory
  Future<String?> findBuildDirectory() async {
    final commonDirs = ['dist', 'build', 'out', 'public'];
    
    for (final dirName in commonDirs) {
      final dir = Directory(path.join(projectPath, dirName));
      if (await dir.exists()) {
        final indexHtml = File(path.join(dir.path, 'index.html'));
        if (await indexHtml.exists()) {
          return dir.path;
        }
      }
    }

    // Check root for index.html
    final rootIndex = File(path.join(projectPath, 'index.html'));
    if (await rootIndex.exists()) {
      return projectPath;
    }

    return null;
  }

  /// Validates the project structure
  Future<ProjectValidationResult> validate() async {
    final errors = <String>[];
    final warnings = <String>[];

    final directory = Directory(projectPath);
    if (!await directory.exists()) {
      errors.add('Project path does not exist');
      return ProjectValidationResult(isValid: false, errors: errors, warnings: warnings);
    }

    final projectType = await detectType();
    if (projectType == ProjectType.unknown) {
      errors.add('Could not detect project type. Ensure your project has a package.json or index.html');
    }

    final buildDir = await findBuildDirectory();
    if (buildDir == null && projectType != ProjectType.generic) {
      warnings.add('No build directory found. You may need to build your project first.');
    }

    // Check for common issues
    final nodeModules = Directory(path.join(projectPath, 'node_modules'));
    if (await nodeModules.exists()) {
      warnings.add('node_modules folder detected. Consider excluding it from the bundle.');
    }

    return ProjectValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      projectType: projectType,
      buildDirectory: buildDir,
    );
  }
}

enum ProjectType {
  react,
  vue,
  angular,
  svelte,
  nextjs,
  nuxt,
  static,
  built,
  generic,
  unknown,
}

class ProjectValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;
  final ProjectType? projectType;
  final String? buildDirectory;

  ProjectValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
    this.projectType,
    this.buildDirectory,
  });
}
