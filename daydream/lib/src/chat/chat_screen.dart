import 'package:daydream/src/chat/cubit/chat_cubit.dart';
import 'package:daydream/src/models/user_model.dart';
import 'package:daydream/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  UserModel my;
  UserModel friend;

  ChatScreen({required this.my, required this.friend, super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myUid = widget.my.uid;
    final friendUid = widget.friend.uid;
    final conversationId = generateConversationId(myUid, friendUid);
    // load the 'conversationStream' using this 'conversationId' from 'ChatCubit'
    context.read<ChatCubit>().loadConversation(conversationId);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friend.username),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoaded) {
                      return ListView.builder(
                        itemCount: state.conversation.chatList.length,
                        itemBuilder: (context, index) {
                          final chat = state.conversation.chatList[index];
                          return ListTile(
                            title: Text(chat.message),
                          );
                        },
                      );
                    } else if (state is ChatError) {
                      return Center(
                        child: Text(state.message),
                      );
                    } else if (state is ChatLoading) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Center(
                        child: Text('Unknown ChatCubit State'),
                      );
                    }
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                  )),
                  GestureDetector(
                    child: Icon(Icons.send),
                    onTap: () {
                      final message = _messageController.text;

                      context
                          .read<ChatCubit>()
                          .sendMessage(conversationId, message);

                      _messageController.text = '';
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
