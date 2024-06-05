import 'dart:developer';

import 'package:daydream/firebase_options.dart';
import 'package:daydream/src/auth/auth_screen.dart';
import 'package:daydream/src/auth/cubit/auth_cubit.dart';
import 'package:daydream/src/chat/cubit/chat_cubit.dart';
import 'package:daydream/src/home/cubit/friends_cubit.dart';
import 'package:daydream/src/home/home_screen.dart';
import 'package:daydream/src/services/auth_service.dart';
import 'package:daydream/src/services/chat_service.dart';
import 'package:daydream/src/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    UserService userService = UserService(authService);
    ChatService chatService = ChatService();

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FriendsCubit(authService, userService),
          ),
          BlocProvider(
            create: (context) => AuthCubit(authService, userService),
          ),
          BlocProvider(
            create: (context) => ChatCubit(chatService, authService),
          )
        ],
        child: MaterialApp(
          home: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              if (state is AuthLoaded) {
                return HomeScreen(user: state.user);
              } else if (state is AuthLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is AuthError) {
                return Center(
                  child: Text(state.message),
                );
              } else {
                return AuthScreen();
              }
            },
          ),
        ));
  }
}
