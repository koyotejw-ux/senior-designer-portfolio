import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/data/models/profile_model.dart';
import '../../../home/data/providers/content_provider.dart';

class ProfileEditor extends ConsumerStatefulWidget {
  const ProfileEditor({super.key});

  @override
  ConsumerState<ProfileEditor> createState() => _ProfileEditorState();
}

class _ProfileEditorState extends ConsumerState<ProfileEditor> {
  final _formKey = GlobalKey<FormState>();

  // Personal Info
  late TextEditingController _nameController;
  late TextEditingController _birthController;
  late TextEditingController _addressController;
  late TextEditingController _militaryController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  // About Me
  late TextEditingController _introductionController;
  late TextEditingController _philosophyController;
  late TextEditingController _aspirationsController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _birthController = TextEditingController();
    _addressController = TextEditingController();
    _militaryController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _introductionController = TextEditingController();
    _philosophyController = TextEditingController();
    _aspirationsController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _addressController.dispose();
    _militaryController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _introductionController.dispose();
    _philosophyController.dispose();
    _aspirationsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profile = ProfileModel(
        id: 'profile', // Singleton ID
        name: _nameController.text.trim(),
        birth: _birthController.text.trim(),
        address: _addressController.text.trim(),
        military: _militaryController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        introduction: _introductionController.text.trim(),
        philosophy: _philosophyController.text.trim(),
        aspirations: _aspirationsController.text.trim(),
      );

      print('Saving profile: ${profile.name}');
      await ref.read(contentRepositoryProvider).updateProfile(profile);
      ref.invalidate(profileProvider);
      print('Profile saved successfully');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      }
    } catch (e, stackTrace) {
      print('Error updating profile: $e');
      print('Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating profile: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile != null && _nameController.text.isEmpty) {
          _nameController.text = profile.name;
          _birthController.text = profile.birth;
          _addressController.text = profile.address;
          _militaryController.text = profile.military;
          _phoneController.text = profile.phone;
          _emailController.text = profile.email;
          _introductionController.text = profile.introduction;
          _philosophyController.text = profile.philosophy;
          _aspirationsController.text = profile.aspirations;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Personal Info'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_nameController, 'Name')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(_birthController, 'Birth')),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(_addressController, 'Address'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_phoneController, 'Phone')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(_emailController, 'Email')),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(_militaryController, 'Military'),

                const SizedBox(height: 40),
                _buildSectionHeader('About Me'),
                const SizedBox(height: 16),
                _buildTextField(
                  _introductionController,
                  'Introduction',
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  _philosophyController,
                  'Philosophy',
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  _aspirationsController,
                  'Aspirations',
                  maxLines: 5,
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(
        child: Text('Error: $err', style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.accentCyan,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 40, height: 2, color: AppColors.accentCyan),
      ],
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
