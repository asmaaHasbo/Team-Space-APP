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
  /// What the list shows right now — already filtered by [query].
  /// Empty only when a search matched nothing; every space keeps its default chat.
  final List<ChatListItem> chats;
  final String query;

  const ChatsLoaded(this.chats, {this.query = ''});

  @override
  List<Object?> get props => [chats, query];
}

final class ChatsError extends ChatsState {
  final String message;
  const ChatsError(this.message);
  @override
  List<Object?> get props => [message];
}
