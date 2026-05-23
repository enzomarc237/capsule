import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/providers/project_provider.dart';
import '../../widgets/live_preview.dart';
import '../../ui/theme/app_theme.dart';

/// Main Workspace Screen - Configure and build desktop app
class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen> {
  int _selectedPlatform = 0; // 0: Windows, 1: macOS, 2: Linux
  bool _compressAssets = true;
  bool _optimizeImages = true;
  
  // Window settings
  final _windowWidthController = TextEditingController(text: '1024');
  final _windowHeightController = TextEditingController(text: '768');
  bool _resizable = true;
  bool _frameless = false;

  @override
  void dispose() {
    _windowWidthController.dispose();
    _windowHeightController.dispose();
    super.dispose();
  }

  void _startBuild() {
    // Navigate to build progress screen
    Navigator.pushNamed(context, '/build-progress');
  }

  @override
  Widget build(BuildContext context) {
    final project = ref.watch(currentProjectProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(project?.name ?? 'My Desktop App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Project saved')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Left sidebar - Settings panel
          SizedBox(
            width: 300,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Platforms'),
                    _buildPlatformSelector(),
                    const Divider(),
                    
                    _buildSectionTitle('Window Settings'),
                    _buildWindowSizeInputs(),
                    const SizedBox(height: 16),
                    _buildToggle('Resizable', _resizable, (v) => setState(() => _resizable = v)),
                    _buildToggle('Frameless', _frameless, (v) => setState(() => _frameless = v)),
                    const Divider(),
                    
                    _buildSectionTitle('Optimization'),
                    _buildToggle('Compress Assets', _compressAssets, (v) => setState(() => _compressAssets = v)),
                    _buildToggle('Optimize Images', _optimizeImages, (v) => setState(() => _optimizeImages = v)),
                  ],
                ),
              ),
            ),
          ),
          
          // Center - Live Preview
          Expanded(
            child: Column(
              children: [
                // Preview toolbar
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Text('Platform Preview:'),
                      const SizedBox(width: 12),
                      _buildPlatformChip('Windows', 0),
                      const SizedBox(width: 8),
                      _buildPlatformChip('macOS', 1),
                      const SizedBox(width: 8),
                      _buildPlatformChip('Linux', 2),
                      const Spacer(),
                      TextButton.icon(
                        icon: const Icon(Icons.zoom_in, size: 18),
                        label: const Text('100%'),
                        onPressed: () {},
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.code, size: 18),
                        label: const Text('DevTools'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                
                // Preview window with LivePreviewWidget
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        children: [
                          // Fake window title bar
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            color: _selectedPlatform == 1 ? Colors.grey.shade300 : Colors.grey.shade200,
                            child: Row(
                              children: [
                                if (_selectedPlatform == 0) ...[
                                  _buildWindowsControl(Icons.close, Colors.red),
                                  const SizedBox(width: 8),
                                  _buildWindowsControl(Icons.crop_square, Colors.green),
                                  const SizedBox(width: 8),
                                  _buildWindowsControl(Icons.remove, Colors.blue),
                                ] else if (_selectedPlatform == 1) ...[
                                  _buildMacOSControl(),
                                  const SizedBox(width: 8),
                                  _buildMacOSControl(),
                                  const SizedBox(width: 8),
                                  _buildMacOSControl(),
                                ] else ...[
                                  const Icon(Icons.menu, size: 16),
                                  const SizedBox(width: 12),
                                  const Text('My Desktop App', style: TextStyle(fontSize: 12)),
                                ],
                                const Spacer(),
                                Text(
                                  project?.name ?? 'My Desktop App',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Live Preview Widget
                          Expanded(
                            child: project != null && project.webAppPath.isNotEmpty
                                ? LivePreviewWidget(
                                    sourcePath: project.webAppPath,
                                    buildDirectory: project.buildOutputPath,
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.language,
                                          size: 64,
                                          color: Colors.grey.shade300,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Live Preview',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Your web app will render here',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            ElevatedButton.icon(
              onPressed: _startBuild,
              icon: const Icon(Icons.build),
              label: const Text('Build for Windows'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(width: 12),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'all') {
                  _startBuild();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'windows', child: Text('Windows')),
                const PopupMenuItem(value: 'macos', child: Text('macOS')),
                const PopupMenuItem(value: 'linux', child: Text('Linux')),
                const PopupMenuDivider(),
                const PopupMenuItem(value: 'all', child: Text('Build All Platforms')),
              ],
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_drop_down),
                label: const Text('More Options'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildPlatformSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildPlatformOption(0, Icons.window, 'Windows', 'x64, ARM64'),
          const SizedBox(height: 8),
          _buildPlatformOption(1, Icons.apple, 'macOS', 'Intel, Apple Silicon'),
          const SizedBox(height: 8),
          _buildPlatformOption(2, Icons.terminal, 'Linux', 'x64, ARM64'),
        ],
      ),
    );
  }

  Widget _buildPlatformOption(int index, IconData icon, String name, String arch) {
    final isSelected = _selectedPlatform == index;
    return InkWell(
      onTap: () => setState(() => _selectedPlatform = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Colors.blue : Colors.black87,
                    ),
                  ),
                  Text(
                    arch,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: Colors.blue, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWindowSizeInputs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _windowWidthController,
              decoration: const InputDecoration(
                labelText: 'Width',
                suffixText: 'px',
                isDense: true,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _windowHeightController,
              decoration: const InputDecoration(
                labelText: 'Height',
                suffixText: 'px',
                isDense: true,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged) {
    return ListTile(
      title: Text(label),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildPlatformChip(String label, int index) {
    final isSelected = _selectedPlatform == index;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => setState(() => _selectedPlatform = index),
      selectedColor: Colors.blue.shade100,
      checkmarkColor: Colors.blue,
    );
  }

  Widget _buildWindowsControl(IconData icon, Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMacOSControl() {
    return Container(
      width: 12,
      height: 12,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}
