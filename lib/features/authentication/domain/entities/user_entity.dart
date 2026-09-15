import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String provider;
  final DateTime? createdAt;

  const UserEntity({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    required this.provider,
    this.createdAt,
  });

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl, phoneNumber, provider, createdAt];
}
