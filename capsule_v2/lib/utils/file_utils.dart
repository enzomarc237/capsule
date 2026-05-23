import 'dart:io';

/// File system utilities for Capsule
class FileUtils {
  /// Get total size of a directory in bytes
  static Future<int> getDirectorySize(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) return 0;

    int totalSize = 0;
    await for (final entity in directory.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }
    return totalSize;
  }

  /// Format bytes to human-readable string
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Check if directory is empty
  static Future<bool> isDirectoryEmpty(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) return true;
    
    await for (final _ in directory.list()) {
      return false;
    }
    return true;
  }

  /// Copy directory recursively
  static Future<void> copyDirectory(Directory source, Directory destination) async {
    await for (final entity in source.list(recursive: true)) {
      final relativePath = entity.path.substring(source.path.length + 1);
      final newPath = '${destination.path}/$relativePath';

      if (entity is Directory) {
        await Directory(newPath).create(recursive: true);
      } else if (entity is File) {
        await entity.copy(newPath);
      }
    }
  }

  /// Delete directory recursively
  static Future<void> deleteDirectory(String path) async {
    final directory = Directory(path);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  /// Create directory if it doesn't exist
  static Future<void> ensureDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  /// Find files by extension in a directory
  static Future<List<File>> findFilesByExtension(String directory, String extension) async {
    final files = <File>[];
    final dir = Directory(directory);
    
    if (!await dir.exists()) return files;

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith(extension)) {
        files.add(entity);
      }
    }
    return files;
  }

  /// Validate that a path exists and is accessible
  static Future<bool> validatePath(String path, {bool mustBeDirectory = true}) async {
    try {
      final fsEntity = FileSystemEntity.typeSync(path);
      if (mustBeDirectory && fsEntity != FileSystemEntityType.directory) {
        return false;
      }
      
      // Test read/write access
      final testDir = Directory('$path/.capsule_test');
      await testDir.create();
      await testDir.delete();
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get file extension
  static String getFileExtension(String path) {
    final lastDot = path.lastIndexOf('.');
    if (lastDot == -1 || lastDot >= path.length - 1) return '';
    return path.substring(lastDot + 1).toLowerCase();
  }

  /// Get file name without extension
  static String getFileNameWithoutExtension(String path) {
    final fileName = path.split(Platform.pathSeparator).last;
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot == -1) return fileName;
    return fileName.substring(0, lastDot);
  }

  /// Normalize path separators for current platform
  static String normalizePath(String path) {
    return path.replaceAll('/', Platform.pathSeparator);
  }
}
