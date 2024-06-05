import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:daydream/src/home/cubit/friends_cubit.dart';
import 'package:daydream/src/models/user_model.dart';
import 'package:daydream/src/services/auth_service.dart';
import 'package:daydream/src/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthService authService;
  UserService userService;

  AuthCubit(this.authService, this.userService) : super(AuthInitial()) {
    authService.authStateStream.listen((User? user) {
      if (user != null) {
        userService.getUserById(user.uid).then((UserModel? userModel) {
          if (userModel != null) {
            emit(AuthLoaded(userModel));
          } else {
            // emit(AuthError('AuthCubit-Constructor: userModel is null'));
            emit(AuthInitial());
          }
        });
      } else {
        emit(AuthInitial());
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await authService.signIn(email, password);
    } catch (e) {
      log('AuthCubit-signIn-catch: ${e.toString()}');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> createUser(
      String email, String password, String username) async {
    emit(AuthLoading());
    try {
      await userService.createUser(email, password, username);
    } catch (e) {
      log('AuthCubit-createUser-catch: ${e.toString()}');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await authService.signOut();
    } catch (e) {
      log('AuthCubit-signout-catch: ${e.toString()}');
    }
  }
}
