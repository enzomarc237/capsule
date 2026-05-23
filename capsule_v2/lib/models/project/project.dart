import 'package:flutter/material.dart';

/// Project Model - Represents a Capsule project
class Project {
  final String id;
  final String name;
  final String? description;
  final String version;
  final String author;
  final String webAppPath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<BuildPlatform> targetPlatforms;
  final ProjectStatus status;

  Project({
    required this.id,
    required this.name,
    this.description,
    this.version = '1.0.0',
    this.author = '',
    required this.webAppPath,
    required this.createdAt,
    required this.updatedAt,
    this.targetPlatforms = const [],
    this.status = ProjectStatus.draft,
  });

  Project copyWith({
    String? id,
    String? name,
    String? description,
    String? version,
    String? author,
    String? webAppPath,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<BuildPlatform>? targetPlatforms,
    ProjectStatus? status,
  }) {
    return Project(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      version: version ?? this.version,
      author: author ?? this.author,
      webAppPath: webAppPath ?? this.webAppPath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      targetPlatforms: targetPlatforms ?? this.targetPlatforms,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'version': version,
      'author': author,
      'webAppPath': webAppPath,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'targetPlatforms': targetPlatforms.map((p) => p.toString()).toList(),
      'status': status.toString(),
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      version: json['version'] as String? ?? '1.0.0',
      author: json['author'] as String? ?? '',
      webAppPath: json['webAppPath'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      targetPlatforms: (json['targetPlatforms'] as List<dynamic>?)
              ?.map((p) => BuildPlatform.values.firstWhere(
                    (e) => e.toString() == p,
                    orElse: () => BuildPlatform.windows,
                  ))
              .toList() ??
          [],
      status: ProjectStatus.values.firstWhere(
        (s) => s.toString() == json['status'],
        orElse: () => ProjectStatus.draft,
      ),
    );
  }
}

enum ProjectStatus {
  draft,
  configuring,
  building,
  completed,
  failed,
}

enum BuildPlatform {
  windows,
  macos,
  linux,
}

extension BuildPlatformExtension on BuildPlatform {
  String get displayName {
    switch (this) {
      case BuildPlatform.windows:
        return 'Windows';
      case BuildPlatform.macos:
        return 'macOS';
      case BuildPlatform.linux:
        return 'Linux';
    }
  }

  IconData get icon {
    switch (this) {
      case BuildPlatform.windows:
        return Icons.window;
      case BuildPlatform.macos:
        return Icons.apple;
      case BuildPlatform.linux:
        return Icons.terminal;
    }
  }
}
