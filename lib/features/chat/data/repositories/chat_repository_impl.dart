import 'package:team_space/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/entities/space_member.dart';
import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  ChatRepositoryImpl(this._remoteDataSource);
  @override
  Future<List<ChatListItem>> getMyChats({required String spaceId}) {
    return _remoteDataSource.getMyChats(spaceId: spaceId);
  }

  @override
  Future<List<Message>> getMessages({
    required String chatId,
    int limit = 30,
    DateTime? beforeSentAt,
    String? beforeId,
  }) {
    return _remoteDataSource.getMessages(
      chatId: chatId,
      limit: limit,
      beforeSentAt: beforeSentAt,
      beforeId: beforeId,
    );
  }

  @override
  Future<Message> sendMessage({
    required String messageId,
    required String chatId,
    required String content,
  }) {
    return _remoteDataSource.sendMessage(
      messageId: messageId,
      chatId: chatId,
      content: content,
    );
  }

  @override
  Stream<Message> watchMessages({required String chatId}) {
    return _remoteDataSource.watchMessages(chatId: chatId);
  }

  @override
  Future<String> getOrCreateDirectChat({
    required String spaceId,
    required String otherUserId,
  }) {
    return _remoteDataSource.getOrCreateDirectChat(
      spaceId: spaceId,
      otherUserId: otherUserId,
    );
  }

  @override
  Future<List<SpaceMember>> getSpaceMembers({required String spaceId}) {
    return _remoteDataSource.getSpaceMembers(spaceId: spaceId);
  }

  @override
  Future<void> markChatAsRead({required String chatId}) {
    return _remoteDataSource.markChatAsRead(chatId: chatId);
  }
}
