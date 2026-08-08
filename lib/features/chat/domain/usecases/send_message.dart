import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<Message> call({
    required String messageId,
    required String chatId,
    required String content,
  }) {
    return repository.sendMessage(
      messageId: messageId,
      chatId: chatId,
      content: content,
    );
  }
}