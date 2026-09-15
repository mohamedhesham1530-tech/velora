import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/theme_extensions.dart';
import '../screens/edit_profile_body.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            theme.brightness == Brightness.dark
                ? Brightness.light
                : Brightness.dark,
        statusBarBrightness:
            theme.brightness == Brightness.dark
                ? Brightness.dark
                : Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: context.background,
      body: const EditProfileBody(),
    );
  }
}