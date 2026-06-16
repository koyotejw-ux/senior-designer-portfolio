import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../home/data/models/atomic_design_model.dart';
import '../../../../home/data/repositories/atomic_design_repository.dart';

class AtomicComponentEditorDialog extends ConsumerStatefulWidget {
  final AtomicComponent? component;
  final AtomicLevel? initialLevel;

  const AtomicComponentEditorDialog({
    super.key,
    this.component,
    this.initialLevel,
  });

  @override
  ConsumerState<AtomicComponentEditorDialog> createState() =>
      _AtomicComponentEditorDialogState();
}

class _AtomicComponentEditorDialogState
    extends ConsumerState<AtomicComponentEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _codeController;
  late AtomicLevel _level;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.component?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.component?.description ?? '',
    );
    _codeController = TextEditingController(
      text: widget.component?.codeSnippet ?? '',
    );
    _level =
        widget.component?.level ??
        widget.initialLevel ??
        AtomicLevel.foundation;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final repository = ref.read(atomicDesignRepositoryProvider);
      final id = widget.component?.id ?? const Uuid().v4();

      final newComponent = AtomicComponent(
        id: id,
        name: _nameController.text,
        description: _descriptionController.text,
        level: _level,
        codeSnippet: _codeController.text,
        lastUpdated: DateTime.now(),
      );

      repository.saveComponent(newComponent).then((_) {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.deepSpace,
      title: Text(
        widget.component == null ? 'Add Component' : 'Edit Component',
        style: const TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        width: 600,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<AtomicLevel>(
                  value: _level,
                  dropdownColor: AppColors.charcoal,
                  decoration: const InputDecoration(
                    labelText: 'Level',
                    labelStyle: TextStyle(color: AppColors.primaryBlue),
                  ),
                  style: const TextStyle(color: Colors.white),
                  items: AtomicLevel.values.map((level) {
                    return DropdownMenuItem(
                      value: level,
                      child: Text(level.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _level = val);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: AppColors.primaryBlue),
                  ),
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: AppColors.primaryBlue),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _codeController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Code / Content',
                    labelStyle: TextStyle(color: AppColors.primaryBlue),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 10,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
