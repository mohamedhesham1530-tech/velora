import '../../domain/entities/user_entity.dart';
import 'dart:typed_data';
import '../../domain/repositories/auth_repository.dart';

import '../datasources/firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) {
    return remoteDataSource.login(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) {
    return remoteDataSource.register(
      email: email,
      password: password,
      displayName: displayName,
      phoneNumber: phoneNumber,
    );
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) {
    return remoteDataSource.resetPassword(email);
  }

  @override
  Future<UserEntity?> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Stream<UserEntity?> watchCurrentUser() => remoteDataSource.watchCurrentUser();

  @override
  Future<UserEntity> updateProfile({
    required String displayName,
    required String phoneNumber,
    Uint8List? photoBytes,
  }) => remoteDataSource.updateProfile(
    displayName: displayName,
    phoneNumber: phoneNumber,
    photoBytes: photoBytes,
  );
}
