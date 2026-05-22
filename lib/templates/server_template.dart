import 'dart:io';
import 'dart:convert';

// The compressed embedded assets will be injected here
const Map<String, String> embeddedAssets = {
{{ASSETS}}
};

void main() async {
  final portStr = Platform.environment['PORT'] ?? '{{DEFAULT_PORT}}';
  final port = int.tryParse(portStr) ?? {{DEFAULT_PORT}};

  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
  print('Serving web app (Compressed) at http://${server.address.host}:${server.port}');

  await for (HttpRequest request in server) {
    handleRequest(request);
  }
}

void handleRequest(HttpRequest request) {
  var path = request.uri.path.replaceFirst('/', '');
  if (path.isEmpty) path = 'index.html';

  if (!embeddedAssets.containsKey(path)) {
    path = 'index.html';
  }

  final content = embeddedAssets[path];
  if (content == null) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write('Not Found')
      ..close();
    return;
  }

  final compressedBytes = base64Decode(content);
  
  // Check if browser supports gzip
  final acceptEncoding = request.headers.value(HttpHeaders.acceptEncodingHeader) ?? '';
  final supportsGzip = acceptEncoding.contains('gzip');

  if (supportsGzip) {
    // Send compressed bytes directly
    request.response
      ..headers.set(HttpHeaders.contentEncodingHeader, 'gzip')
      ..headers.contentType = _getContentType(path)
      ..add(compressedBytes)
      ..close();
  } else {
    // Decompress for legacy browsers
    final bytes = gzip.decode(compressedBytes);
    request.response
      ..headers.contentType = _getContentType(path)
      ..add(bytes)
      ..close();
  }
}

ContentType _getContentType(String path) {
  if (path.endsWith('.html')) return ContentType.html;
  if (path.endsWith('.js')) return ContentType('application', 'javascript');
  if (path.endsWith('.css')) return ContentType('text', 'css');
  if (path.endsWith('.png')) return ContentType('image', 'png');
  if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return ContentType('image', 'jpeg');
  if (path.endsWith('.svg')) return ContentType('image', 'svg+xml');
  if (path.endsWith('.ico')) return ContentType('image', 'x-icon');
  if (path.endsWith('.json')) return ContentType.json;
  return ContentType.binary;
}
