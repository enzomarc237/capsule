import 'package:flutter/material.dart';

/// Build Progress Screen - Shows build status and logs
class BuildProgressScreen extends StatefulWidget {
  const BuildProgressScreen({super.key});

  @override
  State<BuildProgressScreen> createState() => _BuildProgressScreenState();
}

class _BuildProgressScreenState extends State<BuildProgressScreen> {
  bool _showLogs = false;
  double _overallProgress = 0.0;
  String _currentStage = 'Initializing...';
  String _currentPlatform = 'Windows';
  
  final List<_BuildStage> _stages = [
    _BuildStage('Validation', true),
    _BuildStage('Preparation', true),
    _BuildStage('Compilation (Windows)', false, 0.45),
    _BuildStage('Compilation (macOS)', false, 0.70),
    _BuildStage('Compilation (Linux)', false, 0.85),
    _BuildStage('Packaging', false, 0.95),
  ];

  final List<String> _logs = [
    '[12:34:56] Starting Windows build...',
    '[12:34:57] Copying assets...',
    '[12:34:58] Optimizing images...',
    '[12:35:02] Compiling Dart code...',
    '[12:35:15] Linking native libraries...',
  ];

  @override
  void initState() {
    super.initState();
    _simulateBuild();
  }

  Future<void> _simulateBuild() async {
    // Simulate build progress
    for (int i = 0; i < _stages.length; i++) {
      setState(() {
        _stages[i].completed = false;
        _stages[i].inProgress = true;
        _currentStage = _stages[i].name;
      });

      // Simulate stage progress
      for (double j = 0; j <= 1.0; j += 0.1) {
        await Future.delayed(const Duration(milliseconds: 200));
        setState(() {
          _stages[i].progress = j;
          if (i < 3) {
            _overallProgress = (i + j) / _stages.length;
          }
        });
      }

      setState(() {
        _stages[i].completed = true;
        _stages[i].inProgress = false;
        _stages[i].progress = 1.0;
      });
    }

    // Complete build
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.pushReplacementNamed(context, '/success');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Building My Portfolio App'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Cancel Build?'),
                content: const Text('Are you sure you want to cancel the build in progress?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Continue'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel Build'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Building for 3 platforms...',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Overall progress
            LinearProgressIndicator(
              value: _overallProgress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Current: $_currentStage',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${(_overallProgress * 100).toInt()}%',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Stages
            Expanded(
              child: ListView.builder(
                itemCount: _stages.length,
                itemBuilder: (context, index) {
                  return _buildStageItem(_stages[index]);
                },
              ),
            ),

            const SizedBox(height: 16),

            // Build log toggle
            ExpansionTile(
              title: Text(
                'Build Log',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              initiallyExpanded: _showLogs,
              onExpansionChanged: (expanded) {
                setState(() => _showLogs = expanded);
              },
              children: [
                Container(
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _logs.length,
                    itemBuilder: (context, index) {
                      return Text(
                        _logs[index],
                        style: const TextStyle(
                          color: Colors.green,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStageItem(_BuildStage stage) {
    IconData icon;
    Color iconColor;

    if (stage.completed) {
      icon = Icons.check_circle;
      iconColor = Colors.green;
    } else if (stage.inProgress) {
      icon = Icons.hourglass_empty;
      iconColor = Colors.blue;
    } else {
      icon = Icons.circle_outlined;
      iconColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stage.name,
                  style: TextStyle(
                    fontWeight: stage.inProgress ? FontWeight.w600 : FontWeight.normal,
                    color: stage.inProgress ? Colors.blue : Colors.grey.shade800,
                  ),
                ),
                if (stage.inProgress && stage.progress < 1.0)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: LinearProgressIndicator(
                      value: stage.progress,
                      minHeight: 4,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
              ],
            ),
          ),
          if (stage.completed)
            const Icon(Icons.done, color: Colors.green, size: 20),
        ],
      ),
    );
  }
}

class _BuildStage {
  final String name;
  bool completed;
  bool inProgress;
  double progress;

  _BuildStage(this.name, this.completed, [this.progress = 0.0])
      : inProgress = !completed && progress > 0 && progress < 1.0;
}
