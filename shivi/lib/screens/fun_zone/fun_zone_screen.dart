import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/fun_zone_provider.dart';
import '../../core/constants/app_colors.dart';
import 'quiz_session_screen.dart';

class FunZoneScreen extends ConsumerWidget {
  const FunZoneScreen({super.key});

  static const _games = [
    (
      GameType.truthOrTongueTwister,
      'Truth or Tongue Twister',
      Icons.record_voice_over
    ),
    (GameType.bilingualTrivia, 'Bilingual Trivia', Icons.quiz),
    (GameType.rapidFireMood, 'Rapid-Fire Mood Boosters', Icons.bolt),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.softCream,
      appBar: AppBar(
        title: const Text('Fun & Banter Zone'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.95,
        ),
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final (type, label, icon) = _games[index];
          return GestureDetector(
            onTap: () {
              ref.read(funZoneProvider.notifier).startGame(type);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuizSessionScreen()),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.softPurple.withValues(alpha: 0.85),
                    AppColors.softBlue.withValues(alpha: 0.85)
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
