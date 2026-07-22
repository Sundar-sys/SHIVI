import 'package:flutter/material.dart';
import '../../widgets/shivi_bottom_nav.dart';
import '../voice_chat/voice_chat_screen.dart';
import '../music/music_dashboard_screen.dart';
import '../fun_zone/fun_zone_screen.dart';
// import '../profile/profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  // IndexedStack keeps each tab's state alive (music keeps playing,
  // voice chat history stays, etc.) when switching tabs.
  final List<Widget> _screens = const [
    VoiceChatScreen(),
    MusicDashboardScreen(),
    FunZoneScreen(),
    _ProfilePlaceholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: ShiviBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profile screen — coming soon')),
    );
  }
}
