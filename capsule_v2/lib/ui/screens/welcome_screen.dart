import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/providers/project_provider.dart';
import '../../ui/theme/app_theme.dart';

/// Welcome Screen - Landing page for Capsule 2.0
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentProjects = ref.watch(recentProjectsProvider);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryBlue,
                      AppColors.primaryDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.box_container_outlined,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.x2l),
              
              // Title
              Text(
                'Capsule 2.0',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              
              // Subtitle
              Text(
                'Transform Web Apps into Desktop Apps',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.gray700,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.x2l),

              // Primary action
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/project-setup');
                },
                icon: const Icon(Icons.add, size: 24),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Create New Project',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  elevation: 4,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              
              // Secondary action
              TextButton.icon(
                onPressed: () {
                  // Open existing project
                },
                icon: const Icon(Icons.folder_open),
                label: const Text('Open Existing Project'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),

              // Recent projects section
              if (recentProjects.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.x3l),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recent Projects',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.gray700,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                
                // Recent projects list
                ...recentProjects.take(5).map((project) => _buildProjectCard(context, project)),
              ],

              // Quick start tips
              const SizedBox(height: AppSpacing.x3l),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: AppColors.primaryBlue),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Quick Start',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _buildTip('1. Build your web app with your favorite framework'),
                    _buildTip('2. Export the build/dist folder'),
                    _buildTip('3. Import it into Capsule'),
                    _buildTip('4. Configure and build desktop apps'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, dynamic project) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppRadius.small),
          ),
          child: const Icon(
            Icons.folder,
            color: AppColors.primaryBlue,
          ),
        ),
        title: Text(
          project.name ?? 'Untitled Project',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          'Built ${_timeAgo(project.updatedAt)} • ${project.targetPlatforms?.length ?? 0} platforms',
          style: TextStyle(color: AppColors.gray500, fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.pushNamed(context, '/workspace');
        },
      ),
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: AppColors.primaryBlue)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.primaryDark,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'just now';
    }
  }
}
