import 'package:flutter/material.dart';

/// Shown when startup fails before the real app can be built.
///
/// It deliberately depends on nothing but Flutter itself — ScreenUtil, the
/// theme and the localizations are exactly what may have failed to load — so
/// the failure surfaces as readable text instead of a frozen splash screen.
class StartupErrorApp extends StatelessWidget {
  final Object error;
  final StackTrace stackTrace;

  const StartupErrorApp({
    super.key,
    required this.error,
    required this.stackTrace,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Startup failed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      '$error\n\n$stackTrace',
                      style: const TextStyle(fontSize: 12, height: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
