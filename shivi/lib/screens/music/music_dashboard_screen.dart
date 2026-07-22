import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/music_provider.dart';
import '../../data/models/track.dart';
import '../../core/constants/app_colors.dart';

class MusicDashboardScreen extends ConsumerWidget {
  const MusicDashboardScreen({super.key});

  // Replace with real data source (asset manifest, JSON, or remote API)
  List<Track> _tracksFor(TrackCategory category) => [];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicState = ref.watch(musicProvider);
    final notifier = ref.read(musicProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.softCream,
      appBar: AppBar(
        title: const Text('Relax with Shivi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: TrackCategory.values.map((cat) {
                final isSelected = musicState.selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat.label),
                    selected: isSelected,
                    selectedColor: AppColors.softPurple,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textDark,
                    ),
                    backgroundColor: Colors.white,
                    onSelected: (_) => notifier.selectCategory(cat),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _tracksFor(musicState.selectedCategory).length,
              itemBuilder: (context, index) {
                final track = _tracksFor(musicState.selectedCategory)[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(track.artworkPath,
                          width: 50, height: 50, fit: BoxFit.cover),
                    ),
                    title: Text(track.title,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(track.artist),
                    trailing: IconButton(
                      icon: Icon(
                        musicState.currentTrack?.id == track.id &&
                                musicState.isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_filled,
                        color: AppColors.softPurpleDark,
                        size: 36,
                      ),
                      onPressed: () {
                        if (musicState.currentTrack?.id == track.id) {
                          notifier.togglePlayPause();
                        } else {
                          notifier.playTrack(track);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          if (musicState.currentTrack != null)
            _buildMiniPlayer(musicState, notifier),
        ],
      ),
    );
  }

  Widget _buildMiniPlayer(MusicState state, MusicNotifier notifier) {
    final total =
        state.duration.inMilliseconds == 0 ? 1 : state.duration.inMilliseconds;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, -2))
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Slider(
            value: state.position.inMilliseconds.clamp(0, total).toDouble(),
            max: total.toDouble(),
            activeColor: AppColors.softPurpleDark,
            onChanged: (value) =>
                notifier.seek(Duration(milliseconds: value.toInt())),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(state.currentTrack!.title,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              IconButton(
                icon: Icon(state.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: notifier.togglePlayPause,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
