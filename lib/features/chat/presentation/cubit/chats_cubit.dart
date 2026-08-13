import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_space/core/error/handle_errors.dart';
import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/domain/usecases/get_my_chats.dart';
import 'package:team_space/features/chat/presentation/cubit/chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit({required GetMyChats getMyChats})
    : _getMyChats = getMyChats,
      super(const ChatsInitial());

  final GetMyChats _getMyChats;

  
  Future<void> loadMyChats(String spaceId) async {
    emit(const ChatsLoading());
    try {
      final List<ChatListItem> chats = await _getMyChats(spaceId);
      emit(ChatsLoaded(chats));
    } on AppException catch (e) {
      emit(ChatsError(e.message));
    }
  }
}
