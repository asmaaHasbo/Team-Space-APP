import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_space/features/chat/data/models/message_model.dart';
import 'package:team_space/features/chat/data/models/space_member_model.dart';

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

  Stream<MessageModel> watchMessages({required String chatId});

  Future<String> getOrCreateDirectChat({
    required String spaceId,
    required String otherUserId,
  });

  Future<List<SpaceMemberModel>> getSpaceMembers({required String spaceId});

  Future<void> markChatAsRead({required String chatId});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient _supabase;

  ChatRemoteDataSourceImpl(this._supabase);

  //================================= get my chats =========================================
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

  //============================== get messages ============================================
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

  //============================== send message ===========================================
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

  //============================== watch messages ==========================================
  /*
watchMessages في ٥ نقط:

صندوق — StreamController نحط فيه الرسايل الجاية
خط — channel مع السيرفر، مخصوص للشات ده
شرط — بلّغني بس لما تتضاف رسالة (insert) في الشات ده (filter)
الجرس — لما يبلّغنا: حوّل الصف لـ MessageModel وحطه في الصندوق (add)
القفل — لما المستخدم يخرج، اقفل الخط والصندوق (onCancel)
*/
  //بتفتح خط مباشر بين السيرفر والشاشة، عشان أي رسالة جديدة تظهر فورًا من غير ما نطلبها.
  @override
  Stream<MessageModel> watchMessages({required String chatId}) {
    //صندوق فاضي. أي حاجة تتحط فيه، اللي مستني بره بياخدها فورًا
    final controller = StreamController<MessageModel>();

    //بنشترك في قناة معينة على السيرفر، القناة دي مخصوصة للشات ده
    //خط مخصوص للشات ده لوحده. الاسم فيه الـ chatId عشان كل شات يبقى له خطه.
    final channel = _supabase.channel('messages:$chatId');

    channel
        .onPostgresChanges(
          //٣. بنقول للسيرفر: بلّغني بإيه بالظبط
          event: PostgresChangeEvent.insert, // أي رسالة جديدة تتحط في الجدول ده
          schema: 'public',
          table: 'messages',
          //٤. بنعمل فلتر على الرسائل اللي جايه، عشان بس اللي ليها chatId ده
          //يعني: "مش عايز أعرف كل حاجة، عايز أعرف بس لما تتكتب رسالة جديدة في الشات ده."
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_id',
            value: chatId,
          ),
          //٤. بنقوله: ولما تبلغني، اعمل كده
          callback: (payload) {
            //السيرفر بيبعتلنا الصف الجديد خام (payload.newRecord)
            //بنحوله لنموذج رسالة (MessageModel) عشان نقدر نتعامل معاه بسهولة
            final message = MessageModel.fromJson(payload.newRecord);
            //٥. وبعدين نحطه في الصندوق (controller) عشان أي حد مستني بره ياخده فورًا
            controller.add(message);
          },
        )
        .subscribe(); //٢. بنشترك في القناة دي، عشان نسمع أي حاجة جديدة فيها

    controller.onCancel = () async {
      await _supabase.removeChannel(
        channel,
      ); //٦. لما حد يخلص من الاستماع، بنقفل القناة دي عشان ما نسمعش حاجة تاني
      await controller
          .close(); // ٧. وبنقفل الصندوق (controller) عشان ما نضيفش حاجة فيه تاني
    };
    //٨. وبنرجع الصندوق (controller.stream) عشان أي حد يقدر يستمع لأي رسالة جديدة تتحط فيه
    return controller.stream;
  }

  //============================== get or create direct chat ================================
  @override
  Future<String> getOrCreateDirectChat({
    required String spaceId,
    required String otherUserId,
  }) async {
    try {
      final response =
          await _supabase.rpc(
                'get_or_create_direct_chat',
                params: {'p_space_id': spaceId, 'p_other_user_id': otherUserId},
              )
              as String;

      return response;
    } catch (e) {
      return handleError(e);
    }
  }

  //======================== getSpaceMembers ==========================
  @override
  Future<List<SpaceMemberModel>> getSpaceMembers({
    required String spaceId,
  }) async {
    try {
      final response =
          await _supabase.rpc(
                'get_space_members',
                params: {'p_space_id': spaceId},
              )
              as List;

      return response
          .map(
            (json) => SpaceMemberModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      return handleError(e);
    }
  }

  //================================ markChatAsRead =================
  @override
  Future<void> markChatAsRead({required String chatId}) async {
    await _supabase.rpc('mark_chat_as_read', params: {'p_chat_id': chatId});
  }
}
