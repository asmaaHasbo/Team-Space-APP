import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/error/handle_errors.dart';
import '../models/chat_list_item_model.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<ChatListItemModel>> getMyChats({required String spaceId});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient _client;

  ChatRemoteDataSourceImpl(this._client);

  @override
  Future<List<ChatListItemModel>> getMyChats({required String spaceId}) async {
    try {
      // The RPC does the heavy lifting: membership filter, last message,
      // unread count and the direct-chat display name — all in one query.
      final rows = await _client.rpc(
        'get_my_chats',
        params: {'p_space_id': spaceId},
      ) as List;

      return rows
          .map((json) => ChatListItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return handleError(e);
    }
  }
}