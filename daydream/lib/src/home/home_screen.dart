import 'package:daydream/src/auth/cubit/auth_cubit.dart';
import 'package:daydream/src/chat/chat_screen.dart';
import 'package:daydream/src/home/cubit/friends_cubit.dart';
import 'package:daydream/src/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  UserModel user;
  HomeScreen({required this.user, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        actions: [
          GestureDetector(
            child: Icon(Icons.add),
            onTap: () => _dialogBuilder(context),
          ),
          GestureDetector(
            child: Icon(Icons.logout),
            onTap: () => context.read<AuthCubit>().signOut(),
          ),
        ],
      ),
      body: Center(
        /// if we display 'user.friends' we cannot display the 'username'
        /// so we need to load the list of friends in cubit and display it here
        child: Column(
          children: [
            Text(
              'username: ${widget.user.username}',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              'pin: ${widget.user.pin}',
              style: TextStyle(fontSize: 30),
            ),
            Expanded(
              child: BlocBuilder<FriendsCubit, FriendsState>(
                builder: (context, state) {
                  if (state is FriendsLoaded) {
                    return ListView.builder(
                      itemCount: state.friends.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.friends[index].username),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  my: widget.user,
                                  friend: state.friends[index],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is FriendsLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is FriendsError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(
                      child: Text('Unknown FriendsCubit State'),
                    );
                  }
                },
              ),
              // child: ListView.builder(
              //   // itemCount: widget.user.friends.length,
              //   itemCount: 3,
              //   itemBuilder: (context, index) {
              //     return ListTile(
              //       // title: Text(widget.user.friends[index]),
              //       title: Text('S'),
              //     );
              //   },
              // ),
            )
          ],
        ),
      ),
    );
  }

  //
  Future<void> _dialogBuilder(BuildContext context) {
    TextEditingController _pinController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter friend's PIN"),
          content: TextField(
            controller: _pinController,
            decoration: InputDecoration(hintText: 'PIN'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  final friendPin = _pinController.text;
                  context.read<FriendsCubit>().addFriendByPin(friendPin);
                  Navigator.pop(context);
                },
                child: Text('ADD'))
          ],
        );
      },
    );
  }
}
