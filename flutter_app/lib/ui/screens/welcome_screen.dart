import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../theme/app_theme.dart';
import 'project_setup_screen.dart';
import 'workspace_screen.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final List<Map<String, String>> _recentProjects = [];

  Future<void> _createNewProject() async {
    final result = await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Select Web App Directory',
    );

    if (result != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProjectSetupScreen(projectPath: result),
        ),
      );
    }
  }

  Future<void> _openExistingProject(String path) async {
    if (Directory(path).existsSync() && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkspaceScreen(projectPath: path),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryLight.withOpacity(0.3),
              AppTheme.gray50,
            ],
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo and Title
                Icon(
                  Icons.apps_rounded,
                  size: 80,
                  color: AppTheme.primaryBlue,
                ),
                const SizedBox(height: 24),
                Text(
                  'Capsule 2.1',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Transform web applications into standalone desktop executables',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.gray700,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                // New Project Button
                ElevatedButton.icon(
                  onPressed: _createNewProject,
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Create New Project'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Open Project Button
                OutlinedButton.icon(
                  onPressed: () => _createNewProject(),
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Open Project'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 20,
                    ),
                  ),
                ),

                // Recent Projects
                if (_recentProjects.isNotEmpty) ...[
                  const SizedBox(height: 48),
                  Text(
                    'Recent Projects',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  ..._recentProjects.map((project) => _buildRecentProjectCard(
                        project['name'] ?? 'Unnamed Project',
                        project['path'] ?? '',
                      )),
                ],

                // Quick Start Guide
                const SizedBox(height: 48),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: AppTheme.infoBlue,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Quick Start Guide',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildQuickStartStep(
                          '1',
                          'Select Your Web App',
                          'Choose the directory containing your built web application',
                        ),
                        _buildQuickStartStep(
                          '2',
                          'Configure Settings',
                          'Set app name, icon, and platform targets',
                        ),
                        _buildQuickStartStep(
                          '3',
                          'Preview & Build',
                          'See live preview and build for your target platforms',
                        ),
                      ],
                    ),
                  ),
                ),

                // Version Info
                const SizedBox(height: 24),
                Text(
                  'Version 2.1.0 • Built with Flutter',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentProjectCard(String name, String path) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.folder, color: AppTheme.primaryBlue),
        title: Text(name),
        subtitle: Text(
          path,
          style: Theme.of(context).textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => _openExistingProject(path),
        ),
        onTap: () => _openExistingProject(path),
      ),
    );
  }

  Widget _buildQuickStartStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
