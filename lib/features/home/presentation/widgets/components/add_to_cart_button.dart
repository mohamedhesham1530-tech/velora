import 'package:flutter/material.dart';
import '../../../../../core/theme/theme_extensions.dart';

class AddToCartButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const AddToCartButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46,
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,

        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.zero,
          backgroundColor: context.primary,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),

        child: const Icon(Icons.add_rounded, color: Colors.white, size: 24),
      ),
    );
  }
}
