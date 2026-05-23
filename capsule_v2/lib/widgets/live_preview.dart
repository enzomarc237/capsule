import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Widget for live preview of web applications
class LivePreviewWidget extends StatefulWidget {
  final String sourcePath;
  final String? buildDirectory;

  const LivePreviewWidget({
    super.key,
    required this.sourcePath,
    this.buildDirectory,
  });

  @override
  State<LivePreviewWidget> createState() => _LivePreviewWidgetState();
}

class _LivePreviewWidgetState extends State<LivePreviewWidget> {
  late final WebViewController controller;
  bool isLoading = true;
  String? errorMessage;
  String? previewUrl;

  @override
  void initState() {
    super.initState();
    _initializePreview();
  }

  Future<void> _initializePreview() async {
    try {
      // Determine the directory to serve
      final previewDir = widget.buildDirectory ?? widget.sourcePath;
      
      // Check if index.html exists
      final indexHtml = File('$previewDir/index.html');
      if (!await indexHtml.exists()) {
        setState(() {
          errorMessage = 'No index.html found in the project directory';
          isLoading = false;
        });
        return;
      }

      // For live preview, we'll use a simple file:// URL
      // In production, you might want to spin up a local HTTP server
      final fileUri = Uri.file('$previewDir/index.html');
      
      setState(() {
        previewUrl = fileUri.toString();
      });

      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (String url) {
              setState(() {
                isLoading = true;
              });
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false;
              });
            },
            onWebResourceError: (WebResourceError error) {
              setState(() {
                errorMessage = 'Error: ${error.description}';
                isLoading = false;
              });
            },
          ),
        )
        ..loadRequest(fileUri);
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to initialize preview: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          // Preview toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.visibility, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Live Preview',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const Spacer(),
                if (isLoading)
                  const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ),
          // Preview content
          Expanded(
            child: isLoading && controller == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Loading preview...',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              errorMessage!,
                              style: TextStyle(color: Colors.red[700]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _initializePreview,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : WebViewWidget(controller: controller),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Controller cleanup handled by WebViewWidget
    super.dispose();
  }
}
