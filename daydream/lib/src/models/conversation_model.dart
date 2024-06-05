// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:daydream/src/models/chat_model.dart';

class ConversationModel {
  List<ChatModel> chatList;

  ConversationModel({
    required this.chatList,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'chatList': this.chatList.map((chat) => chat.toMap()).toList(),
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      chatList: List<ChatModel>.from(
        (map["chatList"] as List<dynamic>).map<ChatModel>(
          (chatMap) => ChatModel.fromMap(chatMap as Map<String, dynamic>),
        ),
      ),
    );
  }
}
