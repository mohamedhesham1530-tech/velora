import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/text_styles.dart';

class PasswordStrength extends StatelessWidget {
  final String password;

  const PasswordStrength({super.key, required this.password});

  int get _strength {
    if (password.isEmpty) return 0;

    int score = 0;

    if (password.length >= 8) score++;

    if (RegExp(r'[A-Z]').hasMatch(password)) score++;

    if (RegExp(r'[0-9]').hasMatch(password)) score++;

    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    return score;
  }

  Color get _color {
    switch (_strength) {
      case 0:
      case 1:
        return AppColors.error;

      case 2:
        return AppColors.warning;

      case 3:
        return Colors.lightGreen;

      default:
        return AppColors.success;
    }
  }

  String get _label {
    switch (_strength) {
      case 0:
        return "";

      case 1:
        return "Weak Password";

      case 2:
        return "Medium Password";

      case 3:
        return "Good Password";

      default:
        return "Strong Password";
    }
  }

  double get _progress {
    switch (_strength) {
      case 0:
        return 0;

      case 1:
        return .25;

      case 2:
        return .50;

      case 3:
        return .75;

      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: _color,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: LinearProgressIndicator(
            value: _progress,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation(_color),
          ),
        ),
      ],
    ).animate().fadeIn().slideY(begin: .15);
  }
}
