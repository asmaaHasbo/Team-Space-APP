import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_space/core/di/get_it.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    publishableKey: dotenv.env['SUPABASE_KEY']!,
  );
  await setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: PingPage());
  }
}

class PingPage extends StatefulWidget {
  const PingPage({super.key});

  @override
  State<PingPage> createState() => _PingPageState();
}

class _PingPageState extends State<PingPage> {
  String _result = 'اضغط الزرار';

  Future<void> _ping() async {
    setState(() => _result = 'جاري الاتصال...');
    try {
      await Supabase.instance.client.from('__ping__').select();
      setState(() => _result = 'رد بنجاح — بس ده غريب!');
    } on PostgrestException catch (e) {
      setState(
        () => _result = 'PostgrestException\ncode: ${e.code}\n${e.message}',
      );
    } catch (e) {
      setState(() => _result = '${e.runtimeType}\n$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(_result, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton(onPressed: _ping, child: const Text('Ping Supabase')),
          ],
        ),
      ),
    );
  }
}
