import '../../domain/entities/chat_list_item.dart';
import 'chat_model.dart';

class ChatListItemModel extends ChatListItem {
  const ChatListItemModel({
    required super.chat,
    super.displayName,
    super.avatarUrl,
    super.lastMessage,
    super.lastMessageAt,
    super.unreadCount = 0,
  });

  factory ChatListItemModel.fromJson(Map<String, dynamic> json) {
    return ChatListItemModel(
      chat: ChatModel.fromJson(json),
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] == null
          ? null
          : DateTime.parse(json['last_message_at'] as String).toLocal(),
      unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
    );
  }
}