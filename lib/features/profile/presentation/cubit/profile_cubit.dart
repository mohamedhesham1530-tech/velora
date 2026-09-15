import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/domain/repositories/auth_repository.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository repository;
  final NotificationCubit? notificationCubit;
  StreamSubscription? _userSubscription;

  ProfileCubit({required this.repository, this.notificationCubit})
    : super(const ProfileState());

  void watchProfile() {
    _userSubscription?.cancel();
    emit(state.copyWith(status: ProfileStatus.loading));
    _userSubscription = repository.watchCurrentUser().listen(
      (user) {
        if (isClosed) return;
        emit(
          ProfileState(
            status: user == null ? ProfileStatus.initial : ProfileStatus.success,
            user: user,
          ),
        );
      },
      onError: (Object error) {
        if (isClosed) return;
        emit(
          ProfileState(
            status: ProfileStatus.failure,
            errorMessage: 'Unable to load your profile. Please try again.',
          ),
        );
      },
    );
  }

  Future<void> updateProfile({
    required String displayName,
    required String phoneNumber,
    Uint8List? photoBytes,
  }) async {
    if (isClosed) return;
    final normalizedName = displayName.trim();
    if (normalizedName.isEmpty)
      throw ArgumentError.value(displayName, 'displayName');
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final user = await repository.updateProfile(
        displayName: normalizedName,
        phoneNumber: phoneNumber.trim(),
        photoBytes: photoBytes,
      );
      if (isClosed) return;
      emit(ProfileState(status: ProfileStatus.success, user: user));
      await notificationCubit?.addNotification(
        title: photoBytes == null
            ? 'Profile Updated'
            : 'Profile Picture Updated',
        body: photoBytes == null
            ? 'Your profile details were updated successfully.'
            : 'Your profile picture was updated successfully.',
        iconName: photoBytes == null ? 'person' : 'photo_camera',
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'Unable to update your profile. Please try again.',
        ),
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    if (isClosed) return;
    try {
      await repository.logout();
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'Unable to sign out. Please try again.',
        ),
      );
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    await _userSubscription?.cancel();
    return super.close();
  }
}
