import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/services/firebase_auth_service.dart';
import '../../domain/entities/user_entity.dart';

abstract class FirebaseAuthDataSource {
  Future<UserEntity> login({required String email, required String password});

  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  });

  Future<void> logout();

  Future<void> resetPassword(String email);

  Future<UserEntity?> getCurrentUser();
  Stream<UserEntity?> watchCurrentUser();
  Future<UserEntity> updateProfile({
    required String displayName,
    required String phoneNumber,
    Uint8List? photoBytes,
  });
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuthService authService;
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FirebaseAuthDataSourceImpl({
    required this.authService,
    required this.firestore,
    required this.storage,
  });

  Future<UserEntity> _mapUser(User user) async {
    Map<String, dynamic>? data;
    try {
      final profile = await firestore.collection('profiles').doc(user.uid).get();
      data = profile.data();
    } catch (_) {
      // Firebase Auth remains the source of truth when profile metadata is offline.
    }
    final profilePhotoUrl = data == null ? null : data['photoUrl'];
    final profilePhoneNumber = data == null ? null : data['phoneNumber'];
    final providerIds = user.providerData.map((provider) => provider.providerId).toSet();
    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL ?? (profilePhotoUrl is String ? profilePhotoUrl : null),
      phoneNumber: profilePhoneNumber is String ? profilePhoneNumber : user.phoneNumber,
      provider: providerIds.contains('google.com') ? 'Google' : 'Email',
      createdAt: user.metadata.creationTime,
    );
  }

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final credential = await authService.signIn(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw FirebaseAuthException(code: 'missing-user');
    return _mapUser(user);
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
    required String phoneNumber,
  }) async {
    final credential = await authService.register(
      email: email,
      password: password,
    );

    final user = credential.user;
    if (user == null) throw FirebaseAuthException(code: 'missing-user');

    // The Firebase account is created and signed in at this point. Persist the
    // registration fields immediately so the form never silently loses them.
    await authService.updateProfile(displayName: displayName);
    await firestore.collection('profiles').doc(user.uid).set({
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return _mapUser(authService.currentUser ?? user);
  }

  @override
  Future<void> logout() {
    return authService.signOut();
  }

  @override
  Future<void> resetPassword(String email) {
    return authService.sendPasswordResetEmail(email);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final user = authService.currentUser;
    if (user == null) return null;
    return _mapUser(user);
  }

  @override
  Stream<UserEntity?> watchCurrentUser() => authService.authStateChanges.asyncMap(
    (user) => user == null ? null : _mapUser(user),
  );

  @override
  Future<UserEntity> updateProfile({
    required String displayName,
    required String phoneNumber,
    Uint8List? photoBytes,
  }) async {
    final currentUser = authService.currentUser;
    if (currentUser == null) throw StateError('No authenticated user found.');

    String? photoUrl;
    if (photoBytes != null) {
      final reference = storage.ref(
        'profile_images/${currentUser.uid}/avatar_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await reference.putData(
        photoBytes,
        SettableMetadata(contentType: 'image/jpeg', cacheControl: 'no-cache'),
      );
      final downloadUrl = await reference.getDownloadURL();
      photoUrl = '$downloadUrl&v=${DateTime.now().millisecondsSinceEpoch}';
    }

    final user = await authService.updateProfile(
      displayName: displayName,
      photoUrl: photoUrl,
    );
    await firestore.collection('profiles').doc(user.uid).set({
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      if (photoUrl != null) 'photoUrl': photoUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return _mapUser(user);
  }
}
