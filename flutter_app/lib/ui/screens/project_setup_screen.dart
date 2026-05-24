import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../theme/app_theme.dart';
import 'workspace_screen.dart';

class ProjectSetupScreen extends ConsumerStatefulWidget {
  final String projectPath;

  const ProjectSetupScreen({
    super.key,
    required this.projectPath,
  });

  @override
  ConsumerState<ProjectSetupScreen> createState() => _ProjectSetupScreenState();
}

class _ProjectSetupScreenState extends ConsumerState<ProjectSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _versionController;
  late TextEditingController _authorController;
  String? _iconPath;
  String _appType = 'static';
  final List<String> _selectedPlatforms = ['linux'];

  @override
  void initState() {
    super.initState();
    final projectName = widget.projectPath.split(Platform.pathSeparator).last;
    _nameController = TextEditingController(text: projectName);
    _versionController = TextEditingController(text: '1.0.0');
    _authorController = TextEditingController();
    _detectAppType();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _versionController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  void _detectAppType() {
    final directory = Directory(widget.projectPath);
    if (!directory.existsSync()) return;

    final files = directory.listSync().map((e) => e.path.split('/').last).toList();

    if (files.contains('package.json')) {
      setState(() => _appType = 'react/vue/angular');
    } else if (files.contains('index.html')) {
      setState(() => _appType = 'static');
    } else {
      setState(() => _appType = 'other');
    }
  }

  Future<void> _selectIcon() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      dialogTitle: 'Select App Icon',
    );

    if (result != null && result.files.single.path != null) {
      setState(() => _iconPath = result.files.single.path);
    }
  }

  void _togglePlatform(String platform) {
    setState(() {
      if (_selectedPlatforms.contains(platform)) {
        if (_selectedPlatforms.length > 1) {
          _selectedPlatforms.remove(platform);
        }
      } else {
        _selectedPlatforms.add(platform);
      }
    });
  }

  void _proceedToWorkspace() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WorkspaceScreen(
            projectPath: widget.projectPath,
            projectName: _nameController.text,
            version: _versionController.text,
            author: _authorController.text,
            iconPath: _iconPath,
            platforms: _selectedPlatforms,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Setup'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.gray900,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(48),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Project Info Section
                  Text(
                    'Project Information',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),

                  // Project Path (Read-only)
                  TextFormField(
                    initialValue: widget.projectPath,
                    decoration: const InputDecoration(
                      labelText: 'Project Path',
                      prefixIcon: Icon(Icons.folder),
                      enabled: false,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // App Name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'App Name *',
                      hintText: 'My Awesome App',
                      prefixIcon: Icon(Icons.label),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an app name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Version
                  TextFormField(
                    controller: _versionController,
                    decoration: const InputDecoration(
                      labelText: 'Version',
                      hintText: '1.0.0',
                      prefixIcon: Icon(Icons.tag),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Author
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      labelText: 'Author',
                      hintText: 'Your Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // App Type (Auto-detected)
                  Card(
                    color: AppTheme.primaryLight.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: AppTheme.infoBlue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Auto-detected App Type',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  _appType,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // App Icon Section
                  Text(
                    'App Icon',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      if (_iconPath != null)
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.gray300),
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: FileImage(File(_iconPath!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      else
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.gray100,
                            border: Border.all(color: AppTheme.gray300),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.image, size: 32, color: AppTheme.gray500),
                        ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _selectIcon,
                        icon: const Icon(Icons.upload),
                        label: Text(_iconPath == null ? 'Upload Icon' : 'Change Icon'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Platform Selection
                  Text(
                    'Target Platforms',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 16),

                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildPlatformChip('Windows', 'windows', Icons.desktop_windows),
                      _buildPlatformChip('macOS', 'macos', Icons.laptop_mac),
                      _buildPlatformChip('Linux', 'linux', Icons.computer),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _proceedToWorkspace,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Continue'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformChip(String label, String platform, IconData icon) {
    final isSelected = _selectedPlatforms.contains(platform);

    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      onSelected: (_) => _togglePlatform(platform),
      selectedColor: AppTheme.primaryLight,
      checkmarkColor: AppTheme.primaryBlue,
    );
  }
}
