import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/education_model.dart';
import '../../../home/data/providers/content_provider.dart';

class EducationEditor extends ConsumerWidget {
  const EducationEditor({super.key});

  void _reorderEducations(WidgetRef ref, List<EducationModel> educations,
      int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final updatedList = List<EducationModel>.from(educations);
    final item = updatedList.removeAt(oldIndex);
    updatedList.insert(newIndex, item);

    final reorderedList = updatedList
        .asMap()
        .entries
        .map((entry) => EducationModel(
              id: entry.value.id,
              period: entry.value.period,
              school: entry.value.school,
              major: entry.value.major,
              gpa: entry.value.gpa,
              order: entry.key,
            ))
        .toList();

    ref.read(contentRepositoryProvider).reorderEducations(reorderedList);
    ref.invalidate(educationProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final educationAsync = ref.watch(educationProvider);

    return educationAsync.when(
      data: (educations) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Education',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showEditDialog(context, null, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Education'),
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
                itemCount: educations.length,
                onReorder: (oldIndex, newIndex) =>
                    _reorderEducations(ref, educations, oldIndex, newIndex),
                itemBuilder: (context, index) {
                  final edu = educations[index];
                  return Card(
                    key: ValueKey(edu.id),
                    color: AppColors.charcoal,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading: const Icon(Icons.drag_handle, color: Colors.grey),
                      title: Text(
                        edu.school,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${edu.major} | ${edu.period} • Order: ${edu.order}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                              color: AppColors.primaryBlue,
                            ),
                            onPressed: () => _showEditDialog(context, edu, ref),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.error,
                            ),
                            onPressed: () =>
                                _deleteEducation(context, ref, edu.id),
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

  void _showEditDialog(
    BuildContext context,
    EducationModel? education,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => _EducationDialog(education: education),
    );
  }

  void _deleteEducation(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Education'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(contentRepositoryProvider).deleteEducation(id);
              ref.invalidate(educationProvider);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _EducationDialog extends ConsumerStatefulWidget {
  final EducationModel? education;

  const _EducationDialog({this.education});

  @override
  ConsumerState<_EducationDialog> createState() => _EducationDialogState();
}

class _EducationDialogState extends ConsumerState<_EducationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schoolController;
  late TextEditingController _majorController;
  late TextEditingController _periodController;
  late TextEditingController _gpaController;
  late TextEditingController _orderController;

  @override
  void initState() {
    super.initState();
    final e = widget.education;
    _schoolController = TextEditingController(text: e?.school ?? '');
    _majorController = TextEditingController(text: e?.major ?? '');
    _periodController = TextEditingController(text: e?.period ?? '');
    _gpaController = TextEditingController(text: e?.gpa ?? '');
    _orderController = TextEditingController(text: e?.order.toString() ?? '0');
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _majorController.dispose();
    _periodController.dispose();
    _gpaController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final education = EducationModel(
      id: widget.education?.id ?? const Uuid().v4(),
      school: _schoolController.text,
      major: _majorController.text,
      period: _periodController.text,
      gpa: _gpaController.text,
      order: int.tryParse(_orderController.text) ?? 0,
    );

    final repo = ref.read(contentRepositoryProvider);
    if (widget.education == null) {
      await repo.addEducation(education);
    } else {
      await repo.updateEducation(education);
    }

    ref.invalidate(educationProvider);

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
                  widget.education == null ? 'Add Education' : 'Edit Education',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                _buildTextField(_schoolController, 'School'),
                const SizedBox(height: 16),
                _buildTextField(_majorController, 'Major'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(_periodController, 'Period'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(_gpaController, 'GPA')),
                  ],
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
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
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
