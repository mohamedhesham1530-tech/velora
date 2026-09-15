import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../screens/add_address_body.dart';

class AddAddressScreen extends StatelessWidget {
  final bool isEdit;

  const AddAddressScreen({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: AddAddressBody(isEdit: isEdit),
    );
  }
}
