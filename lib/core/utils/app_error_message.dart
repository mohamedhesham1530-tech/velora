import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../network/api_exception.dart';

/// Converts low-level exceptions into short, user-safe messages.
///
/// Technical exception text should stay in debug logs, never in a SnackBar or
/// dialog shown to a customer.
class AppErrorMessage {
  AppErrorMessage._();

  static String from(Object error) {
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
          return 'Choose a stronger password.';
        case 'too-many-requests':
          return 'Too many attempts. Please wait a moment and try again.';
        case 'network-request-failed':
          return 'A network error occurred. Check your connection and try again.';
        case 'user-disabled':
          return 'This account is currently disabled.';
        case 'requires-recent-login':
          return 'Please sign in again before performing this action.';
        default:
          return 'We could not complete the authentication request. Please try again.';
      }
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'The request took too long. Please try again.';
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your connection and try again.';
        case DioExceptionType.badResponse:
          final status = error.response?.statusCode;
          if (status == 401 || status == 403) {
            return 'You are not authorized to perform this action.';
          }
          if (status != null && status >= 500) {
            return 'The service is temporarily unavailable. Please try again later.';
          }
          return 'The server could not complete the request.';
        default:
          return 'We could not complete the request. Please try again.';
      }
    }

    if (error is ApiException) {
      return error.message.isNotEmpty
          ? error.message
          : 'Something went wrong. Please try again.';
    }

    if (error is TimeoutException) {
      return 'The operation took too long. Please try again.';
    }

    if (error is FormatException) {
      return 'We received unexpected data. Please try again.';
    }

    if (error is StateError) {
      return error.message.isNotEmpty
          ? error.message
          : 'This action is not available right now.';
    }

    return 'Something went wrong. Please try again.';
  }
}
