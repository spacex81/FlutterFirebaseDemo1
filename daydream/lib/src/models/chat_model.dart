class ChatModel {
  String conversationId;
  String messageId;
  String message;
  DateTime sentAt;
  DateTime? receivedAt;
  DateTime? readAt;

  ChatModel({
    required this.conversationId,
    required this.messageId,
    required this.message,
    required this.sentAt,
    this.receivedAt,
    this.readAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'conversationId': this.conversationId,
      'messageId': this.messageId,
      'message': this.message,
      'sentAt': this.sentAt.toIso8601String(),
      'receivedAt': this.receivedAt?.toIso8601String() ?? null,
      'readAt': this.readAt?.toIso8601String() ?? null,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      conversationId: map['conversationId'] as String,
      messageId: map['messageId'] as String,
      message: map['message'] as String,
      sentAt: DateTime.parse(map['sentAt'] as String),
      receivedAt: map['receivedAt'] != null
          ? DateTime.parse(map['receivedAt'] as String)
          : null,
      readAt: map['readAt'] != null
          ? DateTime.parse(map['readAt'] as String)
          : null,
    );
  }
}
