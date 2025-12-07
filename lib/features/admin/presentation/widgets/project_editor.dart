import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/project_model.dart';
import '../../../home/data/providers/content_provider.dart';

class ProjectEditor extends ConsumerStatefulWidget {
  final ProjectModel? project;

  const ProjectEditor({super.key, this.project});

  @override
  ConsumerState<ProjectEditor> createState() => _ProjectEditorState();
}

class _ProjectEditorState extends ConsumerState<ProjectEditor> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _companyController;
  late TextEditingController _yearController;
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _tagsController;

  Uint8List? _imageBytes;
  XFile? _pickedFile;
  String? _imageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final p = widget.project;
    _titleController = TextEditingController(text: p?.title ?? '');
    _subtitleController = TextEditingController(text: p?.subtitle ?? '');
    _companyController = TextEditingController(text: p?.company ?? '');
    _yearController = TextEditingController(text: p?.year ?? '');
    _categoryController = TextEditingController(text: p?.category ?? '');
    _descriptionController = TextEditingController(text: p?.description ?? '');
    _tagsController = TextEditingController(text: p?.tags.join(', ') ?? '');
    _imageUrl = p?.imageUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _companyController.dispose();
    _yearController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: null,
      maxHeight: null,
      imageQuality: null,
      requestFullMetadata: true,
    );

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _pickedFile = pickedFile;
        _imageBytes = bytes;
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageBytes == null) return _imageUrl;

    setState(() => _isUploading = true);
    try {
      String filename = 'image.jpg';
      if (_pickedFile != null) {
        filename = _pickedFile!.name;
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:8080/upload'),
      );

      request.files.add(
        http.MultipartFile.fromBytes('file', _imageBytes!, filename: filename),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final imageUrl = await response.stream.bytesToString();
        return imageUrl;
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error uploading image: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Upload Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return null;
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      final imageUrl = await _uploadImage();

      final tags = _tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      final project = ProjectModel(
        id: widget.project?.id ?? const Uuid().v4(),
        title: _titleController.text,
        subtitle: _subtitleController.text,
        company: _companyController.text,
        year: _yearController.text,
        category: _categoryController.text,
        description: _descriptionController.text,
        tags: tags,
        imageUrl: imageUrl,
        gradientColors:
            widget.project?.gradientColors ??
            [AppColors.primaryBlue, AppColors.accentCyan],
      );

      final repo = ref.read(contentRepositoryProvider);
      if (widget.project == null) {
        await repo.addProject(project);
      } else {
        await repo.updateProject(project);
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to save project: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
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
                  widget.project == null ? 'Add Project' : 'Edit Project',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Image Picker
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 200,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.charcoal,
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _imageBytes != null
                          ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                          : _imageUrl != null
                          ? Image.network(_imageUrl!, fit: BoxFit.cover)
                          : const Icon(
                              Icons.add_photo_alternate,
                              size: 40,
                              color: Colors.grey,
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(child: _buildTextField(_titleController, 'Title')),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(_companyController, 'Company'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(_subtitleController, 'Subtitle'),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(_yearController, 'Year')),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(_categoryController, 'Category'),
                const SizedBox(height: 16),
                _buildTextField(
                  _descriptionController,
                  'Description',
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                _buildTextField(_tagsController, 'Tags (comma separated)'),

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
                      onPressed: _isUploading ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                      ),
                      child: _isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save'),
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
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
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
