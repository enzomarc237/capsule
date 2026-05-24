import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

import '../theme/app_theme.dart';
import 'welcome_screen.dart';

class SuccessScreen extends ConsumerWidget {
  final String projectName;
  final String outputPath;
  final List<String> platforms;

  const SuccessScreen({
    super.key,
    required this.projectName,
    required this.outputPath,
    required this.platforms,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Complete'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.gray900,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Success Icon
              const Icon(
                Icons.check_circle,
                size: 80,
                color: AppTheme.successGreen,
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'Build Successful!',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppTheme.successGreen,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your application has been bundled successfully',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.gray700,
                    ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Build Summary Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Build Summary',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      _buildSummaryRow(
                        Icons.label,
                        'Project Name',
                        projectName,
                      ),
                      _buildSummaryRow(
                        Icons.folder_open,
                        'Output Location',
                        outputPath,
                      ),
                      _buildSummaryRow(
                        Icons.devices,
                        'Platforms',
                        platforms.join(', '),
                      ),
                      _buildSummaryRow(
                        Icons.access_time,
                        'Build Time',
                        '~12 seconds',
                      ),
                      _buildSummaryRow(
                        Icons.storage,
                        'Bundle Size',
                        '~12.5 MB',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      // Open output folder
                    },
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Open Folder'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Test executable
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Test App'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // New Build Button
              TextButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Create New Build'),
              ),

              const SizedBox(height: 32),

              // Next Steps Card
              Card(
                color: AppTheme.primaryLight.withOpacity(0.3),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.lightbulb_outline,
                            color: AppTheme.infoBlue,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Next Steps',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildNextStepItem(
                        '1',
                        'Test your application on target platforms',
                      ),
                      _buildNextStepItem(
                        '2',
                        'Configure code signing for production distribution',
                      ),
                      _buildNextStepItem(
                        '3',
                        'Set up auto-update mechanism for your users',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.gray700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.gray700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
