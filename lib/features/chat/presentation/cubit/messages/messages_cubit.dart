import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_space/core/error/handle_errors.dart';
import 'package:team_space/core/shared/cubit/safe_cubit.dart';
import 'package:team_space/features/chat/domain/entities/message.dart';
import 'package:team_space/features/chat/domain/usecases/get_messages.dart';
import 'package:team_space/features/chat/domain/usecases/mark_chat_as_read.dart';
import 'package:team_space/features/chat/domain/usecases/send_message.dart';
import 'package:team_space/features/chat/domain/usecases/watch_message.dart';
import 'package:uuid/uuid.dart';

part 'messages_state.dart';

class MessagesCubit extends SafeCubit<MessagesState> {
  final String _chatId;
  final GetMessages _getMessages;
  final SendMessage _sendMessage;
  final WatchMessages _watchMessages;
  final MarkChatAsRead _markChatAsRead;
  MessagesCubit({
    required String chatId,
    required GetMessages getMessages,
    required SendMessage sendMessage,
    required WatchMessages watchMessages,
    required MarkChatAsRead markChatAsRead,
  }) : _chatId = chatId,
       _sendMessage = sendMessage,
       _getMessages = getMessages,
       _watchMessages = watchMessages,
       _markChatAsRead = markChatAsRead,
       super(const MessagesInitial());

  StreamSubscription<Message>? _messagesSubscription;

  //============================== load messages =======================================
  Future<void> loadMessages() async {
    emit(const MessagesLoading());
    try {
      final messages = await _getMessages(chatId: _chatId);
      emit(MessagesLoaded(messages: messages.reversed.toList()));
    } on AppException catch (e) {
      debugPrint('loadMessages error: ${e.message}');
      emit(MessagesError(e.message));
    }
  }

  //============================== load more messages ===================================
  Future<void> loadMoreMessages() async {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;

    try {
      final oldestMessage = currentState
          .messages
          .first; // اللي هي أقدم رسالة عندنا دلوقتي اللي فوق من الشاشه

      if (currentState.hasReachedEnd) return;
      // emit state جديد بيقول إننا بنحمل رسائل أكتر
      emit(currentState.copyWith(isLoadingMore: true));
      final messages = await _getMessages(
        chatId: _chatId,
        beforeId: oldestMessage.id,
        beforeSentAt: oldestMessage.sentAt,
      );
      emit(
        MessagesLoaded(
          messages: [...messages.reversed, ...currentState.messages],

          // لو عدد الرسائل اللي رجعت أقل من 30 يبقى وصلنا لنهاية الرسائل
          hasReachedEnd: messages.length < GetMessages.pageSize,
          isLoadingMore: false,
        ),
      );
    } on AppException catch (e) {
      debugPrint('loadMoreMessages error: ${e.message}');
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }

  //============================== send message =========================================
  Future<void> sendMessage({required String messageContent}) async {
    final currentState = state;
    if (currentState is! MessagesLoaded) return;
    final messageId = const Uuid().v4();
    final optimisticMessage = Message(
      id: messageId,
      chatId: _chatId,
      senderId: Supabase.instance.client.auth.currentUser?.id,
      content: messageContent,
      sentAt: DateTime.now(),
      status: MessageStatus.pending,
    );

    emit(
      currentState.copyWith(
        messages: [...currentState.messages, optimisticMessage],
      ),
    );
    try {
      final message = await _sendMessage(
        chatId: _chatId,
        messageId: messageId,
        content: messageContent,
      );
      //في الـ ٣ ثواني دول ممكن يكون حصل emit تاني غيّر الـ state — رسالة تانية اتبعتت، أو صفحة قديمة اتحمّلت، أو حصل error. فالصورة اللي في إيدك بقت قديمة.
      final latestState = state;
      if (latestState is! MessagesLoaded) return;

      final updatedMessages = <Message>[];

      for (final m in latestState.messages) {
        if (m.id == messageId) {
          updatedMessages.add(message);
        } else {
          updatedMessages.add(m);
        }
      }
      emit(latestState.copyWith(messages: updatedMessages));
    } on AppException catch (e) {
      debugPrint('sendMessage error: ${e.message}');
      final latestState = state;
      if (latestState is! MessagesLoaded) return;

      final updatedMessages = <Message>[];

      for (final m in latestState.messages) {
        if (m.id != messageId) {
          updatedMessages.add(m);
        }
      }
      emit(latestState.copyWith(messages: updatedMessages));
    }
  }

  //============================== watch messages ========================================
  void subscribeToNewMessages() {
    _messagesSubscription = _watchMessages(_chatId).listen(
      (message) {
        final latestState = state;
        if (latestState is! MessagesLoaded) return;
        //عشان الرسايل اللي ف الجدول هتسمع عند كل الناس حتي انا لاني عاملهه استماع
        // بس انا دلوقتي اللي باعته الرساله المفروض مش تظهر عندي
        // لو الرساله اللي وصلت من السيرفر هي نفس الرساله اللي انا باعته دلوقتي مش تضيفها عشان انا اصلا شايفها
        final exists = latestState.messages.any((m) => m.id == message.id);
        if (exists) return;

        emit(
          latestState.copyWith(messages: [...latestState.messages, message]),
        );

          // الرسالة ظهرت على الشاشة فعلاً، يبقى هي مقروءة — من غير السطر ده
        // الإشعار هيرن على حاجة اليوزر قاعد بيقراها.
        markAsRead(); 
      },
      onError: (Object error) {
        // الرسايل اللي على الشاشة سليمة فمابنمسحش حاجة
        debugPrint('watchMessages stream error: $error');
      },
    );
  }

  //============================== mark as read ========================================
  Future<void> markAsRead() async {
    try {
      await _markChatAsRead(chatId: _chatId); // الاسم عندك ممكن يكون مختلف
    } catch (e) {
      debugPrint('markChatAsRead failed: $e');
    }
  }

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    return super.close();
  }
}
