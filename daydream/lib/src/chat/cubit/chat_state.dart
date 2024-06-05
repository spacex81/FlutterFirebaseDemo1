part of 'chat_cubit.dart';

sealed class ChatState {}

final class ChatInitial extends ChatState {}

final class ChatLoading extends ChatState {}

final class ChatLoaded extends ChatState {
  ConversationModel conversation;

  ChatLoaded(this.conversation);
}

final class ChatError extends ChatState {
  String message;
  ChatError(this.message);
}
