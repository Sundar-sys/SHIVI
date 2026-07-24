import 'dart:math';
import 'package:flutter/material.dart';

class ShiviLogo extends StatefulWidget {
  const ShiviLogo({super.key});

  @override
  State<ShiviLogo> createState() => _ShiviLogoState();
}

class _ShiviLogoState extends State<ShiviLogo> with TickerProviderStateMixin {
  late AnimationController rotateController;
  late AnimationController pulseController;

  @override
  void initState() {
    super.initState();

    rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    rotateController.dispose();
    pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        rotateController,
        pulseController,
      ]),
      builder: (_, __) {
        final scale = 1 + pulseController.value * .05;

        return Transform.scale(
          scale: scale,
          child: SizedBox(
            width: 420,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                RotationTransition(
                  turns: rotateController,
                  child: Container(
                    width: 360,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(.2),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                RotationTransition(
                  turns: Tween(
                    begin: 1.0,
                    end: 0.0,
                  ).animate(rotateController),
                  child: Container(
                    width: 300,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      border: Border.all(
                        color: Colors.pink.withOpacity(.15),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                ShaderMask(
                  shaderCallback: (bounds) {
                    return const LinearGradient(
                      colors: [
                        Color(0xff7C5CFF),
                        Color(0xff00D4FF),
                      ],
                    ).createShader(bounds);
                  },
                  child: const Text(
                    "SHIVI",
                    style: TextStyle(
                      fontSize: 86,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      letterSpacing: 12,
                    ),
                  ),
                ),
                ...List.generate(6, (i) {
                  final angle =
                      rotateController.value * 2 * pi + i * (2 * pi / 6);

                  final radius = 170.0;

                  return Positioned(
                    left: 210 + cos(angle) * radius - 5,
                    top: 110 + sin(angle) * 55 - 5,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(.7),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
