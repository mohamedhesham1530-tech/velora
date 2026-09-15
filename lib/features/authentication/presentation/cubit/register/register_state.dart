import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';
import 'register_status.dart';

class RegisterState extends Equatable {
  final RegisterStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const RegisterState({
    this.status = RegisterStatus.initial,
    this.user,
    this.errorMessage,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return RegisterState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
