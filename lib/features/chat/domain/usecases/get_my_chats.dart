import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';

class GetMyChats {
  final ChatRepository repository;

  GetMyChats(this.repository);

  Future<List<ChatListItem>> call(String spaceId) {
    return repository.getMyChats(spaceId: spaceId);
  }
}