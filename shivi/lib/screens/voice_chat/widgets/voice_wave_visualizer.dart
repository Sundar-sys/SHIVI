import 'dart:math';
import 'package:flutter/material.dart';
import '../../../providers/voice_provider.dart';
import '../../../core/constants/app_colors.dart';

class VoiceWaveVisualizer extends StatefulWidget {
  final ShiviState state;
  const VoiceWaveVisualizer({super.key, required this.state});

  @override
  State<VoiceWaveVisualizer> createState() => _VoiceWaveVisualizerState();
}

class _VoiceWaveVisualizerState extends State<VoiceWaveVisualizer>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  bool get _isActive =>
      widget.state == ShiviState.listening ||
      widget.state == ShiviState.speaking;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _waveController]),
        builder: (context, child) {
          return CustomPaint(
            painter: _WavePainter(
              pulseValue: _pulseController.value,
              waveValue: _waveController.value,
              state: widget.state,
              isActive: _isActive,
            ),
            child: Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: widget.state == ShiviState.thinking
                        ? [AppColors.softBlue, AppColors.softPurple]
                        : [AppColors.softPurple, AppColors.accentPink],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.softPurple.withValues(alpha: 0.3),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: widget.state == ShiviState.thinking
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Icon(
                        widget.state == ShiviState.speaking
                            ? Icons.graphic_eq
                            : Icons.favorite,
                        color: Colors.white,
                        size: 32,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double pulseValue;
  final double waveValue;
  final ShiviState state;
  final bool isActive;

  _WavePainter({
    required this.pulseValue,
    required this.waveValue,
    required this.state,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final baseRadius = size.width / 2 * 0.55;

    // Concentric pulsing rings — active only while listening/speaking
    if (isActive) {
      for (int i = 0; i < 3; i++) {
        final progress = (waveValue + i / 3) % 1.0;
        final radius = baseRadius + (size.width / 2 - baseRadius) * progress;
        final opacity = (1.0 - progress).clamp(0.0, 1.0) * 0.35;

        final paint = Paint()
          ..color = AppColors.softPurple.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;

        canvas.drawCircle(center, radius, paint);
      }
    }

    // Breathing base ring — always present, calmer when idle
    final breathScale = isActive ? pulseValue : (pulseValue * 0.3);
    final breathRadius = baseRadius + (10 * breathScale);
    final breathPaint = Paint()
      ..color = AppColors.softBlue.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, breathRadius, breathPaint);

    // Small orbiting dots while speaking, to suggest audio output
    if (state == ShiviState.speaking) {
      for (int i = 0; i < 5; i++) {
        final angle = (waveValue * 2 * pi) + (i * 2 * pi / 5);
        final dotRadius = baseRadius + 26;
        final dotCenter = Offset(
          center.dx + dotRadius * cos(angle),
          center.dy + dotRadius * sin(angle),
        );
        final dotSize = 3.0 + sin(waveValue * 2 * pi + i) * 1.5;
        canvas.drawCircle(
          dotCenter,
          dotSize.abs(),
          Paint()..color = AppColors.accentPink,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) => true;
}
