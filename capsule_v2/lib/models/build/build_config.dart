import 'package:flutter/material.dart';

/// Build Configuration Model
class BuildConfig {
  final String projectId;
  final String outputDirectory;
  final String executableName;
  final bool compressAssets;
  final bool optimizeImages;
  final bool stripDebugSymbols;
  final bool createInstaller;
  final InstallerType installerType;
  final WindowConfig windowConfig;
  final List<BuildTarget> buildTargets;

  BuildConfig({
    required this.projectId,
    this.outputDirectory = '',
    this.executableName = '',
    this.compressAssets = true,
    this.optimizeImages = true,
    this.stripDebugSymbols = false,
    this.createInstaller = false,
    this.installerType = InstallerType.none,
    required this.windowConfig,
    this.buildTargets = const [],
  });

  BuildConfig copyWith({
    String? projectId,
    String? outputDirectory,
    String? executableName,
    bool? compressAssets,
    bool? optimizeImages,
    bool? stripDebugSymbols,
    bool? createInstaller,
    InstallerType? installerType,
    WindowConfig? windowConfig,
    List<BuildTarget>? buildTargets,
  }) {
    return BuildConfig(
      projectId: projectId ?? this.projectId,
      outputDirectory: outputDirectory ?? this.outputDirectory,
      executableName: executableName ?? this.executableName,
      compressAssets: compressAssets ?? this.compressAssets,
      optimizeImages: optimizeImages ?? this.optimizeImages,
      stripDebugSymbols: stripDebugSymbols ?? this.stripDebugSymbols,
      createInstaller: createInstaller ?? this.createInstaller,
      installerType: installerType ?? this.installerType,
      windowConfig: windowConfig ?? this.windowConfig,
      buildTargets: buildTargets ?? this.buildTargets,
    );
  }
}

/// Window Configuration
class WindowConfig {
  final double width;
  final double height;
  final double? minWidth;
  final double? minHeight;
  final double? maxWidth;
  final double? maxHeight;
  final bool resizable;
  final bool frameless;
  final bool alwaysOnTop;
  final String title;

  WindowConfig({
    this.width = 1024,
    this.height = 768,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.resizable = true,
    this.frameless = false,
    this.alwaysOnTop = false,
    this.title = 'Capsule App',
  });

  WindowConfig copyWith({
    double? width,
    double? height,
    double? minWidth,
    double? minHeight,
    double? maxWidth,
    double? maxHeight,
    bool? resizable,
    bool? frameless,
    bool? alwaysOnTop,
    String? title,
  }) {
    return WindowConfig(
      width: width ?? this.width,
      height: height ?? this.height,
      minWidth: minWidth ?? this.minWidth,
      minHeight: minHeight ?? this.minHeight,
      maxWidth: maxWidth ?? this.maxWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      resizable: resizable ?? this.resizable,
      frameless: frameless ?? this.frameless,
      alwaysOnTop: alwaysOnTop ?? this.alwaysOnTop,
      title: title ?? this.title,
    );
  }
}

/// Build Target (Platform + Architecture)
class BuildTarget {
  final BuildPlatform platform;
  final Architecture architecture;

  const BuildTarget({
    required this.platform,
    required this.architecture,
  });

  @override
  String toString() {
    return '${platform.name}_${architecture.name}';
  }
}

enum BuildPlatform {
  windows,
  macos,
  linux,
}

enum Architecture {
  x64,
  arm64,
}

enum InstallerType {
  none,
  msix,      // Windows
  dmg,       // macOS
  appImage,  // Linux
  snap,      // Linux
  flatpak,   // Linux
}

extension InstallerTypeExtension on InstallerType {
  String get displayName {
    switch (this) {
      case InstallerType.none:
        return 'None';
      case InstallerType.msix:
        return 'MSIX (Windows)';
      case InstallerType.dmg:
        return 'DMG (macOS)';
      case InstallerType.appImage:
        return 'AppImage (Linux)';
      case InstallerType.snap:
        return 'Snap (Linux)';
      case InstallerType.flatpak:
        return 'Flatpak (Linux)';
    }
  }
}
