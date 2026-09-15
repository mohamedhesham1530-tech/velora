import '../entities/user_entity.dart';
import 'dart:typed_data';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  });

  Future<void> logout();

  Future<void> resetPassword({required String email});

  Future<UserEntity?> getCurrentUser();
  Stream<UserEntity?> watchCurrentUser();
  Future<UserEntity> updateProfile({
    required String displayName,
    required String phoneNumber,
    Uint8List? photoBytes,
  });
}
