import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_space/features/chat/data/models/message_model.dart';

import '../../../../core/error/handle_errors.dart';
import '../models/chat_list_item_model.dart';

abstract interface class ChatRemoteDataSource {
  Future<List<ChatListItemModel>> getMyChats({required String spaceId});

  Future<List<MessageModel>> getMessages({
    required String chatId,
    int limit,
    DateTime? beforeSentAt,
    String? beforeId,
  });

  Future<MessageModel> sendMessage({
    required String messageId,
    required String chatId,
    required String content,
    
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient _supabase;

  ChatRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<ChatListItemModel>> getMyChats({required String spaceId}) async {
    try {
      // The RPC does the heavy lifting: membership filter, last message,
      // unread count and the direct-chat display name — all in one query.
      final rows =
          await _supabase.rpc('get_my_chats', params: {'p_space_id': spaceId})
              as List;

      return rows
          .map(
            (json) => ChatListItemModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return handleError(e);
    }
  }

  @override
  Future<List<MessageModel>> getMessages({
    required String chatId,
    int limit = 30,
    DateTime? beforeSentAt,
    String? beforeId,
  }) async {
    try {
      // بجيب كل الرسايل اللي في الشات ده، وبعمل فلتر على الرسائل المحذوفة
      var query = _supabase
          .from('messages')
          .select()
          .eq('chat_id', chatId)
          .isFilter('deleted_at', null);

      // لو فيه beforeSentAt و beforeId يبقى انا عايز اعمل pagination على الرسائل، يعني اجيب الرسائل اللي قبل الرسالة دي
      if (beforeSentAt != null && beforeId != null) {
        // بص االتاريخ بناخده  من ال CUPIT محلي  فلاز م احوله UTC عشان ال Supabase بيشتغل بال UTC و بعدين احوله ل ISO 8601 string عشان اقدر اعمله filter بيه
        final cursorTime = beforeSentAt.toUtc().toIso8601String();

        // بعمل فيلتر علي الرسايل اللي  جت بتاعت الشات  اللي هو عباره عن  created_at < cursorTime  او created_at = cursorTime و id < beforeId
        query = query.or(
          'created_at.lt.$cursorTime,'
          'and(created_at.eq.$cursorTime,id.lt.$beforeId)',
        );
      }

      // بعمل ترتيب للرسائل من الاحدث للاقدم و بعدين بجيب عدد معين من الرسائل
      final response = await query
          .order('created_at', ascending: false)
          .order('id', ascending: false)
          .limit(limit);

      return response.map((json) => MessageModel.fromJson(json)).toList();
    } catch (e) {
      return handleError(e);
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String messageId,
    required String chatId,
    required String content,
  }) async {
    try {
      final response = await _supabase
          .from('messages')
          .insert({
            'id': messageId,
            'chat_id': chatId,
            'message_content': content,
          })
          .select()
          .single();

      return MessageModel.fromJson(response);
    } catch (e) {
      return handleError(e);
    }
  }
}
