import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/skill_model.dart';
import '../../../home/data/providers/content_provider.dart';

class SkillEditor extends ConsumerWidget {
  const SkillEditor({super.key});

  void _reorderSkills(WidgetRef ref, List<SkillModel> skills, int oldIndex,
      int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final updatedList = List<SkillModel>.from(skills);
    final item = updatedList.removeAt(oldIndex);
    updatedList.insert(newIndex, item);

    final reorderedList = updatedList
        .asMap()
        .entries
        .map((entry) => SkillModel(
              id: entry.value.id,
              title: entry.value.title,
              skills: entry.value.skills,
              order: entry.key,
              iconName: entry.value.iconName,
            ))
        .toList();

    ref.read(contentRepositoryProvider).reorderSkills(reorderedList);
    ref.invalidate(skillsProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skillsAsync = ref.watch(skillsProvider);

    return skillsAsync.when(
      data: (skills) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Expertise Areas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showEditDialog(context, null, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Area'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: skills.length,
                onReorder: (oldIndex, newIndex) =>
                    _reorderSkills(ref, skills, oldIndex, newIndex),
                itemBuilder: (context, index) {
                  final skill = skills[index];
                  return Card(
                    key: ValueKey(skill.id),
                    color: AppColors.charcoal,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: const Icon(Icons.drag_handle, color: Colors.grey),
                      title: Text(
                        skill.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${skill.skills.join(', ')} • Order: ${skill.order}',
                        style: TextStyle(color: AppColors.gray100),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.primaryBlue,
                            ),
                            onPressed: () =>
                                _showEditDialog(context, skill, ref),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.error,
                            ),
                            onPressed: () =>
                                _deleteSkill(context, ref, skill.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Error: $err', style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _showEditDialog(BuildContext context, SkillModel? skill, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _SkillDialog(skill: skill),
    );
  }

  void _deleteSkill(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Area'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(contentRepositoryProvider).deleteSkill(id);
              ref.invalidate(skillsProvider); // Invalidate provider
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SkillDialog extends ConsumerStatefulWidget {
  final SkillModel? skill;

  const _SkillDialog({this.skill});

  @override
  ConsumerState<_SkillDialog> createState() => _SkillDialogState();
}

class _SkillDialogState extends ConsumerState<_SkillDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _skillsController;
  late TextEditingController _orderController;

  @override
  void initState() {
    super.initState();
    final s = widget.skill;
    _titleController = TextEditingController(text: s?.title ?? '');
    _skillsController = TextEditingController(text: s?.skills.join(', ') ?? '');
    _orderController = TextEditingController(text: s?.order.toString() ?? '0');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _skillsController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final skillsList = _skillsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final skill = SkillModel(
      id: widget.skill?.id ?? const Uuid().v4(),
      title: _titleController.text,
      skills: skillsList,
      order: int.tryParse(_orderController.text) ?? 0,
    );

    final repo = ref.read(contentRepositoryProvider);
    if (widget.skill == null) {
      await repo.addSkill(skill);
    } else {
      await repo.updateSkill(skill);
    }

    ref.invalidate(skillsProvider); // Invalidate provider

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.deepSpace,
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.skill == null ? 'Add Area' : 'Edit Area',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  _titleController,
                  'Title (e.g. Design Systems)',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  _skillsController,
                  'Skills (comma separated)',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                _buildTextField(_orderController, 'Order', isNumber: true),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.charcoal,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }
}
