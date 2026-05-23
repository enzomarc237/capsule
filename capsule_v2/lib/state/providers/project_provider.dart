import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/project/project.dart';

/// Provider for current project state
final currentProjectProvider = StateNotifierProvider<ProjectNotifier, Project?>((ref) {
  return ProjectNotifier();
});

/// Provider for list of recent projects
final recentProjectsProvider = StateNotifierProvider<ProjectsListNotifier, List<Project>>((ref) {
  return ProjectsListNotifier();
});

/// Notifier for managing current project
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
}

/// Notifier for managing projects list
class ProjectsListNotifier extends StateNotifier<List<Project>> {
  ProjectsListNotifier() : super([]);

  void addProject(Project project) {
    state = [project, ...state];
  }

  void removeProject(String projectId) {
    state = state.where((p) => p.id != projectId).toList();
  }

  void updateProject(Project updatedProject) {
    state = state.map((p) {
      if (p.id == updatedProject.id) {
        return updatedProject;
      }
      return p;
    }).toList();
  }

  void loadProjects(List<Project> projects) {
    state = projects;
  }
}

/// Provider for build configuration state
final buildConfigProvider = StateNotifierProvider<BuildConfigNotifier, BuildConfigState>((ref) {
  return BuildConfigNotifier();
});

class BuildConfigState {
  final bool isBuilding;
  final double progress;
  final String? currentStage;
  final List<String> logs;
  final BuildResult? lastResult;

  BuildConfigState({
    this.isBuilding = false,
    this.progress = 0.0,
    this.currentStage,
    this.logs = const [],
    this.lastResult,
  });

  BuildConfigState copyWith({
    bool? isBuilding,
    double? progress,
    String? currentStage,
    List<String>? logs,
    BuildResult? lastResult,
  }) {
    return BuildConfigState(
      isBuilding: isBuilding ?? this.isBuilding,
      progress: progress ?? this.progress,
      currentStage: currentStage ?? this.currentStage,
      logs: logs ?? this.logs,
      lastResult: lastResult ?? this.lastResult,
    );
  }
}

class BuildResult {
  final bool success;
  final List<String> outputPaths;
  final String? errorMessage;
  final Duration buildTime;

  BuildResult({
    required this.success,
    this.outputPaths = const [],
    this.errorMessage,
    required this.buildTime,
  });
}

class BuildConfigNotifier extends StateNotifier<BuildConfigState> {
  BuildConfigNotifier() : super(BuildConfigState());

  void startBuild() {
    state = state.copyWith(isBuilding: true, progress: 0.0);
  }

  void updateProgress(double progress, String stage) {
    state = state.copyWith(progress: progress, currentStage: stage);
  }

  void addLog(String message) {
    state = state.copyWith(logs: [...state.logs, message]);
  }

  void completeBuild(BuildResult result) {
    state = state.copyWith(
      isBuilding: false,
      progress: 1.0,
      lastResult: result,
    );
  }

  void failBuild(String error) {
    state = state.copyWith(
      isBuilding: false,
      lastResult: BuildResult(
        success: false,
        errorMessage: error,
        buildTime: Duration.zero,
      ),
    );
  }

  void reset() {
    state = BuildConfigState();
  }
}
