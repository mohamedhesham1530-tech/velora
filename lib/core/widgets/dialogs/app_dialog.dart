import 'package:flutter/material.dart';

import '../../theme/theme_extensions.dart';

class AppDialog {
  AppDialog._();

  static Future<void> success({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _DialogWidget(
        icon: Icons.check_circle_rounded,
        iconColor: Colors.green,
        title: title,
        message: message,
      ),
    );
  }

  static Future<void> error({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _DialogWidget(
        icon: Icons.cancel_rounded,
        iconColor: Colors.redAccent,
        title: title,
        message: message,
      ),
    );
  }
}

class _DialogWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;

  const _DialogWidget({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow.withValues(alpha: .08),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: iconColor.withOpacity(.12),
              child: Icon(icon, color: iconColor, size: 42),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: context.onSurface),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: context.colors.onSurfaceVariant,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primary,
                  foregroundColor: context.onPrimary,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
