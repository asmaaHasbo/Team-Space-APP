import 'package:flutter/foundation.dart';
import 'package:team_space/core/error/handle_errors.dart';
import 'package:team_space/core/shared/cubit/safe_cubit.dart';
import 'package:team_space/features/chat/domain/entities/chat_list_item.dart';
import 'package:team_space/features/chat/domain/usecases/get_my_chats.dart';
import 'package:team_space/features/chat/domain/usecases/mark_chat_as_read.dart';
import 'package:team_space/features/chat/presentation/cubit/chats_state.dart';

class ChatsCubit extends SafeCubit<ChatsState> {
  final MarkChatAsRead _markChatAsRead;

  ChatsCubit({
    required GetMyChats getMyChats,
    required MarkChatAsRead markChatAsRead,
  }) : _markChatAsRead = markChatAsRead,
       _getMyChats = getMyChats,
       super(const ChatsInitial());

  final GetMyChats _getMyChats;

  // the durable list — search filters a copy of it, never the source
  List<ChatListItem> _chats = [];
  String _query = '';
  String? _spaceId;

  /// First load for a space, and the reload after the user switches space.
  Future<void> loadMyChats(String spaceId) async {
    _spaceId = spaceId;
    _query = '';
    emit(const ChatsLoading());
    await _fetch();
  }

  /// Pull to refresh — no loading state, the indicator is enough.
  Future<void> refresh() => _fetch();

  void search(String query) {
    _query = query;
    // a search typed while the list is still loading or failed has nothing to
    // filter yet — it gets applied by the next successful fetch.
    if (state is! ChatsLoaded) return;
    _emitList();
  }

  void clearSearch() => search('');

  Future<void> _fetch() async {
    final spaceId = _spaceId;
    if (spaceId == null) return;

    try {
      final result = await _getMyChats(spaceId);
      if (spaceId != _spaceId) return;
      _chats = result;
      _emitList();
    } on AppException catch (e) {
      if (spaceId != _spaceId) return;
      emit(ChatsError(e.message));
    }
  }

  void _emitList() {
    final query = _query.trim().toLowerCase();
    final visible = query.isEmpty
        ? _chats
        : _chats
              .where(
                (item) =>
                    (item.displayName ?? '').toLowerCase().contains(query),
              )
              .toList();

    emit(ChatsLoaded(visible, query: _query));
  }

  //========================markAsRead ===============
 Future<void> markAsRead(String chatId) async {
  try {
    await _markChatAsRead(chatId: chatId);
  } catch (e) {
    debugPrint('markChatAsRead failed: $e');
  }
}
}
