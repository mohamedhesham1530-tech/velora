import 'package:flutter/material.dart';

import '../../../../../core/errors/app_error_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';
import 'login_state.dart';
import 'login_status.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository repository;

  LoginCubit({required this.repository}) : super(const LoginState());

  bool _isSubmitting = false;

  Future<void> login({required String email, required String password}) async {
    if (_isSubmitting || isClosed) return;
    _isSubmitting = true;
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));

    try {
      final user = await repository.login(email: email, password: password);

      if (isClosed) return;
      emit(state.copyWith(status: LoginStatus.success, user: user));
    } catch (e, s) {
      debugPrint("ERROR TYPE: ${e.runtimeType}");
      debugPrint("ERROR: $e");
      debugPrintStack(stackTrace: s);

      if (isClosed) return;
      emit(
        state.copyWith(status: LoginStatus.failure, errorMessage: AppErrorMessage.from(e, fallback: 'We could not sign you in. Please try again.')),
      );
    } finally {
      _isSubmitting = false;
    }
  }
}
