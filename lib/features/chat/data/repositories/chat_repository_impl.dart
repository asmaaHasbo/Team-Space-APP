import 'package:team_space/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;
  ChatRepositoryImpl(this._remoteDataSource);
  @override
  Future<List<ChatListItem>> getMyChats(String spaceId) {
    return _remoteDataSource.getMyChats(spaceId: spaceId);
  }

  @override
  Future<List<Message>> getMessages(String chatId) {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  Future<Message> sendMessage({
    required String messageId,
    required String chatId,
    required String content,
  }) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Stream<Message> watchMessages(String chatId) {
    // TODO: implement watchMessages
    throw UnimplementedError();
  }
}
