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
import '../widgets/resume_editor.dart';
import '../widgets/project_print_dialog.dart';
import 'project_structure_page.dart';
import 'design_system_page.dart';
import 'ui_preview_page.dart';
import 'project_guide_page.dart';
import 'project_templates_page.dart';
import 'project_documents_page.dart';
import '../widgets/atomic_design/atomic_design_editor.dart';

class AdminPage extends ConsumerStatefulWidget {
  const AdminPage({super.key});

  @override
  ConsumerState<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 14,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Admin Dashboard'),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.swipe,
                      size: 14,
                      color: AppColors.accentCyan,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '좌우로 스크롤',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.accentCyan,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.deepSpace,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.go('/'),
              tooltip: '로그아웃',
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.primaryBlue,
            indicatorWeight: 3,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: Colors.grey,
            labelPadding: const EdgeInsets.symmetric(horizontal: 12),
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            tabs: const [
              Tab(icon: Icon(Icons.grid_view, size: 20), text: 'Projects'),
              Tab(
                icon: Icon(Icons.business_center, size: 20),
                text: 'Corp Projects',
              ),
              Tab(icon: Icon(Icons.person, size: 20), text: 'Profile'),
              Tab(icon: Icon(Icons.work, size: 20), text: 'Experience'),
              Tab(icon: Icon(Icons.school, size: 20), text: 'Education'),
              Tab(icon: Icon(Icons.stars, size: 20), text: 'Skills'),
              Tab(icon: Icon(Icons.description, size: 20), text: 'Resume'),
              Tab(
                icon: Icon(Icons.picture_as_pdf, size: 20),
                text: 'Documents',
              ),
              Tab(icon: Icon(Icons.account_tree, size: 20), text: 'Structure'),
              Tab(icon: Icon(Icons.palette, size: 20), text: 'Design'),
              Tab(icon: Icon(Icons.visibility, size: 20), text: 'Preview'),
              Tab(icon: Icon(Icons.rocket_launch, size: 20), text: 'Guide'),
              Tab(icon: Icon(Icons.article, size: 20), text: 'Templates'),
              Tab(
                icon: Icon(Icons.auto_awesome_mosaic, size: 20),
                text: 'Atomic',
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.deepSpace,
        body: TabBarView(
          children: [
            const _ProjectsTab(isCorporate: false),
            const _ProjectsTab(isCorporate: true),
            const ProfileEditor(),
            const ExperienceEditor(),
            const EducationEditor(),
            const SkillEditor(),
            const ResumeEditor(),
            const ProjectDocumentsPage(),
            const ProjectStructurePage(),
            const DesignSystemPage(),
            const UIPreviewPage(),
            const ProjectGuidePage(),
            const ProjectTemplatesPage(),
            const AtomicDesignEditor(),
          ],
        ),
      ),
    );
  }
}

class _ProjectsTab extends ConsumerStatefulWidget {
  final bool isCorporate;
  const _ProjectsTab({required this.isCorporate});

  @override
  ConsumerState<_ProjectsTab> createState() => _ProjectsTabState();
}

class _ProjectsTabState extends ConsumerState<_ProjectsTab> {
  final Set<String> _selectedProjectIds = {};

  void _toggleSelection(String projectId) {
    setState(() {
      if (_selectedProjectIds.contains(projectId)) {
        _selectedProjectIds.remove(projectId);
      } else {
        _selectedProjectIds.add(projectId);
      }
    });
  }

  void _showPrintDialog(BuildContext context, List<ProjectModel> allProjects) {
    final selectedProjects = allProjects
        .where((p) => _selectedProjectIds.contains(p.id))
        .toList();

    selectedProjects.sort((a, b) => a.order.compareTo(b.order));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProjectPrintDialog(projects: selectedProjects),
    );
  }

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

  void _reorderProjects(
    BuildContext context,
    WidgetRef ref,
    List<ProjectModel> projects,
    List<ProjectModel> filteredProjects,
    int oldIndex,
    int newIndex,
  ) {
    // Convert filtered indices to original indices
    final originalOldIndex = projects.indexOf(filteredProjects[oldIndex]);
    final originalNewIndex = oldIndex < newIndex
        ? projects.indexOf(filteredProjects[newIndex - 1]) + 1
        : projects.indexOf(filteredProjects[newIndex]);

    final updatedProjects = List<ProjectModel>.from(projects);
    final item = updatedProjects.removeAt(originalOldIndex);

    // Adjust new index if it was affected by removal
    int adjustedNewIndex = originalNewIndex;
    if (originalOldIndex < originalNewIndex) adjustedNewIndex--;

    updatedProjects.insert(adjustedNewIndex, item);

    // Update order values for all projects to maintain global consistency
    final reorderedProjects = updatedProjects.asMap().entries.map((entry) {
      final p = entry.value;
      return ProjectModel(
        id: p.id,
        title: p.title,
        subtitle: p.subtitle,
        company: p.company,
        year: p.year,
        category: p.category,
        description: p.description,
        tags: p.tags,
        imageUrl: p.imageUrl,
        gradientColors: p.gradientColors,
        order: entry.key,
        role: p.role,
        duration: p.duration,
        teamSize: p.teamSize,
        mainScreenImages: p.mainScreenImages,
        designSystem: p.designSystem,
        isCorporate: p.isCorporate,
      );
    }).toList();

    ref.read(contentRepositoryProvider).reorderProjects(reorderedProjects);
    ref.invalidate(projectsProvider);
  }

  @override
  Widget build(BuildContext context) {
    final projectsAsync = ref.watch(projectsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: projectsAsync.when(
        data: (projects) {
          final filteredProjects = projects
              .where((p) => p.isCorporate == widget.isCorporate)
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          for (final p in filteredProjects) {
                            _selectedProjectIds.add(p.id);
                          }
                        });
                      },
                      icon: const Icon(Icons.select_all, size: 18),
                      label: const Text('Select All'),
                      style: TextButton.styleFrom(foregroundColor: Colors.white70),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectedProjectIds.clear();
                        });
                      },
                      icon: const Icon(Icons.deselect, size: 18),
                      label: const Text('Select None'),
                      style: TextButton.styleFrom(foregroundColor: Colors.white70),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 100, // Space for FABs
                  ),
            itemCount: filteredProjects.length,
            onReorder: (oldIndex, newIndex) => _reorderProjects(
              context,
              ref,
              projects,
              filteredProjects,
              oldIndex,
              newIndex,
            ),
            itemBuilder: (context, index) {
              final project = filteredProjects[index];
              final isSelected = _selectedProjectIds.contains(project.id);

              return Card(
                key: ValueKey(project.id),
                color: isSelected
                    ? AppColors.primaryBlue.withOpacity(0.2)
                    : AppColors.charcoal,
                margin: const EdgeInsets.only(bottom: 16),
                shape: isSelected
                    ? RoundedRectangleBorder(
                        side: const BorderSide(
                          color: AppColors.primaryBlue,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      )
                    : null,
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => _toggleSelection(project.id),
                        activeColor: AppColors.primaryBlue,
                        side: const BorderSide(color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      // Drag handle only works if we wrap it specifically or use the default one via ReorderableListView
                      // But since we are inside ReorderableListView, we can just put an icon that hints dragging
                      const Icon(Icons.drag_handle, color: Colors.grey),
                      const SizedBox(width: 8),
                      project.imageUrl != null
                          ? Image.network(
                              project.imageUrl!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.white54,
                                    ),
                                  ),
                            )
                          : Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey,
                            ),
                    ],
                  ),
                  title: Text(
                    project.title,
                    style: AppTypography.h6.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${project.category} • Order: ${project.order}',
                    style: AppTypography.bodySmall.copyWith(color: Colors.grey),
                  ),
                  onTap: () => _toggleSelection(project.id),
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
          )
              )
            ],
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedProjectIds.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: FloatingActionButton.extended(
                heroTag: 'print_fab',
                onPressed: () => projectsAsync.whenData(
                  (projects) => _showPrintDialog(context, projects),
                ),
                backgroundColor: AppColors.highlightGreen,
                icon: const Icon(Icons.print, color: Colors.black),
                label: Text(
                  'Print Selected (${_selectedProjectIds.length})',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          FloatingActionButton(
            heroTag: widget.isCorporate ? 'add_corp_fab' : 'add_fab',
            onPressed: () => _showProjectEditor(context),
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
