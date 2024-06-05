import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daydream/src/models/chat_model.dart';
import 'package:daydream/src/models/conversation_model.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  final _conversationsRef =
      FirebaseFirestore.instance.collection('conversations');
  final _uuid = Uuid();

  Stream<ConversationModel> conversationStream(String conversationId) {
    return _conversationsRef.doc(conversationId).snapshots().map((snapshot) {
      final Map<String, dynamic>? conversationData = snapshot.data();
      if (conversationData == null) {
        // throw Exception('Conversation data is null for id: $conversationId');
        return ConversationModel(chatList: []);
      }

      final conversation = ConversationModel.fromMap(conversationData);
      return conversation;
    });
  }

  void sendMessage(String conversationId, String message) async {
    final newChat = ChatModel(
      conversationId: conversationId,
      messageId: _uuid.v4(),
      message: message,
      sentAt: DateTime.now(),
    );

    final docRef = _conversationsRef.doc(conversationId);

    try {
      await docRef.update({
        'chatList': FieldValue.arrayUnion([newChat.toMap()])
      });
    } catch (e) {
      if (e is FirebaseException && e.code == 'not-found') {
        await docRef.set({
          'chatList': [newChat.toMap()]
        });
      } else {
        rethrow;
      }
    }
  }
}
