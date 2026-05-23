/// Configuration for code signing
class SigningConfig {
  final String? certificatePath;
  final String? certificatePassword;
  final String? developerId;
  final String? timestampServer;

  const SigningConfig({
    this.certificatePath,
    this.certificatePassword,
    this.developerId,
    this.timestampServer = 'http://timestamp.digicert.com',
  });

  bool get hasCertificate => certificatePath != null;
  bool get hasDeveloperId => developerId != null;
}

/// Asset compression utilities
class AssetCompressor {
  /// Compress a file using GZip
  static Future<List<int>> compressGzip(List<int> data) async {
    // In production, use gzip package
    return data; // Placeholder
  }

  /// Compress all assets in a directory
  static Future<void> compressDirectory(String sourceDir, String outputDir) async {
    final source = Directory(sourceDir);
    final output = Directory(outputDir);
    await output.create(recursive: true);

    await for (final entity in source.list(recursive: true)) {
      if (entity is File) {
        final relativePath = entity.path.substring(sourceDir.length + 1);
        final outputPath = '$outputDir/$relativePath.gz';
        
        final data = await entity.readAsBytes();
        final compressed = await compressGzip(data);
        await File(outputPath).writeAsBytes(compressed);
      } else if (entity is Directory) {
        final relativePath = entity.path.substring(sourceDir.length + 1);
        await Directory('$outputDir/$relativePath').create(recursive: true);
      }
    }
  }

  /// Get compression ratio
  static double getCompressionRatio(int originalSize, int compressedSize) {
    if (originalSize == 0) return 0;
    return ((originalSize - compressedSize) / originalSize) * 100;
  }
}

/// Build progress tracking
class BuildProgress {
  final String stage;
  final String message;
  final double progress; // 0.0 to 1.0
  final DateTime timestamp;

  const BuildProgress({
    required this.stage,
    required this.message,
    required this.progress,
    required this.timestamp,
  });

  factory BuildProgress.validation(String message) {
    return BuildProgress(
      stage: 'Validation',
      message: message,
      progress: 0.1,
      timestamp: DateTime.now(),
    );
  }

  factory BuildProgress.preparation(String message) {
    return BuildProgress(
      stage: 'Preparation',
      message: message,
      progress: 0.3,
      timestamp: DateTime.now(),
    );
  }

  factory BuildProgress.assetCopy(String message) {
    return BuildProgress(
      stage: 'Asset Copy',
      message: message,
      progress: 0.5,
      timestamp: DateTime.now(),
    );
  }

  factory BuildProgress.wrapperGeneration(String message) {
    return BuildProgress(
      stage: 'Wrapper Generation',
      message: message,
      progress: 0.7,
      timestamp: DateTime.now(),
    );
  }

  factory BuildProgress.compilation(String message) {
    return BuildProgress(
      stage: 'Compilation',
      message: message,
      progress: 0.85,
      timestamp: DateTime.now(),
    );
  }

  factory BuildProgress.packaging(String message) {
    return BuildProgress(
      stage: 'Packaging',
      message: message,
      progress: 0.95,
      timestamp: DateTime.now(),
    );
  }

  factory BuildProgress.complete(String message) {
    return BuildProgress(
      stage: 'Complete',
      message: message,
      progress: 1.0,
      timestamp: DateTime.now(),
    );
  }
}

/// Build result containing output information
class BuildResult {
  final bool success;
  final String? outputPath;
  final List<String> errors;
  final List<String> warnings;
  final Duration duration;
  final int originalSize;
  final int compressedSize;

  const BuildResult({
    required this.success,
    this.outputPath,
    this.errors = const [],
    this.warnings = const [],
    this.duration = Duration.zero,
    this.originalSize = 0,
    this.compressedSize = 0,
  });

  double get compressionRatio {
    if (originalSize == 0) return 0;
    return ((originalSize - compressedSize) / originalSize) * 100;
  }

  String get fileSizeString {
    if (compressedSize < 1024) return '$compressedSize B';
    if (compressedSize < 1024 * 1024) return '${(compressedSize / 1024).toStringAsFixed(1)} KB';
    return '${(compressedSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
