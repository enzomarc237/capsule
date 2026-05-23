import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/project/project.dart';
import '../../state/providers/project_provider.dart';
import '../../ui/theme/app_theme.dart';

/// Project Setup Screen - Import web app and configure project
class ProjectSetupScreen extends ConsumerStatefulWidget {
  const ProjectSetupScreen({super.key});

  @override
  ConsumerState<ProjectSetupScreen> createState() => _ProjectSetupScreenState();
}

class _ProjectSetupScreenState extends ConsumerState<ProjectSetupScreen> {
  int _currentStep = 0;
  String? _selectedFolderPath;
  final _nameController = TextEditingController();
  final _versionController = TextEditingController(text: '1.0.0');
  final _authorController = TextEditingController();
  DetectedAppType? _detectedAppType;
  bool _isDetecting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _versionController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  Future<void> _selectFolder() async {
    try {
      final result = await FilePicker.platform.getDirectoryPath();
      if (result != null) {
        setState(() {
          _selectedFolderPath = result;
          _isDetecting = true;
        });

        // Simulate app type detection
        await Future.delayed(const Duration(milliseconds: 800));
        setState(() {
          _detectedAppType = DetectedAppType.static;
          _isDetecting = false;
          if (_nameController.text.isEmpty) {
            _nameController.text = result.split('/').last;
          }
        });
      }
    } catch (e) {
      debugPrint('Error selecting folder: $e');
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _createProject();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _createProject() {
    final project = Project(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      version: _versionController.text,
      author: _authorController.text,
      webAppPath: _selectedFolderPath!,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      targetPlatforms: [BuildPlatform.windows, BuildPlatform.macos],
      status: ProjectStatus.configuring,
    );

    ref.read(currentProjectProvider.notifier).setProject(project);
    ref.read(recentProjectsProvider.notifier).addProject(project);

    // Navigate to workspace
    Navigator.pushReplacementNamed(context, '/workspace');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Project'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _currentStep == 0 ? null : _previousStep,
            child: const Text('Back'),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: _canProceed ? _nextStep : null,
            child: Text(_currentStep == 2 ? 'Create' : 'Continue'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentStep + 1) / 3,
            backgroundColor: AppColors.gray100,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
          ),
          const SizedBox(height: 24),
          
          // Step indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStepIndicator(1, 'Import'),
              Container(
                width: 40,
                height: 1,
                color: _currentStep >= 1 ? AppColors.primaryBlue : AppColors.gray300,
              ),
              _buildStepIndicator(2, 'Configure'),
              Container(
                width: 40,
                height: 1,
                color: _currentStep >= 2 ? AppColors.primaryBlue : AppColors.gray300,
              ),
              _buildStepIndicator(3, 'Review'),
            ],
          ),
          const SizedBox(height: 32),

          // Step content
          Expanded(
            child: IndexedStack(
              index: _currentStep,
              children: [
                _buildImportStep(),
                _buildConfigureStep(),
                _buildReviewStep(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step - 1;
    final isComplete = _currentStep > step - 1;

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isComplete
                ? AppColors.primaryBlue
                : isActive
                    ? AppColors.primaryLight
                    : AppColors.gray100,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isComplete
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : Text(
                    '$step',
                    style: TextStyle(
                      color: isActive
                          ? AppColors.primaryBlue
                          : AppColors.gray500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.gray900 : AppColors.gray500,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildImportStep() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 1 of 3: Import Your Web App',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Select the build output folder from your web application',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.gray700,
                ),
          ),
          const SizedBox(height: AppSpacing.x2l),

          // Drop zone
          Expanded(
            child: GestureDetector(
              onTap: _selectFolder,
              onPerformDrop: (_) => _selectFolder(),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _selectedFolderPath != null
                        ? AppColors.successGreen
                        : AppColors.gray300,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  color: AppColors.gray50,
                ),
                child: Center(
                  child: _isDetecting
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              size: 64,
                              color: _selectedFolderPath != null
                                  ? AppColors.successGreen
                                  : AppColors.gray500,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              _selectedFolderPath != null
                                  ? 'Selected: ${_selectedFolderPath!.split('/').last}'
                                  : 'Drag & Drop Folder Here',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'or click to browse',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.gray500,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.small),
                              ),
                              child: Text(
                                'Supported: React, Vue, Angular, HTML',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppColors.gray700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigureStep() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 2 of 3: Configure Project',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Enter basic information about your desktop app',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.gray700,
                ),
          ),
          const SizedBox(height: AppSpacing.x2l),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'App Name',
                      hintText: 'My Desktop App',
                      prefixIcon: Icon(Icons.title),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _versionController,
                    decoration: const InputDecoration(
                      labelText: 'Version',
                      hintText: '1.0.0',
                      prefixIcon: Icon(Icons.tag),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      labelText: 'Author',
                      hintText: 'Your Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  
                  if (_detectedAppType != null)
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              'Detected: ${_detectedAppType!.displayName}',
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step 3 of 3: Review & Create',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Review your configuration before creating the project',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.gray700,
                ),
          ),
          const SizedBox(height: AppSpacing.x2l),

          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Name', _nameController.text),
                    const Divider(),
                    _buildInfoRow('Version', _versionController.text),
                    const Divider(),
                    _buildInfoRow('Author', _authorController.text.isEmpty ? 'Not specified' : _authorController.text),
                    const Divider(),
                    _buildInfoRow('Source', _selectedFolderPath ?? 'Not selected'),
                    const Divider(),
                    _buildInfoRow('Type', _detectedAppType?.displayName ?? 'Unknown'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.gray700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.gray900),
            ),
          ),
        ],
      ),
    );
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _selectedFolderPath != null;
      case 1:
        return _nameController.text.isNotEmpty;
      case 2:
        return true;
      default:
        return false;
    }
  }
}

enum DetectedAppType {
  react,
  vue,
  angular,
  svelte,
  static,
}

extension DetectedAppTypeExtension on DetectedAppType {
  String get displayName {
    switch (this) {
      case DetectedAppType.react:
        return 'React App';
      case DetectedAppType.vue:
        return 'Vue App';
      case DetectedAppType.angular:
        return 'Angular App';
      case DetectedAppType.svelte:
        return 'Svelte App';
      case DetectedAppType.static:
        return 'Static Site';
    }
  }
}
