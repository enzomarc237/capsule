import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:io';

import '../theme/app_theme.dart';
import 'success_screen.dart';

class BuildProgressScreen extends ConsumerStatefulWidget {
  final String projectPath;
  final String projectName;
  final List<String> platforms;

  const BuildProgressScreen({
    super.key,
    required this.projectPath,
    required this.projectName,
    required this.platforms,
  });

  @override
  ConsumerState<BuildProgressScreen> createState() => _BuildProgressScreenState();
}

class _BuildProgressScreenState extends ConsumerState<BuildProgressScreen> {
  double _progress = 0.0;
  String _currentStage = 'Initializing...';
  List<String> _buildLogs = [];
  bool _isBuilding = true;
  bool _buildSuccess = false;
  String? _errorMessage;

  final List<Map<String, dynamic>> _stages = [
    {'name': 'Validation', 'progress': 0.17, 'icon': Icons.check_circle_outline},
    {'name': 'Preparation', 'progress': 0.33, 'icon': Icons.folder_copy_outlined},
    {'name': 'Code Generation', 'progress': 0.50, 'icon': Icons.code},
    {'name': 'Compilation', 'progress': 0.67, 'icon': Icons.build_circle_outlined},
    {'name': 'Packaging', 'progress': 0.83, 'icon': Icons.archive_outlined},
    {'name': 'Verification', 'progress': 1.0, 'icon': Icons.verified_outlined},
  ];

  @override
  void initState() {
    super.initState();
    _startBuild();
  }

  Future<void> _startBuild() async {
    try {
      for (var stage in _stages) {
        if (!mounted) return;

        setState(() {
          _currentStage = stage['name'];
          _addLog('Starting ${stage['name']} stage...');
        });

        // Simulate stage execution
        await _executeStage(stage['name']);

        setState(() {
          _progress = stage['progress'];
          _addLog('${stage['name']} completed successfully');
        });

        await Future.delayed(const Duration(milliseconds: 500));
      }

      // Build completed successfully
      setState(() {
        _isBuilding = false;
        _buildSuccess = true;
        _addLog('Build completed successfully!');
      });

      // Navigate to success screen after a delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              projectName: widget.projectName,
              outputPath: '/tmp/build/${widget.projectName}',
              platforms: widget.platforms,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isBuilding = false;
        _buildSuccess = false;
        _errorMessage = e.toString();
        _addLog('Build failed: $e');
      });
    }
  }

  Future<void> _executeStage(String stageName) async {
    // Simulate build process by calling the actual Dart build system
    // In real implementation, this would interface with the existing v2.0 build pipeline

    await Future.delayed(const Duration(seconds: 2));

    switch (stageName) {
      case 'Validation':
        _addLog('Checking Dart SDK...');
        _addLog('Validating project structure...');
        break;
      case 'Preparation':
        _addLog('Creating temporary build directory...');
        _addLog('Copying assets...');
        break;
      case 'Code Generation':
        _addLog('Loading server template...');
        _addLog('Compressing assets...');
        _addLog('Generating executable code...');
        break;
      case 'Compilation':
        for (var platform in widget.platforms) {
          _addLog('Compiling for $platform...');
        }
        break;
      case 'Packaging':
        _addLog('Creating distribution packages...');
        break;
      case 'Verification':
        _addLog('Testing executable...');
        _addLog('Verifying integrity...');
        break;
    }
  }

  void _addLog(String message) {
    setState(() {
      _buildLogs.add('[${DateTime.now().toString().substring(11, 19)}] $message');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Build Progress'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.gray900,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Header
            Text(
              widget.projectName,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              _currentStage,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.gray700,
                  ),
            ),
            const SizedBox(height: 32),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: _progress,
                minHeight: 12,
                backgroundColor: AppTheme.gray200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  _buildSuccess
                      ? AppTheme.successGreen
                      : _errorMessage != null
                          ? AppTheme.errorRed
                          : AppTheme.primaryBlue,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_progress * 100).toInt()}% Complete',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.right,
            ),

            const SizedBox(height: 32),

            // Build Stages
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _stages.map((stage) {
                final isCompleted = _progress >= stage['progress'];
                final isCurrent = _currentStage == stage['name'];

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppTheme.successGreen.withOpacity(0.1)
                        : isCurrent
                            ? AppTheme.primaryLight.withOpacity(0.5)
                            : AppTheme.gray100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCompleted
                          ? AppTheme.successGreen
                          : isCurrent
                              ? AppTheme.primaryBlue
                              : AppTheme.gray300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isCompleted ? Icons.check_circle : stage['icon'],
                        size: 16,
                        color: isCompleted
                            ? AppTheme.successGreen
                            : isCurrent
                                ? AppTheme.primaryBlue
                                : AppTheme.gray500,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        stage['name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                          color: isCompleted || isCurrent
                              ? AppTheme.gray900
                              : AppTheme.gray700,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Build Logs
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.terminal, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'Build Log',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.copy, size: 18),
                            onPressed: () {
                              // Copy logs to clipboard
                            },
                            tooltip: 'Copy Logs',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: AppTheme.gray900,
                        child: ListView.builder(
                          itemCount: _buildLogs.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                _buildLogs[index],
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 12,
                                  color: Color(0xFF00FF00),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Error Message
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Card(
                color: AppTheme.errorRed.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: AppTheme.errorRed),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: AppTheme.errorRed),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Action Buttons
            if (!_isBuilding) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!_buildSuccess)
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  if (_buildSuccess) ...[
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Will navigate automatically
                      },
                      icon: const Icon(Icons.check_circle),
                      label: const Text('View Results'),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
