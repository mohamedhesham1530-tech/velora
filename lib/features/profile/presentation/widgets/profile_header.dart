import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? imageUrl;
  final VoidCallback onEdit;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    this.imageUrl,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.circular(30),
      ),

      child: Column(
        children: [
          // =====================================================
          // Profile Image
          // =====================================================
          Stack(
            children: [
              Container(
                width: 110,
                height: 110,

                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,

                  border: Border.all(color: colors.surface, width: 4),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .15),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),

                child: ClipOval(
                  child: imageUrl == null || imageUrl!.isEmpty
                      ? Icon(
                          Icons.person_rounded,
                          size: 60,
                          color: colors.primary,
                        )
                      : Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,

                          errorBuilder: (_, __, ___) {
                            return Icon(
                              Icons.person_rounded,
                              size: 60,
                              color: colors.primary,
                            );
                          },
                        ),
                ),
              ),

              // =================================================
              // Camera Button
              // =================================================
              Positioned(
                right: 0,
                bottom: 0,

                child: GestureDetector(
                  onTap: onEdit,

                  child: Container(
                    width: 34,
                    height: 34,

                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    child: Icon(
                      Icons.camera_alt_rounded,
                      color: colors.primary,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // =====================================================
          // Name
          // =====================================================
          Text(
            name,
            textAlign: TextAlign.center,

            style: AppTextStyles.headlineLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          // =====================================================
          // Email
          // =====================================================
          if (email.isNotEmpty)
            Text(
              email,
              textAlign: TextAlign.center,

              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: .9),
              ),
            ),

          const SizedBox(height: 22),

          // =====================================================
          // Edit Button
          // =====================================================
          SizedBox(
            height: 46,

            child: ElevatedButton.icon(
              onPressed: onEdit,

              style: ElevatedButton.styleFrom(
                // White in light & dark mode because
                // it sits on the purple gradient.
                backgroundColor: Colors.white,

                foregroundColor: AppColors.primary,

                elevation: 0,

                padding: const EdgeInsets.symmetric(horizontal: 24),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),

              icon: const Icon(Icons.edit_rounded),

              label: Text('profile.editProfile'.tr()),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: -.2);
  }
}
