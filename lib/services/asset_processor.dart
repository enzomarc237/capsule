import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;
import '../models/project/project.dart';
import '../models/build/build_config.dart';

/// Service for processing and optimizing assets
class AssetProcessor {
  /// Process all assets in a directory
  Future<List<Asset>> processDirectory(String directoryPath) async {
    final assets = <Asset>[];
    final dir = Directory(directoryPath);

    if (!await dir.exists()) {
      throw Exception('Directory does not exist: $directoryPath');
    }

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: directoryPath);
        final asset = await _processFile(entity, relativePath);
        assets.add(asset);
      }
    }

    return assets;
  }

  /// Process a single file
  Future<Asset> _processFile(File file, String relativePath) async {
    final bytes = await file.readAsBytes();
    final compressedBytes = gzip.encode(bytes);

    return Asset(
      path: relativePath,
      type: _getAssetType(relativePath),
      size: bytes.length,
      compressedSize: compressedBytes.length,
    );
  }

  /// Compress and encode assets for embedding
  Future<Map<String, String>> compressAndEncodeAssets(String directoryPath) async {
    final assets = <String, String>{};
    final dir = Directory(directoryPath);

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: directoryPath);
        final bytes = await entity.readAsBytes();
        final compressedBytes = gzip.encode(bytes);
        final encoded = base64Encode(compressedBytes);
        assets[relativePath] = encoded;
      }
    }

    return assets;
  }

  /// Calculate total size of assets
  Future<int> calculateDirectorySize(String directoryPath) async {
    var totalSize = 0;
    final dir = Directory(directoryPath);

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        totalSize += await entity.length();
      }
    }

    return totalSize;
  }

  String _getAssetType(String path) {
    final ext = p.extension(path).toLowerCase();
    switch (ext) {
      case '.html':
      case '.htm':
        return 'html';
      case '.css':
        return 'css';
      case '.js':
      case '.mjs':
        return 'javascript';
      case '.json':
        return 'json';
      case '.png':
      case '.jpg':
      case '.jpeg':
      case '.gif':
      case '.svg':
      case '.ico':
      case '.webp':
        return 'image';
      case '.woff':
      case '.woff2':
      case '.ttf':
      case '.otf':
      case '.eot':
        return 'font';
      case '.mp4':
      case '.webm':
      case '.mp3':
      case '.wav':
      case '.ogg':
        return 'media';
      default:
        return 'binary';
    }
  }

  /// Generate compressed assets map as Dart code
  String generateAssetsCode(Map<String, String> assets) {
    final buffer = StringBuffer();
    assets.forEach((path, content) {
      buffer.writeln("  '$path': '$content',");
    });
    return buffer.toString();
  }
}
