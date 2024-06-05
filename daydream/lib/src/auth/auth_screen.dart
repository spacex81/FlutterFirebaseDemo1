import 'package:daydream/src/auth/cubit/auth_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  bool _isLogin = true;

  void _toggleIsLoggin() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth'),
      ),
      body: Column(
        children: [
          TextField(
            decoration: InputDecoration(hintText: 'Email'),
            controller: _emailController,
          ),
          TextField(
            decoration: InputDecoration(hintText: 'Password'),
            controller: _passwordController,
          ),
          SizedBox(
            height: 45,
            child: _isLogin
                ? Container()
                : TextField(
                    decoration: InputDecoration(hintText: 'Username'),
                    controller: _usernameController,
                  ),
          ),
          FloatingActionButton(
            onPressed: () {
              final email = _emailController.text;
              final password = _passwordController.text;
              final username = _usernameController.text;

              _isLogin
                  ? context.read<AuthCubit>().signIn(email, password)
                  : context
                      .read<AuthCubit>()
                      .createUser(email, password, username);
            },
            child: Text(_isLogin ? 'Login' : 'Sign Up'),
          ),
          TextButton(
              onPressed: () {
                _toggleIsLoggin();
              },
              child: Text(_isLogin
                  ? 'Not a member? Sign up'
                  : 'Already a member? Sign In'))
        ],
      ),
    );
  }
}
