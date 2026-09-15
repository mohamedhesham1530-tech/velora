import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/app_error_message.dart';

import '../../../domain/repositories/auth_repository.dart';
import 'register_state.dart';
import 'register_status.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository repository;

  RegisterCubit({required this.repository}) : super(const RegisterState());

  bool _isSubmitting = false;

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    if (isClosed || _isSubmitting) return;
    _isSubmitting = true;
    emit(state.copyWith(status: RegisterStatus.loading, errorMessage: null));

    try {
      final user = await repository.register(
        email: email,
        password: password,
        displayName: displayName,
        phoneNumber: phoneNumber,
      );

      if (isClosed) return;
      emit(state.copyWith(status: RegisterStatus.success, user: user));
    } catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: AppErrorMessage.from(e, fallback: 'We could not create your account. Please try again.'),
        ),
      );
    } finally {
      _isSubmitting = false;
    }
  }
}
