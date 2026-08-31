import 'package:team_space/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
 const MessageModel({
    required super.id,
    required super.chatId,
    super.senderId,
    required super.content,
    required super.sentAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      senderId: json['created_by'] as String?,
      content: json['message_content'] as String,
      sentAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }
}
