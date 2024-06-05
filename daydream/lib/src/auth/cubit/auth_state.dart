part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthLoaded extends AuthState {
  UserModel user;

  AuthLoaded(this.user);
}

final class AuthError extends AuthState {
  String message;

  AuthError(this.message);
}
