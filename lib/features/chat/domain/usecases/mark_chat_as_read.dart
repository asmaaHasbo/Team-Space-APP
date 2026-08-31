import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';

class MarkChatAsRead {
  final ChatRepository repository;

  MarkChatAsRead({required this.repository});
  Future<void> call({required String chatId}) {
    return repository.markChatAsRead(chatId: chatId);
  }
}
