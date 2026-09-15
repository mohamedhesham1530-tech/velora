import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../../../navigation/presentation/screens/main_navigation_screen.dart';
import '../cubit/login/login_cubit.dart';
import '../cubit/login/login_state.dart';
import '../cubit/login/login_status.dart';
import '../forgot_password/forgot_password_screen.dart';
import '../register/register_screen.dart';
import 'widgets/email_field.dart';
import 'widgets/login_button.dart';
import 'widgets/login_footer.dart';
import 'widgets/login_header.dart';
import 'widgets/password_field.dart';
import 'widgets/remember_me.dart';
import 'widgets/social_buttons.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({super.key});

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool rememberMe = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  void _login() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
          );
        }

        if (state.status == LoginStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Login Failed')),
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
                      const LoginHeader(),

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
                            EmailField(
                              controller: _emailController,
                              validator: _emailValidator,
                            ),

                            const SizedBox(height: 18),

                            PasswordField(
                              controller: _passwordController,
                              validator: _passwordValidator,
                            ),

                            const SizedBox(height: 8),

                            RememberMe(
                              value: rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  rememberMe = value ?? false;
                                });
                              },
                              onForgotPassword: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const ForgotPasswordScreen(),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            BlocBuilder<LoginCubit, LoginState>(
                              builder: (context, state) {
                                return LoginButton(
                                  onPressed: _login,
                                  isLoading:
                                      state.status == LoginStatus.loading,
                                );
                              },
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

                      LoginFooter(
                        onSignUp: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
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
