import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';

class ConfigPanel extends ConsumerStatefulWidget {
  final String projectPath;
  final String? projectName;
  final String? version;
  final String? author;
  final String? iconPath;
  final List<String> platforms;

  const ConfigPanel({
    super.key,
    required this.projectPath,
    this.projectName,
    this.version,
    this.author,
    this.iconPath,
    required this.platforms,
  });

  @override
  ConsumerState<ConfigPanel> createState() => _ConfigPanelState();
}

class _ConfigPanelState extends ConsumerState<ConfigPanel> {
  String _selectedTab = 'general';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tabs
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              _buildTab('General', 'general', Icons.settings),
              _buildTab('Window', 'window', Icons.web_asset),
              _buildTab('Build', 'build', Icons.build),
            ],
          ),
        ),
        const Divider(height: 1),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildTabContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, String value, IconData icon) {
    final isSelected = _selectedTab == value;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedTab = value),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryLight.withOpacity(0.5) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.gray500,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? AppTheme.primaryBlue : AppTheme.gray700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 'general':
        return _buildGeneralSettings();
      case 'window':
        return _buildWindowSettings();
      case 'build':
        return _buildBuildSettings();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildGeneralSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('App Information'),
        _buildInfoRow('Name', widget.projectName ?? 'N/A'),
        _buildInfoRow('Version', widget.version ?? 'N/A'),
        _buildInfoRow('Author', widget.author ?? 'N/A'),
        const SizedBox(height: 24),
        _buildSectionTitle('Project'),
        _buildInfoRow('Path', widget.projectPath, isPath: true),
      ],
    );
  }

  Widget _buildWindowSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Window Size'),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Width',
            hintText: '1024',
            isDense: true,
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Height',
            hintText: '768',
            isDense: true,
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 24),
        _buildSectionTitle('Options'),
        CheckboxListTile(
          title: const Text('Resizable'),
          value: true,
          onChanged: (value) {},
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
        CheckboxListTile(
          title: const Text('Frameless'),
          value: false,
          onChanged: (value) {},
          contentPadding: EdgeInsets.zero,
          dense: true,
        ),
      ],
    );
  }

  Widget _buildBuildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Target Platforms'),
        ...widget.platforms.map((platform) => CheckboxListTile(
              title: Text(platform.toUpperCase()),
              value: true,
              onChanged: (value) {},
              contentPadding: EdgeInsets.zero,
              dense: true,
            )),
        const SizedBox(height: 24),
        _buildSectionTitle('Compression'),
        DropdownButtonFormField<String>(
          value: 'gzip',
          decoration: const InputDecoration(
            labelText: 'Compression Type',
            isDense: true,
          ),
          items: const [
            DropdownMenuItem(value: 'gzip', child: Text('Gzip')),
            DropdownMenuItem(value: 'brotli', child: Text('Brotli')),
            DropdownMenuItem(value: 'none', child: Text('None')),
          ],
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppTheme.gray900,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isPath = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            overflow: isPath ? TextOverflow.ellipsis : null,
            maxLines: isPath ? 2 : null,
          ),
        ],
      ),
    );
  }
}
