import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import '../theme/app_theme.dart';

class PreviewWindow extends ConsumerStatefulWidget {
  final String projectPath;
  final String? indexHtmlPath;

  const PreviewWindow({
    super.key,
    required this.projectPath,
    this.indexHtmlPath,
  });

  @override
  ConsumerState<PreviewWindow> createState() => _PreviewWindowState();
}

class _PreviewWindowState extends ConsumerState<PreviewWindow> {
  late WebViewController? _controller;
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    if (widget.indexHtmlPath != null && File(widget.indexHtmlPath!).existsSync()) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              setState(() => _isLoading = true);
            },
            onPageFinished: (url) {
              setState(() => _isLoading = false);
            },
            onWebResourceError: (error) {
              setState(() {
                _error = 'Failed to load preview: ${error.description}';
                _isLoading = false;
              });
            },
          ),
        )
        ..loadFile(widget.indexHtmlPath!);
    } else {
      setState(() {
        _error = 'index.html not found in project directory';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.gray50,
      child: Column(
        children: [
          // Preview Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: AppTheme.gray300),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.preview, size: 20, color: AppTheme.gray700),
                const SizedBox(width: 8),
                const Text(
                  'Live Preview',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.gray900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.refresh, size: 20),
                  onPressed: () => _initializeWebView(),
                  tooltip: 'Refresh Preview',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.open_in_browser, size: 20),
                  onPressed: () {
                    // Open in external browser
                  },
                  tooltip: 'Open in Browser',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Preview Content
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildPreviewContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppTheme.errorRed,
            ),
            const SizedBox(height: 16),
            Text(
              _error,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.gray700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _initializeWebView(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading preview...',
              style: TextStyle(color: AppTheme.gray700),
            ),
          ],
        ),
      );
    }

    if (_controller != null) {
      return WebViewWidget(controller: _controller!);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.web_asset_off,
            size: 64,
            color: AppTheme.gray500,
          ),
          const SizedBox(height: 16),
          const Text(
            'No preview available',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.gray700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Make sure your project contains an index.html file',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
