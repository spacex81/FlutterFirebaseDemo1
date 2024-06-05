import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:daydream/src/models/chat_model.dart';
import 'package:daydream/src/models/conversation_model.dart';
import 'package:daydream/src/services/auth_service.dart';
import 'package:daydream/src/services/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatService chatService;
  AuthService authService;
  StreamSubscription<ConversationModel>? _conversationStreamSubscription;

  ChatCubit(this.chatService, this.authService) : super(ChatInitial()) {
    authService.authStateStream.listen((User? user) {
      if (user == null) {
        _conversationStreamSubscription?.cancel();
      }
    });
  }

  void loadConversation(String conversationId) {
    _conversationStreamSubscription = chatService
        .conversationStream(conversationId)
        .listen((ConversationModel? conversation) {
      if (conversation != null) {
        emit(ChatLoaded(conversation));
      }
    });
  }

  void sendMessage(String conversationId, String message) {
    chatService.sendMessage(conversationId, message);
  }

  @override
  Future<void> close() {
    _conversationStreamSubscription?.cancel();
    return super.close();
  }
}
