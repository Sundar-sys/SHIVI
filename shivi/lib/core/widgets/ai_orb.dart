import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AiOrb extends StatefulWidget {
  final double size;
  final VoidCallback? onTap;

  const AiOrb({
    super.key,
    this.size = 220,
    this.onTap,
  });

  @override
  State<AiOrb> createState() => _AiOrbState();
}

class _AiOrbState extends State<AiOrb> with TickerProviderStateMixin {
  late final AnimationController _rotate;
  late final AnimationController _pulse;
  late final AnimationController _float;

  @override
  void initState() {
    super.initState();

    _rotate = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _float = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotate.dispose();
    _pulse.dispose();
    _float.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _rotate,
        _pulse,
        _float,
      ]),
      builder: (_, __) {
        final scale = 1 + (_pulse.value * .08);

        final y = sin(_float.value * pi * 2) * 10;

        return Transform.translate(
          offset: Offset(0, y),
          child: Transform.scale(
            scale: scale,
            child: GestureDetector(
              onTap: widget.onTap,
              child: SizedBox(
                width: widget.size,
                height: widget.size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Glow
                    Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff7C5CFF).withOpacity(.35),
                            blurRadius: 90,
                            spreadRadius: 18,
                          ),
                          BoxShadow(
                            color: const Color(0xff00D4FF).withOpacity(.25),
                            blurRadius: 120,
                            spreadRadius: 30,
                          ),
                        ],
                      ),
                    ),

                    // Rotating energy ring
                    RotationTransition(
                      turns: _rotate,
                      child: CustomPaint(
                        size: Size(
                          widget.size,
                          widget.size,
                        ),
                        painter: _RingPainter(),
                      ),
                    ),

                    // Orbiting particles
                    RotationTransition(
                      turns: _rotate,
                      child: SizedBox(
                        width: widget.size,
                        height: widget.size,
                        child: Stack(
                          children: List.generate(
                            8,
                            (i) {
                              final angle = i * pi / 4;

                              return Positioned(
                                left: widget.size / 2 +
                                    cos(angle) * (widget.size * .42) -
                                    4,
                                top: widget.size / 2 +
                                    sin(angle) * (widget.size * .42) -
                                    4,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Main orb
                    Container(
                      width: widget.size * .70,
                      height: widget.size * .70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white,
                            Color(0xffC4B5FD),
                            Color(0xff8B5CF6),
                          ],
                        ),
                      ),
                    ),

                    // Glass reflection
                    ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 8,
                          sigmaY: 8,
                        ),
                        child: Container(
                          width: widget.size * .56,
                          height: widget.size * .56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.08),
                          ),
                        ),
                      ),
                    ),

                    // Core
                    Container(
                      width: widget.size * .12,
                      height: widget.size * .12,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..shader = const SweepGradient(
        colors: [
          Color(0xff00D4FF),
          Color(0xff7C5CFF),
          Color(0xff00D4FF),
        ],
      ).createShader(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: size.width / 2,
        ),
      );

    canvas.drawCircle(
      size.center(Offset.zero),
      size.width * .42,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
