import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';

class GetOrCreateDirectChat {
  final ChatRepository repository;

  GetOrCreateDirectChat(this.repository);

  Future<String> call({required String spaceId, required String otherUserId}) {
    return repository.getOrCreateDirectChat(
      spaceId: spaceId,
      otherUserId: otherUserId,
    );
  }
}
