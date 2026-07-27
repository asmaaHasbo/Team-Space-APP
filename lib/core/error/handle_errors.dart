import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class AuthFailureException extends AppException {
  const AuthFailureException(super.message);
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'Something went wrong']);
}

Never handleError(Object error) {
  if (error is AppException) throw error;
  if (error is AuthException) throw AuthFailureException(error.message);
  if (error is PostgrestException) throw ServerException(error.message);
  if (error is SocketException) throw const NetworkException();
  throw const ServerException();
}