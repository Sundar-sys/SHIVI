import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'core/theme/app_theme.dart';
import 'screens/home/home_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.shivi.app.audio',
    androidNotificationChannelName: 'Shivi Audio Playback',
    androidNotificationOngoing: true,
  );

  runApp(const ProviderScope(child: ShiviApp()));
}

class ShiviApp extends StatelessWidget {
  const ShiviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shivi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeShell(),
    );
  }
}
