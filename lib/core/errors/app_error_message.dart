import 'package:firebase_auth/firebase_auth.dart';

/// Converts technical exceptions into short, user-safe messages.
/// Technical details should stay in debug logs rather than being shown in UI.
class AppErrorMessage {
  const AppErrorMessage._();

  static String from(Object error, {String fallback = 'Something went wrong. Please try again.'}) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          return 'The email or password is incorrect.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'weak-password':
          return 'Please choose a stronger password.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        case 'network-request-failed':
          return 'Please check your internet connection and try again.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'operation-not-allowed':
          return 'This sign-in method is not available right now.';
        default:
          return fallback;
      }
    }

    final text = error.toString().toLowerCase();
    if (text.contains('socketexception') ||
        text.contains('network') ||
        text.contains('connection')) {
      return 'Please check your internet connection and try again.';
    }
    if (text.contains('timeout')) {
      return 'The request took too long. Please try again.';
    }
    if (text.contains('permission-denied') || text.contains('permission denied')) {
      return 'You do not have permission to complete this action.';
    }

    return fallback;
  }
}
