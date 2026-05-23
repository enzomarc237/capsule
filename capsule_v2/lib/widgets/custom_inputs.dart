import 'package:flutter/material.dart';

/// Custom file picker widget for selecting project directories
class DirectoryPicker extends StatefulWidget {
  final String? initialDirectory;
  final ValueChanged<String> onDirectorySelected;
  final String label;
  final String hint;

  const DirectoryPicker({
    super.key,
    this.initialDirectory,
    required this.onDirectorySelected,
    this.label = 'Project Directory',
    this.hint = 'Select a directory...',
  });

  @override
  State<DirectoryPicker> createState() => _DirectoryPickerState();
}

class _DirectoryPickerState extends State<DirectoryPicker> {
  String? selectedPath;

  @override
  void initState() {
    super.initState();
    selectedPath = widget.initialDirectory;
  }

  Future<void> _pickDirectory() async {
    // In a real implementation, you would use file_picker or similar
    // For now, we'll simulate with a text dialog
    final controller = TextEditingController(text: selectedPath ?? '');
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select ${widget.label}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Enter the path to your web project directory:'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: widget.hint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.folder),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 8),
            Text(
              'Tip: This should contain your built web files (index.html, JS, CSS, etc.)',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Select'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        selectedPath = result;
      });
      widget.onDirectorySelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _pickDirectory,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Icon(
                  selectedPath != null ? Icons.folder_open : Icons.folder_outlined,
                  color: selectedPath != null ? Colors.blue : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedPath ?? widget.hint,
                    style: TextStyle(
                      color: selectedPath != null ? Colors.black87 : Colors.grey,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom text field with validation
class ValidatedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool required;
  final String? Function(String?)? validator;
  final int maxLines;

  const ValidatedTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.required = false,
    this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: icon != null ? Icon(icon) : null,
            border: const OutlineInputBorder(),
            suffixIcon: required
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '*',
                      style: TextStyle(color: Colors.red[400], fontSize: 16),
                    ),
                  )
                : null,
          ),
          maxLines: maxLines,
          validator: validator ?? (value) {
            if (required && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}

/// Platform selection chip group
class PlatformSelector extends StatelessWidget {
  final TargetPlatform selectedPlatform;
  final ValueChanged<TargetPlatform> onPlatformSelected;

  const PlatformSelector({
    super.key,
    required this.selectedPlatform,
    required this.onPlatformSelected,
  });

  @override
  Widget build(BuildContext context) {
    final platforms = [
      {'platform': TargetPlatform.windows, 'label': 'Windows', 'icon': Icons.window},
      {'platform': TargetPlatform.macos, 'label': 'macOS', 'icon': Icons.laptop_mac},
      {'platform': TargetPlatform.linux, 'label': 'Linux', 'icon': Icons.terminal},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Target Platform',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: platforms.map((item) {
            final platform = item['platform'] as TargetPlatform;
            final label = item['label'] as String;
            final icon = item['icon'] as IconData;
            final isSelected = selectedPlatform == platform;

            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16),
                  const SizedBox(width: 4),
                  Text(label),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onPlatformSelected(platform);
                }
              },
              selectedColor: Colors.blue[100],
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue[900] : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
