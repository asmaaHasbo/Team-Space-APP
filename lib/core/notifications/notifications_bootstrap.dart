import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/notifications/active_chat.dart';
import 'package:team_space/core/notifications/local_notifications_service.dart';
import 'package:team_space/core/notifications/notifications_service.dart';
import 'package:team_space/core/notifications/pending_chat_open.dart';

/// Wires every messaging listener the app needs, after the first frame.
///
/// Nothing here may run before `runApp`: a failure or a hang in any of these
/// calls would leave the app sitting on the splash screen forever. Broken
/// notifications are recoverable, an app that never starts is not.
Future<void> setupNotifications() async {
  try {
    getIt<NotificationsService>().listenToTokenRefresh();
    await getIt<LocalNotificationsService>().init();

    // (١) التطبيق مفتوح قدام المستخدم
    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    // (٢) التطبيق مصغّر والمستخدم دس على الاشعار
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final chatId = message.data['chat_id'];
      if (chatId != null) getIt<PendingChatOpen>().set(chatId);
    });

    // (٣) التطبيق كان مقفول والضغطة هي اللي فتحته
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    final initialChatId = initialMessage?.data['chat_id'];
    if (initialChatId != null) getIt<PendingChatOpen>().set(initialChatId);
  } catch (error) {
    debugPrint('notifications setup failed: $error');
  }
}

/// The chat the user is already reading shows the message inline, so it must
/// not also raise a notification for it.
void _onForegroundMessage(RemoteMessage message) {
  final notification = message.notification;
  if (notification == null) return;

  final chatId = message.data['chat_id'];
  if (chatId != null && getIt<ActiveChat>().isOpen(chatId)) return;

  getIt<LocalNotificationsService>().show(
    title: notification.title ?? '',
    body: notification.body ?? '',
    payload: chatId,
  );
}
