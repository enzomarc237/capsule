import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

import '../theme/app_theme.dart';
import '../widgets/config_panel.dart';
import '../widgets/preview_window.dart';
import 'build_progress_screen.dart';

class WorkspaceScreen extends ConsumerStatefulWidget {
  final String projectPath;
  final String? projectName;
  final String? version;
  final String? author;
  final String? iconPath;
  final List<String>? platforms;

  const WorkspaceScreen({
    super.key,
    required this.projectPath,
    this.projectName,
    this.version,
    this.author,
    this.iconPath,
    this.platforms,
  });

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen> {
  late WebViewController _webViewController;
  bool _isPreviewLoading = true;
  String? _indexHtmlPath;

  @override
  void initState() {
    super.initState();
    _initializePreview();
  }

  void _initializePreview() {
    // Find index.html
    final indexFile = File('${widget.projectPath}/index.html');
    if (indexFile.existsSync()) {
      _indexHtmlPath = indexFile.path;
      _webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              setState(() => _isPreviewLoading = true);
            },
            onPageFinished: (url) {
              setState(() => _isPreviewLoading = false);
            },
          ),
        )
        ..loadFile(_indexHtmlPath!);
    }
  }

  void _startBuild() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BuildProgressScreen(
          projectPath: widget.projectPath,
          projectName: widget.projectName ?? 'Unnamed Project',
          platforms: widget.platforms ?? ['linux'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName ?? 'Workspace'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.gray900,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Open settings dialog
            },
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          // Left Panel - Configuration
          Container(
            width: 350,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                right: BorderSide(color: AppTheme.gray300),
              ),
            ),
            child: ConfigPanel(
              projectPath: widget.projectPath,
              projectName: widget.projectName,
              version: widget.version,
              author: widget.author,
              iconPath: widget.iconPath,
              platforms: widget.platforms ?? ['linux'],
            ),
          ),

          // Right Panel - Preview Window
          Expanded(
            child: PreviewWindow(
              projectPath: widget.projectPath,
              indexHtmlPath: _indexHtmlPath,
            ),
          ),
        ],
      ),

      // Bottom Action Bar
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppTheme.gray300),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              onPressed: () => _initializePreview(),
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Preview'),
            ),
            const SizedBox(width: 16),
            ElevatedButton.icon(
              onPressed: _startBuild,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Build'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
