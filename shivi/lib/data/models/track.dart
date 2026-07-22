enum TrackCategory { calmingBeats, ambientSounds, focusMusic, natureSounds }

class Track {
  final String id;
  final String title;
  final String artist;
  final String assetPath; // or remote URL
  final String artworkPath;
  final Duration duration;
  final TrackCategory category;

  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.assetPath,
    required this.artworkPath,
    required this.duration,
    required this.category,
  });
}

extension TrackCategoryX on TrackCategory {
  String get label {
    switch (this) {
      case TrackCategory.calmingBeats:
        return 'Calming Beats';
      case TrackCategory.ambientSounds:
        return 'Ambient Sounds';
      case TrackCategory.focusMusic:
        return 'Focus Music';
      case TrackCategory.natureSounds:
        return 'Nature Sounds';
    }
  }
}
