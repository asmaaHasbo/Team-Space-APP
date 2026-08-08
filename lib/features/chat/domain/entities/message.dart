import 'package:equatable/equatable.dart';

enum MessageStatus { pending, sent }

class Message extends Equatable {
  final String id;
  final String chatId;
  final String? senderId;
  final String content;
  final DateTime sentAt;
  final String? senderName;
  final String? senderAvatarUrl;
  final MessageStatus status;

  const Message({
    required this.id,
    required this.chatId,
    this.senderId,
    required this.content,
    required this.sentAt,
    this.senderName,
    this.senderAvatarUrl,
    this.status = MessageStatus.sent,
  });

  @override
  List<Object?> get props => [id, chatId, senderId, content, sentAt , senderName, senderAvatarUrl, status];
}
