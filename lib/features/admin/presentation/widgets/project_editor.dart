import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
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
  late TextEditingController _orderController;
  late TextEditingController _roleController;
  late TextEditingController _durationController;
  late TextEditingController _teamSizeController;
  late TextEditingController _mainScreenImagesController;

  Uint8List? _imageBytes;
  Uint8List? _thumbnailBytes; // For preview
  XFile? _pickedFile;
  String? _imageUrl;
  bool _isUploading = false;
  bool _isProcessing = false;
  bool _isCorporate = false;

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
    _orderController = TextEditingController(text: (p?.order ?? 0).toString());
    _roleController = TextEditingController(text: p?.role ?? '');
    _durationController = TextEditingController(text: p?.duration ?? '');
    _teamSizeController = TextEditingController(text: p?.teamSize ?? '');
    _mainScreenImagesController = TextEditingController(
      text: p?.mainScreenImages.join(', ') ?? '',
    );
    _imageUrl = p?.imageUrl;
    _isCorporate = p?.isCorporate ?? false;
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
    _orderController.dispose();
    _roleController.dispose();
    _durationController.dispose();
    _teamSizeController.dispose();
    _mainScreenImagesController.dispose();
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
      setState(() => _isProcessing = true);

      try {
        final bytes = await pickedFile.readAsBytes();
        final fileSize = bytes.length;

        debugPrint(
          'Selected image: ${pickedFile.name}, Size: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB',
        );

        // Check file size
        if (fileSize > AppConstants.maxImageSizeBytes) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: AppColors.deepSpace,
                title: const Text(
                  'File Too Large',
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  'The selected image is ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB.\nMaximum allowed size is ${AppConstants.maxImageSizeBytes / 1024 / 1024} MB.',
                  style: const TextStyle(color: Colors.white70),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
          return;
        }

        // Create thumbnail for preview (faster display)
        Uint8List? thumbnailBytes;
        if (fileSize > 1024 * 1024) {
          // If larger than 1MB, create thumbnail
          try {
            final image = img.decodeImage(bytes);
            if (image != null) {
              final thumbnail = img.copyResize(
                image,
                width: AppConstants.thumbnailMaxWidth,
                height: AppConstants.thumbnailMaxHeight,
                interpolation: img.Interpolation.linear,
              );
              thumbnailBytes = Uint8List.fromList(
                img.encodeJpg(
                  thumbnail,
                  quality: AppConstants.thumbnailQuality,
                ),
              );
              debugPrint(
                'Created thumbnail: ${(thumbnailBytes.length / 1024).toStringAsFixed(2)} KB',
              );
            }
          } catch (e) {
            debugPrint('Failed to create thumbnail: $e');
          }
        }

        setState(() {
          _pickedFile = pickedFile;
          _imageBytes = bytes;
          _thumbnailBytes = thumbnailBytes;
        });
      } catch (e) {
        debugPrint('Error processing image: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to process image: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() => _isProcessing = false);
      }
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

      // Use relative URL - works with current origin
      final uri = Uri.parse(AppConstants.uploadEndpoint);
      final request = http.MultipartRequest('POST', uri);

      // Add the file with proper content type
      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        _imageBytes!,
        filename: filename,
      );

      request.files.add(multipartFile);

      debugPrint(
        'Uploading image: $filename (${(_imageBytes!.length / 1024 / 1024).toStringAsFixed(2)} MB)',
      );
      debugPrint('Upload URL: $uri (relative)');

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception(
            'Upload timeout - file may be too large or server is slow',
          );
        },
      );

      debugPrint('Upload response status: ${streamedResponse.statusCode}');

      if (streamedResponse.statusCode == 200) {
        final imageUrl = await streamedResponse.stream.bytesToString();
        debugPrint('Image uploaded successfully: $imageUrl');
        return imageUrl.trim();
      } else {
        final errorBody = await streamedResponse.stream.bytesToString();
        debugPrint('Upload failed: $errorBody');
        throw Exception(
          'Upload failed with status: ${streamedResponse.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error uploading image: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.deepSpace,
            title: const Text(
              'Upload Error',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              '$e\n\nPlease make sure:\n1. The server is running (dart run server/bin/server.dart)\n2. File size is under 50MB\n3. Network connection is stable',
              style: const TextStyle(color: Colors.white70),
            ),
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
      final uploadResponse = await _uploadImage();
      debugPrint('Upload response: $uploadResponse');

      String finalImageUrl = _imageUrl ?? '';
      List<String> finalMainScreenImages = [];

      if (uploadResponse != null) {
        if (uploadResponse.trim().startsWith('{')) {
          try {
            final Map<String, dynamic> parsed = jsonDecode(uploadResponse);
            finalImageUrl = parsed['imageUrl'] ?? '';
            final List<dynamic> slicesList = parsed['slices'] ?? [];
            finalMainScreenImages = slicesList.map((item) => item.toString()).toList();
          } catch (e) {
            debugPrint('Error parsing upload response JSON: $e');
            finalImageUrl = uploadResponse;
          }
        } else {
          finalImageUrl = uploadResponse;
        }
      }

      final tags = _tagsController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      // If we didn't upload a new image, or if the uploadResponse did not contain slices,
      // fallback to the manually entered main screen images.
      if (finalMainScreenImages.isEmpty) {
        finalMainScreenImages = _mainScreenImagesController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }

      // If mainScreenImages is still empty but we have finalImageUrl, use it as a single entry.
      if (finalMainScreenImages.isEmpty && finalImageUrl.isNotEmpty) {
        finalMainScreenImages = [finalImageUrl];
      }

      final project = ProjectModel(
        id: widget.project?.id ?? const Uuid().v4(),
        title: _titleController.text.trim(),
        subtitle: _subtitleController.text.trim(),
        company: _companyController.text.trim(),
        year: _yearController.text.trim(),
        category: _categoryController.text.trim(),
        description: _descriptionController.text.trim(),
        tags: tags,
        imageUrl: finalImageUrl,
        gradientColors:
            widget.project?.gradientColors ??
            [AppColors.primaryBlue, AppColors.accentCyan],
        order: int.tryParse(_orderController.text.trim()) ?? 0,
        role: _roleController.text.trim(),
        duration: _durationController.text.trim(),
        teamSize: _teamSizeController.text.trim(),
        mainScreenImages: finalMainScreenImages,
        designSystem: widget.project?.designSystem,
        isCorporate: _isCorporate,
      );

      debugPrint(
        'Saving project: ${project.title} with image: ${project.imageUrl}',
      );

      final repo = ref.read(contentRepositoryProvider);
      if (widget.project == null) {
        await repo.addProject(project);
        debugPrint('Project added successfully');
      } else {
        await repo.updateProject(project);
        debugPrint('Project updated successfully');
      }

      ref.invalidate(projectsProvider); // Force refresh of project list

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Project saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Error saving project: $e');
      debugPrint('Stack trace: $stackTrace');
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
                    onTap: _isProcessing ? null : _pickImage,
                    child: Container(
                      width: 400,
                      height: 240,
                      decoration: BoxDecoration(
                        color: AppColors.charcoal,
                        border: Border.all(
                          color: _isProcessing
                              ? AppColors.primaryBlue
                              : Colors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _isProcessing
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(
                                  'Processing image...',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            )
                          : _thumbnailBytes != null
                          ? Stack(
                              children: [
                                Center(
                                  child: Image.memory(
                                    _thumbnailBytes!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${(_imageBytes!.length / 1024 / 1024).toStringAsFixed(2)} MB',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : _imageBytes != null
                          ? Stack(
                              children: [
                                Center(
                                  child: Image.memory(
                                    _imageBytes!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${(_imageBytes!.length / 1024 / 1024).toStringAsFixed(2)} MB',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : _imageUrl != null
                          ? Image.network(_imageUrl!, fit: BoxFit.contain)
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Click to select image',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Max 50MB',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
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
                const SizedBox(height: 16),
                _buildTextField(
                  _orderController,
                  'Display Order (0 = first)',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_roleController, 'Role')),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(_durationController, 'Duration'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(_teamSizeController, 'Team Size'),
                const SizedBox(height: 16),
                _buildTextField(
                  _mainScreenImagesController,
                  'Main Screen Images (comma separated URLs)',
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text(
                    'Corporate Project',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Show in the company-specific portfolio tab',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  value: _isCorporate,
                  onChanged: (value) => setState(() => _isCorporate = value),
                  activeColor: AppColors.primaryBlue,
                ),

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
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      keyboardType: keyboardType,
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
