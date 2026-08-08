import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/repositories/chat_repository.dart';

class GetMessages {
  final ChatRepository repository;

  GetMessages(this.repository);

  Future<List<Message>> call(String chatId) async {
    return await repository.getMessages(chatId);
  }
}
