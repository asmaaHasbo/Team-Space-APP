import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';
class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  /// Shared with the cubit so "a short page means we hit the end" stays true.
  static const int pageSize = 30;

  Future<List<Message>> call({
    required String chatId,
    int limit = pageSize,
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
