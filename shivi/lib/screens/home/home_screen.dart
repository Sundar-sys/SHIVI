import 'dart:async';
import 'dart:math';
import '../../core/widgets/animated_background.dart';
import '../../core/widgets/ai_orb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/quick_action_card.dart';
import '../../core/widgets/shivi_logo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String greeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff09090B),
      body: SafeArea(
        child: Stack(
          children: [
            const AnimatedBackground(),
            ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  greeting(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ).animate().fade().slideX(),
                const SizedBox(height: 12),
                const Text(
                  "SHIVI",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ).animate().fade(delay: 200.ms).slideY(),
                const SizedBox(height: 30),
                const Center(
                  child: ShiviLogo(),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    "How can I help today?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ).animate().fade(delay: 400.ms),
                const SizedBox(height: 35),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  childAspectRatio: .95,
                  children: [
                    QuickActionCard(
                      icon: Icons.mic_rounded,
                      title: "Voice",
                      subtitle: "Talk naturally",
                      onTap: () {},
                    ),
                    QuickActionCard(
                      icon: Icons.chat_rounded,
                      title: "Chat",
                      subtitle: "Ask anything",
                      onTap: () {},
                    ),
                    QuickActionCard(
                      icon: Icons.image_rounded,
                      title: "Images",
                      subtitle: "Generate art",
                      onTap: () {},
                    ),
                    QuickActionCard(
                      icon: Icons.music_note_rounded,
                      title: "Music",
                      subtitle: "Relax & focus",
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  "Recent Chats",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 15),
                chat("Flutter UI Design"),
                chat("Research Summary"),
                chat("Daily Planning"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget action(IconData icon, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.07),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 34),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ).animate().fade().scale();
  }

  Widget chat(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.06),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xff7C5CFF),
            child: Icon(Icons.auto_awesome, color: Colors.white),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white38,
            size: 18,
          ),
        ],
      ),
    );
  }
}
