import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';

class WatchMessages {
  final ChatRepository repository;

  WatchMessages(this.repository);

  Stream<Message> call(String chatId) {
    return repository.watchMessages(chatId: chatId);
  }
}
