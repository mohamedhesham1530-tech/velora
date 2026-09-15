import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/localization/localization_cubit.dart';
import '../../../home/presentation/screens/notifications_screen.dart';
import '../../../authentication/presentation/login/login_screen.dart';
import '../../../cart/presentation/screens/cart_screen.dart';
import '../../../orders/presentation/screens/orders_screen.dart';
import '../../../wishlist/presentation/screens/wishlist_screen.dart';

import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

import '../widgets/logout_dialog.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/profile_section_title.dart';
import '../widgets/profile_statistics.dart';

import 'about_app_screen.dart';
import 'edit_profile_screen.dart';
import 'profile_info_screen.dart';
import 'shipping_address_screen.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final user = state.user;

        return SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =========================================================
                // Profile Header
                // =========================================================
                ProfileHeader(
                  name: user?.displayName?.isNotEmpty == true
                      ? user!.displayName!
                      : 'profile.member'.tr(),
                  email: user?.email ?? '',
                  imageUrl: user?.photoUrl,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),

                // =========================================================
                // Phone / Provider
                // =========================================================
                if (user != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      '${'profile.phone'.tr()}: '
                      '${user.phoneNumber?.isNotEmpty == true ? user.phoneNumber : 'profile.phoneNotAdded'.tr()}'
                      ' • ${user.provider}',
                      style: context.text.bodyMedium?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),

                // =========================================================
                // Statistics
                // =========================================================
                const ProfileStatistics(),

                const SizedBox(height: 32),

                // =========================================================
                // Account
                // =========================================================
                ProfileSectionTitle(title: 'profile.account'.tr()),

                _item(
                  context,
                  Icons.favorite_outline_rounded,
                  'profile.wishlist'.tr(),
                  'profile.wishlistSubtitle'.tr(),
                  const WishlistScreen(),
                ),

                _item(
                  context,
                  Icons.shopping_cart_outlined,
                  'profile.cart'.tr(),
                  'profile.cartSubtitle'.tr(),
                  const CartScreen(),
                ),

                _item(
                  context,
                  Icons.inventory_2_outlined,
                  'profile.orders'.tr(),
                  'profile.ordersSubtitle'.tr(),
                  const OrdersScreen(),
                ),

                _item(
                  context,
                  Icons.location_on_outlined,
                  'profile.shippingAddress'.tr(),
                  'profile.shippingAddressSubtitle'.tr(),
                  const ShippingAddressScreen(),
                ),

                _infoItem(
                  context,
                  Icons.credit_card_outlined,
                  'profile.paymentMethods'.tr(),
                  'profile.noPaymentMethods'.tr(),
                ),

                const SizedBox(height: 20),

                // =========================================================
                // Preferences
                // =========================================================
                ProfileSectionTitle(title: 'profile.preferences'.tr()),
                ProfileMenuItem(
                  icon: Icons.notifications_none_rounded,
                  title: 'profile.notifications'.tr(),
                  subtitle: 'profile.notificationSubtitle'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),

                // =========================================================
                // Dark Mode
                // =========================================================
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, mode) {
                    return ProfileMenuItem(
                      icon: Icons.dark_mode_outlined,
                      title: 'profile.darkMode'.tr(),
                      subtitle: 'profile.darkModeSubtitle'.tr(),
                      hasSwitch: true,
                      switchValue: mode == ThemeMode.dark,
                      onSwitchChanged: (value) {
                        context.read<ThemeCubit>().toggle(value);
                      },
                    );
                  },
                ),

                // =========================================================
                // Language
                // =========================================================
                BlocBuilder<LocalizationCubit, Locale>(
                  builder: (context, locale) {
                    return ProfileMenuItem(
                      icon: Icons.language_outlined,
                      title: 'profile.language'.tr(),
                      subtitle: locale.languageCode == 'ar'
                          ? 'language.arabic'.tr()
                          : 'language.english'.tr(),
                      onTap: () => _showLanguageDialog(context),
                    );
                  },
                ),

                // =========================================================
                // Help Center
                // =========================================================
                _infoItem(
                  context,
                  Icons.help_outline_rounded,
                  'profile.helpCenter'.tr(),
                  'profile.helpCenterSubtitle'.tr(),
                ),

                // =========================================================
                // About App
                // =========================================================
                ProfileMenuItem(
                  icon: Icons.info_outline_rounded,
                  title: 'profile.aboutApp'.tr(),
                  subtitle: 'profile.version'.tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutAppScreen()),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // =========================================================
                // Logout
                // =========================================================
                ProfileSectionTitle(title: 'profile.account'.tr()),

                ProfileMenuItem(
                  icon: Icons.logout_rounded,
                  title: 'profile.logout'.tr(),
                  subtitle: 'profile.logoutSubtitle'.tr(),
                  showArrow: false,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // Navigation Item
  // =========================================================

  Widget _item(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget screen,
  ) {
    return ProfileMenuItem(
      icon: icon,
      title: title,
      subtitle: subtitle,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
    );
  }

  // =========================================================
  // Information Item
  // =========================================================

  Widget _infoItem(
    BuildContext context,
    IconData icon,
    String title,
    String message,
  ) {
    return ProfileMenuItem(
      icon: icon,
      title: title,
      subtitle: message,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ProfileInfoScreen(title: title, message: message, icon: icon),
          ),
        );
      },
    );
  }

  // =========================================================
  // Logout Dialog
  // =========================================================

  Future<void> _showLogoutDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return LogoutDialog(
          onLogout: () async {
            Navigator.pop(context);

            try {
              await context.read<ProfileCubit>().logout();

              if (!context.mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            } catch (_) {
              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('authentication.logoutFailed'.tr())),
              );
            }
          },
        );
      },
    );
  }

  // =========================================================
  // Language Dialog
  // =========================================================

  Future<void> _showLanguageDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        final currentLocale = context.locale;

        return AlertDialog(
          title: Text('language.select'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // =========================================================
              // English
              // =========================================================
              ListTile(
                leading: const Text('🇺🇸', style: TextStyle(fontSize: 22)),
                title: Text('language.english'.tr()),
                trailing: currentLocale.languageCode == 'en'
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () async {
                  const locale = Locale('en');

                  // Update EasyLocalization
                  await context.setLocale(locale);
                  if (!context.mounted) return;

                  // Save / update Cubit state
                  await context.read<LocalizationCubit>().changeLanguage(
                    locale,
                  );

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                },
              ),

              // =========================================================
              // Arabic
              // =========================================================
              ListTile(
                leading: const Text('🇪🇬', style: TextStyle(fontSize: 22)),
                title: Text('language.arabic'.tr()),
                trailing: currentLocale.languageCode == 'ar'
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () async {
                  const locale = Locale('ar');

                  // Update EasyLocalization
                  await context.setLocale(locale);
                  if (!context.mounted) return;

                  // Save / update Cubit state
                  await context.read<LocalizationCubit>().changeLanguage(
                    locale,
                  );

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('common.cancel'.tr()),
            ),
          ],
        );
      },
    );
  }
}
