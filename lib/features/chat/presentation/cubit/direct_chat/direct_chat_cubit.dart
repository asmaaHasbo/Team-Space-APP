import 'package:equatable/equatable.dart';
import 'package:team_space/core/error/handle_errors.dart';
import 'package:team_space/core/shared/cubit/safe_cubit.dart';
import 'package:team_space/features/chat/domain/usecases/get_or_create_direct_chat.dart';

part 'direct_chat_state.dart';

class DirectChatCubit extends SafeCubit<DirectChatState> {
  final GetOrCreateDirectChat _getOrCreateDirectChat;

  DirectChatCubit({required GetOrCreateDirectChat getOrCreateDirectChat})
    : _getOrCreateDirectChat = getOrCreateDirectChat,
      super(const DirectChatInitial());

  Future<void> getOrCreateDirectChat({
    required String otherUserId,
    required String spaceId,
  }) async {
    if (state is DirectChatLoading) return;
    emit(DirectChatLoading());
    try {
      final chatId = await _getOrCreateDirectChat(
        otherUserId: otherUserId,
        spaceId: spaceId,
      );
      emit(DirectChatOpened(chatId));
    } on AppException catch (e) {
      emit(DirectChatError(e.message));
    }
  }
}
