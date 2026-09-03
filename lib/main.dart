import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/language/app_locales.dart';
import 'package:team_space/core/notifications/active_chat.dart';
import 'package:team_space/core/notifications/local_notifications_service.dart';
import 'package:team_space/core/notifications/notifications_service.dart';
import 'package:team_space/core/notifications/pending_chat_open.dart';
import 'package:team_space/team_space_app.dart';

/// The navigator key is used to navigate to the chat screen when a notification is tapped.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_KEY']!,
  );
  await setupGetIt();
  getIt<NotificationsService>().listenToTokenRefresh();
  await getIt<LocalNotificationsService>().init();
  FirebaseMessaging.onMessage.listen((message) {
    final notification = message.notification;
    if (notification == null) return;

    final chatId = message.data['chat_id'];
    if (chatId != null && getIt<ActiveChat>().isOpen(chatId)) return;

    getIt<LocalNotificationsService>().show(
      title: notification.title ?? '',
      body: notification.body ?? '',
    );
  });
  // (٢) التطبيق مصغّر والمستخدم دس على الاشعار
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    final chatId = message.data['chat_id'];
    if (chatId != null) getIt<PendingChatOpen>().set(chatId);
  });

  // (٣) التطبيق كان مقفول والضغطة هي اللي فتحته
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  final initialChatId = initialMessage?.data['chat_id'];
  if (initialChatId != null) getIt<PendingChatOpen>().set(initialChatId);
  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.fallback,
      child: const TeamSpaceApp(),
    ),
  );
}
