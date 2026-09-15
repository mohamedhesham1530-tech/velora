import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/notifications/presentation/cubit/notification_cubit.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _key = 'theme_mode';
  final SharedPreferences preferences;
  final NotificationCubit? notificationCubit;

  ThemeCubit({required this.preferences, this.notificationCubit})
    : super(
        preferences.getBool(_key) == true ? ThemeMode.dark : ThemeMode.light,
      );

  Future<void> toggle(bool isDark) async {
    final next = isDark ? ThemeMode.dark : ThemeMode.light;
    if (state == next) return;
    emit(next);
    await preferences.setBool(_key, isDark);
    await notificationCubit?.addNotification(
      title: 'Appearance Updated',
      body: isDark ? 'Dark mode was enabled.' : 'Light mode was enabled.',
      iconName: 'dark_mode',
    );
  }
}
