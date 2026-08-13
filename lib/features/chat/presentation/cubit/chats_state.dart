import 'package:equatable/equatable.dart';
import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';

sealed class ChatsState extends Equatable {
  const ChatsState();
  @override
  List<Object?> get props => [];
}

final class ChatsInitial extends ChatsState {
  const ChatsInitial();
}

final class ChatsLoading extends ChatsState {
  const ChatsLoading();
}

final class ChatsLoaded extends ChatsState {
  final List<ChatListItem> chats;
  const ChatsLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

final class ChatsError extends ChatsState {
  final String message;
  const ChatsError(this.message);
  @override
  List<Object?> get props => [message];
}
