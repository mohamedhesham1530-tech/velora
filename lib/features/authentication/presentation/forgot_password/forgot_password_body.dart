import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/errors/app_error_message.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dialogs/app_dialog.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/utils/responsive.dart';

import '../login/widgets/email_field.dart';

import 'widgets/back_to_login.dart';
import 'widgets/forgot_password_header.dart';
import 'widgets/send_reset_button.dart';

class ForgotPasswordBody extends StatefulWidget {
  const ForgotPasswordBody({super.key});

  @override
  State<ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<ForgotPasswordBody> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final AuthRepository _repository = sl<AuthRepository>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!value.contains('@')) {
      return 'Please enter a valid email';
    }

    return null;
  }

  Future<void> _sendResetLink() async {
    FocusScope.of(context).unfocus();

    if (_isLoading || !(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      await _repository.resetPassword(email: _emailController.text.trim());
      if (!mounted) return;
      await AppDialog.success(
        context: context,
        title: 'Check your email',
        message: 'A password reset link has been sent to your email address.',
      );
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      await AppDialog.error(
        context: context,
        title: 'Reset failed',
        message: AppErrorMessage.from(error, fallback: 'We could not send the reset link. Please try again.'),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),

      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: context.wp(.06),
            vertical: context.hp(.025),
          ),

          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: context.maxContentWidth),

              child: Form(
                key: _formKey,

                child: Column(
                  children: [
                    const ForgotPasswordHeader(),

                    SizedBox(height: context.hp(.045)),

                    Container(
                      width: double.infinity,

                      padding: const EdgeInsets.all(24),

                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.94),

                        borderRadius: BorderRadius.circular(30),

                        border: Border.all(color: Colors.white),

                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(.08),
                            blurRadius: 35,
                            offset: const Offset(0, 18),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          EmailField(
                            controller: _emailController,
                            validator: _emailValidator,
                          ),

                          const SizedBox(height: 24),
                          SendResetButton(
                            onPressed: _sendResetLink,
                            isLoading: _isLoading,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.hp(.045)),

                    BackToLogin(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),

                    SizedBox(height: context.hp(.02)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
