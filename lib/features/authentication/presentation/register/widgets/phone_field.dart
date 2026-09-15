import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/text_styles.dart';
import '../../../../../core/theme/theme_extensions.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const PhoneField({super.key, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,

      validator: validator,

      cursorColor: context.primary,

      style: AppTextStyles.bodyLarge.copyWith(color: context.onSurface),

      decoration: InputDecoration(
        hintText: "Phone Number",

        prefixIcon: const Icon(Icons.phone_outlined),

        filled: true,

        fillColor: context.colors.surfaceContainerHighest.withValues(alpha: .4),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: context.colors.outlineVariant),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: context.primary, width: 1.6),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.red),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.red, width: 1.6),
        ),
      ),
    ).animate().fadeIn(delay: 350.ms).slideY(begin: .20);
  }
}
