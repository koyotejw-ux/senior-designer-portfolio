import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../home/data/models/atomic_design_model.dart';
import '../../../../home/data/repositories/atomic_design_repository.dart';
import 'atomic_component_editor_dialog.dart';

class AtomicDesignEditor extends ConsumerStatefulWidget {
  const AtomicDesignEditor({super.key});

  @override
  ConsumerState<AtomicDesignEditor> createState() => _AtomicDesignEditorState();
}

class _AtomicDesignEditorState extends ConsumerState<AtomicDesignEditor> {
  AtomicLevel _selectedLevel = AtomicLevel.foundation;

  @override
  Widget build(BuildContext context) {
    final atomicDesignAsync = ref.watch(atomicDesignProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // Level Selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: AtomicLevel.values.map((level) {
                  final isSelected = _selectedLevel == level;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(level.name.toUpperCase()),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedLevel = level);
                      },
                      backgroundColor: AppColors.charcoal,
                      selectedColor: AppColors.primaryBlue,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Content
          Expanded(
            child: atomicDesignAsync.when(
              data: (model) {
                final components = _getComponentsByLevel(model, _selectedLevel);
                if (components.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 48,
                          color: Colors.white24,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No components found in ${_selectedLevel.name}',
                          style: TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: components.length,
                  itemBuilder: (context, index) {
                    final component = components[index];
                    return _ComponentCard(
                      component: component,
                      onEdit: () => _showComponentEditor(component),
                      onDelete: () => _deleteComponent(component),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error: $err',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showComponentEditor(),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }

  List<AtomicComponent> _getComponentsByLevel(
    AtomicDesignModel model,
    AtomicLevel level,
  ) {
    switch (level) {
      case AtomicLevel.foundation:
        return model.foundations;
      case AtomicLevel.atom:
        return model.atoms;
      case AtomicLevel.molecule:
        return model.molecules;
      case AtomicLevel.organism:
        return model.organisms;
      case AtomicLevel.template:
        return model.templates;
      case AtomicLevel.page:
        return model.pages;
    }
  }

  void _showComponentEditor([AtomicComponent? component]) {
    showDialog(
      context: context,
      builder: (context) => AtomicComponentEditorDialog(
        component: component,
        initialLevel: _selectedLevel,
      ),
    ).then((_) => ref.invalidate(atomicDesignProvider));
  }

  void _deleteComponent(AtomicComponent component) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.charcoal,
        title: const Text(
          'Delete Component',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete "${component.name}"?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref
                  .read(atomicDesignRepositoryProvider)
                  .deleteComponent(component.id, component.level)
                  .then((_) {
                    Navigator.pop(context);
                    ref.invalidate(atomicDesignProvider);
                  });
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _ComponentCard extends StatelessWidget {
  final AtomicComponent component;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ComponentCard({
    required this.component,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.charcoal,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          component.name,
          style: AppTypography.h6.copyWith(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              component.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(color: Colors.white60),
            ),
            const SizedBox(height: 4),
            Text(
              'Updated: ${component.lastUpdated.toString().split(' ')[0]}',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primaryBlue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
