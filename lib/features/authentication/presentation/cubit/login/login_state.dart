import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';
import 'login_status.dart';

class LoginState extends Equatable {
  final LoginStatus status;

  final UserEntity? user;

  final String? errorMessage;

  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.errorMessage,
  });

  LoginState copyWith({
    LoginStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return LoginState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
