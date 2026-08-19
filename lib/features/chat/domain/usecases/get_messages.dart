import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';
class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Future<List<Message>> call({
    required String chatId,
    int limit = 30,
    DateTime? beforeSentAt,
    String? beforeId,
  }) {
    return repository.getMessages(
      chatId: chatId,
      limit: limit,
      beforeSentAt: beforeSentAt,
      beforeId: beforeId,
    );
  }
}
