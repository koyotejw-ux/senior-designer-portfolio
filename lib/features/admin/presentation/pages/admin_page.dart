import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../home/data/models/project_model.dart';
import '../../../home/data/providers/content_provider.dart';
import '../widgets/project_editor.dart';
import '../widgets/profile_editor.dart';
import '../widgets/experience_editor.dart';
import '../widgets/education_editor.dart';
import '../widgets/skill_editor.dart';

class AdminPage extends ConsumerWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
          backgroundColor: AppColors.deepSpace,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.go('/'),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: AppColors.primaryBlue,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Projects'),
              Tab(text: 'Profile'),
              Tab(text: 'Experience'),
              Tab(text: 'Education'),
              Tab(text: 'Skills'),
            ],
          ),
        ),
        backgroundColor: AppColors.deepSpace,
        body: const TabBarView(
          children: [
            _ProjectsTab(),
            ProfileEditor(),
            ExperienceEditor(),
            EducationEditor(),
            SkillEditor(),
          ],
        ),
      ),
    );
  }
}

class _ProjectsTab extends ConsumerWidget {
  const _ProjectsTab();

  void _showProjectEditor(BuildContext context, [ProjectModel? project]) {
    showDialog(
      context: context,
      builder: (context) => ProjectEditor(project: project),
    );
  }

  void _deleteProject(BuildContext context, WidgetRef ref, String projectId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Project'),
        content: const Text('Are you sure you want to delete this project?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(contentRepositoryProvider).deleteProject(projectId);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: projectsAsync.when(
        data: (projects) {
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              final project = projects[index];
              return Card(
                color: AppColors.charcoal,
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: project.imageUrl != null
                      ? Image.network(
                          project.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Container(width: 50, height: 50, color: Colors.grey),
                  title: Text(
                    project.title,
                    style: AppTypography.h6.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    project.category,
                    style: AppTypography.bodySmall.copyWith(color: Colors.grey),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: AppColors.primaryBlue,
                        ),
                        onPressed: () => _showProjectEditor(context, project),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: AppColors.error),
                        onPressed: () =>
                            _deleteProject(context, ref, project.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProjectEditor(context),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }
}
