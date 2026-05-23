import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project/project.dart';
import '../models/build/build_config.dart';
import '../services/project_detector.dart';
import '../services/build_service.dart';
import '../utils/file_utils.dart';
import '../utils/build_utils.dart';

/// Provider for the project detector service
final projectDetectorProvider = Provider<ProjectDetector>((ref) {
  return ProjectDetector();
});

/// Provider for the build service
final buildServiceProvider = Provider<BuildService>((ref) {
  return BuildService();
});

/// Provider for managing the current project state
final currentProjectProvider = StateNotifierProvider<ProjectNotifier, Project?>((ref) {
  return ProjectNotifier();
});

/// Notifier for managing project state
class ProjectNotifier extends StateNotifier<Project?> {
  ProjectNotifier() : super(null);

  void setProject(Project project) {
    state = project;
  }

  void updateProject(Project project) {
    state = project;
  }

  void clearProject() {
    state = null;
  }

  Future<void> loadProject(String path) async {
    final detector = ProjectDetector();
    final info = await detector.detectProject(path);
    
    if (info != null) {
      state = Project(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: info.projectName,
        sourcePath: path,
        framework: info.framework,
        buildDirectory: info.buildDirectory,
        entryFile: info.entryFile,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }
}

/// Provider for build configuration state
final buildConfigProvider = StateNotifierProvider<BuildConfigNotifier, BuildConfig?>((ref) {
  return BuildConfigNotifier();
});

/// Notifier for managing build configuration
class BuildConfigNotifier extends StateNotifier<BuildConfig?> {
  BuildConfigNotifier() : super(null);

  void setConfig(BuildConfig config) {
    state = config;
  }

  void updateConfig(BuildConfig config) {
    state = config;
  }

  void clearConfig() {
    state = null;
  }

  void setOutputName(String name) {
    if (state != null) {
      state = state!.copyWith(outputName: name);
    }
  }

  void setBundleId(String id) {
    if (state != null) {
      state = state!.copyWith(bundleId: id);
    }
  }

  void setVersion(String version) {
    if (state != null) {
      state = state!.copyWith(version: version);
    }
  }

  void togglePlatform(String platform, bool enabled) {
    if (state != null) {
      final platforms = Map<String, bool>.from(state!.targetPlatforms);
      platforms[platform] = enabled;
      state = state!.copyWith(targetPlatforms: platforms);
    }
  }
}

/// Provider for build progress state
final buildProgressProvider = StateNotifierProvider<BuildProgressNotifier, BuildProgress?>((ref) {
  return BuildProgressNotifier();
});

/// Notifier for managing build progress
class BuildProgressNotifier extends StateNotifier<BuildProgress?> {
  BuildProgressNotifier() : super(null);

  void updateProgress(BuildProgress progress) {
    state = progress;
  }

  void clearProgress() {
    state = null;
  }
}

/// Provider for build result state
final buildResultProvider = StateNotifierProvider<BuildResultNotifier, BuildResult?>((ref) {
  return BuildResultNotifier();
});

/// Notifier for managing build result
class BuildResultNotifier extends StateNotifier<BuildResult?> {
  BuildResultNotifier() : super(null);

  void setResult(BuildResult result) {
    state = result;
  }

  void clearResult() {
    state = null;
  }
}

/// Provider for recent projects list
final recentProjectsProvider = StateNotifierProvider<RecentProjectsNotifier, List<Project>>((ref) {
  return RecentProjectsNotifier();
});

/// Notifier for managing recent projects
class RecentProjectsNotifier extends StateNotifier<List<Project>> {
  RecentProjectsNotifier() : super([]);

  void addProject(Project project) {
    // Remove if already exists
    state = state.where((p) => p.id != project.id).toList();
    // Add to beginning
    state = [project, ...state].take(10).toList();
  }

  void removeProject(String projectId) {
    state = state.where((p) => p.id != projectId).toList();
  }

  void clearProjects() {
    state = [];
  }
}

/// Provider for live preview URL
final previewUrlProvider = StateProvider<String?>((ref) => null);

/// Provider for whether build is in progress
final isBuildingProvider = StateProvider<bool>((ref) => false);
