import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class EditProfileBody extends StatefulWidget {
  const EditProfileBody({super.key});

  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  Uint8List? _photoBytes;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // ============================================================
  // Pick Image
  // ============================================================

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (image == null) return;

      final bytes = await image.readAsBytes();

      if (mounted) {
        setState(() {
          _photoBytes = bytes;
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('errors.imageAccess'.tr())));
      }
    }
  }

  // ============================================================
  // Image Source Picker
  // ============================================================

  Future<void> _showSourcePicker() async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text('profile.takePhoto'.tr()),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text('profile.chooseFromGallery'.tr()),
              onTap: () {
                Navigator.pop(sheetContext);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final user = state.user;

        if (!_initialized && user != null) {
          _initialized = true;

          _nameController.text = user.displayName ?? '';
          _phoneController.text = user.phoneNumber ?? '';
        }

        final saving = state.status == ProfileStatus.loading;

        return SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // ========================================================
                  // Header
                  // ========================================================
                  Row(
                    children: [
                      IconButton(
                        onPressed: saving ? null : () => Navigator.pop(context),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: context.onSurface,
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Text(
                            'profile.editProfile'.tr(),
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: context.onSurface,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 48),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // ========================================================
                  // Profile Image
                  // ========================================================
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: context.primary.withValues(alpha: .12),
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: _photoBytes != null
                              ? Image.memory(_photoBytes!, fit: BoxFit.cover)
                              : user?.photoUrl?.isNotEmpty == true
                              ? Image.network(
                                  user!.photoUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.person,
                                    size: 60,
                                    color: context.primary,
                                  ),
                                )
                              : Icon(
                                  Icons.person,
                                  size: 60,
                                  color: context.primary,
                                ),
                        ),
                      ),

                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: saving ? null : _showSourcePicker,
                          child: CircleAvatar(
                            radius: 19,
                            backgroundColor: context.primary,
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // ========================================================
                  // Full Name
                  // ========================================================
                  TextFormField(
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'profile.name'.tr(),
                      prefixIcon: const Icon(Icons.person_outline),
                      filled: true,
                      fillColor: context.colors.surfaceContainerHighest
                          .withValues(alpha: .4),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().length < 2) {
                        return 'authentication.requiredField'.tr();
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ========================================================
                  // Phone Number
                  // ========================================================
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'profile.phone'.tr(),
                      prefixIcon: const Icon(Icons.phone_outlined),
                      filled: true,
                      fillColor: context.colors.surfaceContainerHighest
                          .withValues(alpha: .4),
                    ),
                    validator: (value) {
                      if (value != null &&
                          value.trim().isNotEmpty &&
                          value.trim().length < 7) {
                        return 'authentication.invalidPhone'.tr();
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // ========================================================
                  // Email
                  // ========================================================
                  TextFormField(
                    initialValue: user?.email ?? '',
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'profile.email'.tr(),
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: context.colors.surfaceContainerHighest
                          .withValues(alpha: .4),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // ========================================================
                  // Save Button
                  // ========================================================
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: saving
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }

                              try {
                                await context
                                    .read<ProfileCubit>()
                                    .updateProfile(
                                      displayName: _nameController.text.trim(),
                                      phoneNumber: _phoneController.text.trim(),
                                      photoBytes: _photoBytes,
                                    );

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'profile.profileUpdated'.tr(),
                                      ),
                                    ),
                                  );

                                  Navigator.pop(context);
                                }
                              } catch (_) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'profile.updateFailed'.tr(),
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.primary,
                        foregroundColor: context.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      icon: saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text('profile.saveChanges'.tr()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
