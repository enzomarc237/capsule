/// Represents a Capsule project
class Project {
  final String id;
  final String name;
  final String description;
  final String version;
  final String author;
  final String license;
  final String sourcePath;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProjectConfig config;
  final List<Asset> assets;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.version,
    required this.author,
    required this.license,
    required this.sourcePath,
    required this.createdAt,
    required this.updatedAt,
    required this.config,
    required this.assets,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'version': version,
        'author': author,
        'license': license,
        'sourcePath': sourcePath,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'config': config.toJson(),
        'assets': assets.map((a) => a.toJson()).toList(),
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        version: json['version'] as String,
        author: json['author'] as String,
        license: json['license'] as String,
        sourcePath: json['sourcePath'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        config: ProjectConfig.fromJson(json['config'] as Map<String, dynamic>),
        assets: (json['assets'] as List)
            .map((a) => Asset.fromJson(a as Map<String, dynamic>))
            .toList(),
      );

  Project copyWith({
    String? name,
    String? description,
    String? version,
    String? author,
    String? license,
    ProjectConfig? config,
    List<Asset>? assets,
  }) =>
      Project(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        version: version ?? this.version,
        author: author ?? this.author,
        license: license ?? this.license,
        sourcePath: sourcePath,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
        config: config ?? this.config,
        assets: assets ?? this.assets,
      );
}

class ProjectConfig {
  final WindowConfig window;
  final Map<String, PlatformConfig> platforms;
  final Map<String, String> environment;
  final List<String> permissions;

  ProjectConfig({
    required this.window,
    required this.platforms,
    required this.environment,
    required this.permissions,
  });

  Map<String, dynamic> toJson() => {
        'window': window.toJson(),
        'platforms': platforms.map((k, v) => MapEntry(k, v.toJson())),
        'environment': environment,
        'permissions': permissions,
      };

  factory ProjectConfig.fromJson(Map<String, dynamic> json) => ProjectConfig(
        window: WindowConfig.fromJson(json['window'] as Map<String, dynamic>),
        platforms: (json['platforms'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, PlatformConfig.fromJson(v as Map<String, dynamic>)),
        ),
        environment: Map<String, String>.from(json['environment'] as Map),
        permissions: List<String>.from(json['permissions'] as List),
      );
}

class WindowConfig {
  final int width;
  final int height;
  final int? minWidth;
  final int? minHeight;
  final int? maxWidth;
  final int? maxHeight;
  final bool resizable;
  final bool frameless;
  final bool alwaysOnTop;
  final String title;

  WindowConfig({
    required this.width,
    required this.height,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.resizable = true,
    this.frameless = false,
    this.alwaysOnTop = false,
    required this.title,
  });

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'minWidth': minWidth,
        'minHeight': minHeight,
        'maxWidth': maxWidth,
        'maxHeight': maxHeight,
        'resizable': resizable,
        'frameless': frameless,
        'alwaysOnTop': alwaysOnTop,
        'title': title,
      };

  factory WindowConfig.fromJson(Map<String, dynamic> json) => WindowConfig(
        width: json['width'] as int,
        height: json['height'] as int,
        minWidth: json['minWidth'] as int?,
        minHeight: json['minHeight'] as int?,
        maxWidth: json['maxWidth'] as int?,
        maxHeight: json['maxHeight'] as int?,
        resizable: json['resizable'] as bool? ?? true,
        frameless: json['frameless'] as bool? ?? false,
        alwaysOnTop: json['alwaysOnTop'] as bool? ?? false,
        title: json['title'] as String,
      );
}

class PlatformConfig {
  final bool enabled;
  final List<String> architectures;
  final bool codeSign;
  final String? certificate;
  final bool createInstaller;
  final String? packageFormat;

  PlatformConfig({
    required this.enabled,
    required this.architectures,
    this.codeSign = false,
    this.certificate,
    this.createInstaller = false,
    this.packageFormat,
  });

  Map<String, dynamic> toJson() => {
        'enabled': enabled,
        'architectures': architectures,
        'codeSign': codeSign,
        'certificate': certificate,
        'createInstaller': createInstaller,
        'packageFormat': packageFormat,
      };

  factory PlatformConfig.fromJson(Map<String, dynamic> json) => PlatformConfig(
        enabled: json['enabled'] as bool,
        architectures: List<String>.from(json['architectures'] as List),
        codeSign: json['codeSign'] as bool? ?? false,
        certificate: json['certificate'] as String?,
        createInstaller: json['createInstaller'] as bool? ?? false,
        packageFormat: json['packageFormat'] as String?,
      );
}

class Asset {
  final String path;
  final String type;
  final int size;
  final int? compressedSize;

  Asset({
    required this.path,
    required this.type,
    required this.size,
    this.compressedSize,
  });

  Map<String, dynamic> toJson() => {
        'path': path,
        'type': type,
        'size': size,
        'compressedSize': compressedSize,
      };

  factory Asset.fromJson(Map<String, dynamic> json) => Asset(
        path: json['path'] as String,
        type: json['type'] as String,
        size: json['size'] as int,
        compressedSize: json['compressedSize'] as int?,
      );
}
