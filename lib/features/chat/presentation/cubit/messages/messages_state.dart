part of 'messages_cubit.dart';

sealed class MessagesState extends Equatable {
  const MessagesState();
  @override
  List<Object?> get props => [];
}

final class MessagesInitial extends MessagesState {
  const MessagesInitial();
}

final class MessagesLoading extends MessagesState {
  const MessagesLoading();
}

final class MessagesLoaded extends MessagesState {
  final List<Message> messages;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  const MessagesLoaded({
    required this.messages,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
  });
  MessagesLoaded copyWith({
    List<Message>? messages,
    bool? isLoadingMore,
    bool? hasReachedEnd,
  }) {
    return MessagesLoaded(
      messages: messages ?? this.messages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [messages, isLoadingMore, hasReachedEnd];
}

final class MessagesError extends MessagesState {
  final String message;
  const MessagesError(this.message);
  @override
  List<Object?> get props => [message];
}
