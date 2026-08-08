import 'package:equatable/equatable.dart';
import 'package:team_space/features/chat/domain/entities/chat.dart';

class ChatListItem extends Equatable {
  final Chat chat;
  final String displayName;
  final String? avatarUrl;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;

  const ChatListItem({
    required this.chat,
    required this.displayName,
    this.avatarUrl,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [
        chat,
        displayName,
        avatarUrl,
        lastMessage,
        lastMessageAt,
        unreadCount,
      ];
}