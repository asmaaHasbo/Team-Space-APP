import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/domain/entities/message.dart';

abstract class ChatRepository {
  Future<List<ChatListItem>> getMyChats(String spaceId);

  Future<List<Message>> getMessages(String chatId);

  Stream<Message> watchMessages(String chatId);

  Future<Message> sendMessage({
    required String messageId,
    required String chatId,
    required String content,
  });
}