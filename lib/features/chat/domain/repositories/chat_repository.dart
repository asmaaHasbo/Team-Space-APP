import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';

abstract class ChatRepository {
  Future<List<ChatListItem>> getMyChats({required String spaceId});

  Future<List<Message>> getMessages({
    required String chatId,
    int limit = 30,
    DateTime? beforeSentAt,
    String? beforeId,
  });
  Stream<Message> watchMessages({required String chatId});

  Future<Message> sendMessage({
    required String messageId,
    required String chatId,
    required String content,
  });

  Future<String> getOrCreateDirectChat({
    required String spaceId,
    required String otherUserId,
  });

  Future<List<SpaceMember>> getSpaceMembers({required String spaceId});
}
