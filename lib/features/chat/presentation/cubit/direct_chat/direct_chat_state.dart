
part of 'direct_chat_cubit.dart';


sealed class DirectChatState extends Equatable {
  const DirectChatState();
  @override
  List<Object?> get props => [];
}

class DirectChatInitial extends DirectChatState {
  const DirectChatInitial();
}

class DirectChatLoading extends DirectChatState {
  const DirectChatLoading();
}

class DirectChatOpened extends DirectChatState {
  const DirectChatOpened(this.chatId);
  final String chatId;
  @override
  List<Object?> get props => [chatId];
}

class DirectChatError extends DirectChatState {
  const DirectChatError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}