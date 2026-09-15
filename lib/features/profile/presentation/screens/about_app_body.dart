import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class AboutAppBody extends StatelessWidget {
  const AboutAppBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // =========================
            // Header
            // =========================
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded),
                ),

                Expanded(
                  child: Center(
                    child: Text(
                      'about.title'.tr(),
                      style: AppTextStyles.headlineMedium,
                    ),
                  ),
                ),

                const SizedBox(width: 48),
              ],
            ),

            const SizedBox(height: 35),

            // =========================
            // App Icon
            // =========================
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                size: 55,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 20),

            // =========================
            // App Name
            // =========================
            const Text('Velora', style: AppTextStyles.displayLarge),

            const SizedBox(height: 8),

            // =========================
            // Description
            // =========================
            Text(
              'about.description'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey700,
              ),
            ),

            const SizedBox(height: 6),

            // =========================
            // Version
            // =========================
            Text(
              'about.version'.tr(),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),

            const SizedBox(height: 40),

            // =========================
            // Privacy Policy
            // =========================
            _AboutTile(
              icon: Icons.privacy_tip_outlined,
              title: 'about.privacyPolicy'.tr(),
              onTap: () {},
            ),

            // =========================
            // Terms & Conditions
            // =========================
            _AboutTile(
              icon: Icons.description_outlined,
              title: 'about.termsConditions'.tr(),
              onTap: () {},
            ),

            // =========================
            // Share App
            // =========================
            _AboutTile(
              icon: Icons.share_outlined,
              title: 'about.shareApp'.tr(),
              onTap: () {},
            ),

            // =========================
            // Rate App
            // =========================
            _AboutTile(
              icon: Icons.star_outline_rounded,
              title: 'about.rateApp'.tr(),
              onTap: () {},
            ),

            const SizedBox(height: 40),

            // =========================
            // Footer
            // =========================
            Text(
              'about.madeWithFlutter'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey700,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'about.copyright'.tr(),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// About Tile
// ======================================================

class _AboutTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AboutTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Detect current text direction safely.
    final isRTL = Directionality.of(context).name == 'rtl';

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                // =========================
                // Icon
                // =========================
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.primary),
                ),

                const SizedBox(width: 16),

                // =========================
                // Title
                // =========================
                Expanded(child: Text(title, style: AppTextStyles.titleMedium)),

                // =========================
                // Direction Arrow
                // =========================
                Transform.rotate(
                  angle: isRTL ? 3.141592653589793 : 0,
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
