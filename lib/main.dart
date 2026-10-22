import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_space/core/di/get_it.dart';
import 'package:team_space/core/language/app_locales.dart';
import 'package:team_space/core/notifications/notifications_bootstrap.dart';
import 'package:team_space/core/shared/widgets/startup_error_app.dart';
import 'package:team_space/team_space_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Only what the widget tree cannot be built without belongs in here.
  try {
    await Firebase.initializeApp();
    await EasyLocalization.ensureInitialized();
    await dotenv.load(fileName: '.env');

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_KEY'];
    if (supabaseUrl == null || supabaseKey == null) {
      throw StateError('SUPABASE_URL / SUPABASE_KEY are missing from .env');
    }

    await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
    await setupGetIt();
  } catch (error, stackTrace) {
    // In release nothing prints, so an unhandled failure here would look
    // exactly like a splash screen that never goes away.
    runApp(StartupErrorApp(error: error, stackTrace: stackTrace));
    return;
  }

  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: AppLocales.path,
      fallbackLocale: AppLocales.fallback,
      child: const TeamSpaceApp(),
    ),
  );

  // Notifications are set up only once the app is on screen — see
  // `setupNotifications` for why they must not gate startup.
  WidgetsBinding.instance.addPostFrameCallback((_) => setupNotifications());
}
