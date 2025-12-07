import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/experience_model.dart';
import '../../../home/data/providers/content_provider.dart';

class ExperienceEditor extends ConsumerWidget {
  const ExperienceEditor({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final experienceAsync = ref.watch(experienceProvider);

    return experienceAsync.when(
      data: (experiences) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Experience',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _showEditDialog(context, null, ref),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Experience'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: experiences.length,
                itemBuilder: (context, index) {
                  final exp = experiences[index];
                  return Card(
                    color: AppColors.charcoal,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        exp.company,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${exp.role} | ${exp.period}',
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
                            onPressed: () => _showEditDialog(context, exp, ref),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: AppColors.error,
                            ),
                            onPressed: () =>
                                _deleteExperience(context, ref, exp.id),
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
    ExperienceModel? experience,
    WidgetRef ref,
  ) {
    showDialog(
      context: context,
      builder: (context) => _ExperienceDialog(experience: experience),
    );
  }

  void _deleteExperience(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Experience'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(contentRepositoryProvider).deleteExperience(id);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ExperienceDialog extends ConsumerStatefulWidget {
  final ExperienceModel? experience;

  const _ExperienceDialog({this.experience});

  @override
  ConsumerState<_ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends ConsumerState<_ExperienceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyController;
  late TextEditingController _roleController;
  late TextEditingController _periodController;
  late TextEditingController _responsibilitiesController;
  late TextEditingController _achievementsController;
  late TextEditingController _toolsController;
  late TextEditingController _environmentController;
  late TextEditingController _reasonController;
  late TextEditingController _orderController;

  @override
  void initState() {
    super.initState();
    final e = widget.experience;
    _companyController = TextEditingController(text: e?.company ?? '');
    _roleController = TextEditingController(text: e?.role ?? '');
    _periodController = TextEditingController(text: e?.period ?? '');
    _responsibilitiesController = TextEditingController(
      text: e?.responsibilities.join('\n') ?? '',
    );
    _achievementsController = TextEditingController(
      text: e?.achievements.join('\n') ?? '',
    );
    _toolsController = TextEditingController(text: e?.tools.join(', ') ?? '');
    _environmentController = TextEditingController(
      text: e?.environment.join(', ') ?? '',
    );
    _reasonController = TextEditingController(text: e?.reasonForLeaving ?? '');
    _orderController = TextEditingController(text: e?.order.toString() ?? '0');
  }

  @override
  void dispose() {
    _companyController.dispose();
    _roleController.dispose();
    _periodController.dispose();
    _responsibilitiesController.dispose();
    _achievementsController.dispose();
    _toolsController.dispose();
    _environmentController.dispose();
    _reasonController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final experience = ExperienceModel(
      id: widget.experience?.id ?? const Uuid().v4(),
      company: _companyController.text,
      role: _roleController.text,
      period: _periodController.text,
      responsibilities: _responsibilitiesController.text
          .split('\n')
          .where((e) => e.isNotEmpty)
          .toList(),
      achievements: _achievementsController.text
          .split('\n')
          .where((e) => e.isNotEmpty)
          .toList(),
      tools: _toolsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      environment: _environmentController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      reasonForLeaving: _reasonController.text,
      order: int.tryParse(_orderController.text) ?? 0,
    );

    final repo = ref.read(contentRepositoryProvider);
    if (widget.experience == null) {
      await repo.addExperience(experience);
    } else {
      await repo.updateExperience(experience);
    }

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
                  widget.experience == null
                      ? 'Add Experience'
                      : 'Edit Experience',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(_companyController, 'Company'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(_roleController, 'Role')),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(_periodController, 'Period'),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 100,
                      child: _buildTextField(
                        _orderController,
                        'Order',
                        isNumber: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  _responsibilitiesController,
                  'Responsibilities (One per line)',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  _achievementsController,
                  'Achievements (One per line)',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildTextField(_toolsController, 'Tools (comma separated)'),
                const SizedBox(height: 16),
                _buildTextField(
                  _environmentController,
                  'Environment (comma separated)',
                ),
                const SizedBox(height: 16),
                _buildTextField(_reasonController, 'Reason for Leaving'),
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
