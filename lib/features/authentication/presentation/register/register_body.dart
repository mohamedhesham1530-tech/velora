import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';

import '../cubit/register/register_cubit.dart';
import '../cubit/register/register_state.dart';
import '../cubit/register/register_status.dart';

import '../login/widgets/email_field.dart';
import '../login/widgets/password_field.dart';
import '../login/widgets/social_buttons.dart';
import '../../../../core/widgets/dialogs/app_dialog.dart';
import 'widgets/create_account_button.dart';
import 'widgets/full_name_field.dart';
import 'widgets/password_strength.dart';
import 'widgets/phone_field.dart';
import 'widgets/register_footer.dart';
import 'widgets/register_header.dart';
import 'widgets/terms_checkbox.dart';

class RegisterBody extends StatefulWidget {
  const RegisterBody({super.key});

  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool agreeTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }

    return null;
  }

  void _register() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms & Conditions')),
      );
      return;
    }

    context.read<RegisterCubit>().register(
      displayName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) async {
        if (state.status == RegisterStatus.success) {
          await AppDialog.success(
            context: context,
            title: 'Welcome!',
            message: 'Your account has been created successfully.',
          );

          if (context.mounted) {
            Navigator.pop(context);
          }
        }

        if (state.status == RegisterStatus.failure) {
          await AppDialog.error(
            context: context,
            title: 'Registration Failed',
            message: state.errorMessage ?? 'Something went wrong.',
          );
        }
      },
      child: GestureDetector(
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
                      const RegisterHeader(),

                      SizedBox(height: context.hp(.04)),

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
                            FullNameField(
                              controller: _fullNameController,
                              validator: (value) => _requiredValidator(
                                value,
                                'Please enter your full name',
                              ),
                            ),

                            const SizedBox(height: 18),

                            EmailField(
                              controller: _emailController,
                              validator: (value) => _requiredValidator(
                                value,
                                'Please enter your email',
                              ),
                            ),

                            const SizedBox(height: 18),

                            PhoneField(
                              controller: _phoneController,
                              validator: (value) => _requiredValidator(
                                value,
                                'Please enter your phone number',
                              ),
                            ),

                            const SizedBox(height: 18),

                            PasswordField(
                              controller: _passwordController,
                              validator: (value) => _requiredValidator(
                                value,
                                'Please enter your password',
                              ),
                            ),

                            const SizedBox(height: 14),

                            PasswordStrength(
                              password: _passwordController.text,
                            ),

                            const SizedBox(height: 18),

                            PasswordField(
                              controller: _confirmPasswordController,
                              validator: _confirmPasswordValidator,
                            ),

                            const SizedBox(height: 18),

                            TermsCheckbox(
                              value: agreeTerms,
                              onChanged: (value) {
                                setState(() {
                                  agreeTerms = value ?? false;
                                });
                              },
                              onTermsPressed: () {},
                            ),

                            const SizedBox(height: 24),

                            BlocBuilder<RegisterCubit, RegisterState>(
                              builder: (context, state) => CreateAccountButton(
                                onPressed: _register,
                                isLoading: state.status == RegisterStatus.loading,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: context.hp(.04)),

                      SocialButtons(
                        onGooglePressed: () {},
                        onApplePressed: () {},
                      ),

                      SizedBox(height: context.hp(.035)),

                      RegisterFooter(
                        onSignIn: () {
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
      ),
    );
  }
}
