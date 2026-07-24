import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff09090B),
                    Color(0xff111827),
                    Color(0xff09090B),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -120 + controller.value * 40,
              left: -60,
              child: glow(
                260,
                const Color(0xff7C5CFF),
              ),
            ),
            Positioned(
              bottom: -140,
              right: -60 + controller.value * 50,
              child: glow(
                320,
                const Color(0xff00D4FF),
              ),
            ),
            ...List.generate(
              45,
              (index) {
                final random = Random(index);

                final x =
                    random.nextDouble() * MediaQuery.of(context).size.width;

                final y =
                    random.nextDouble() * MediaQuery.of(context).size.height;

                final size = random.nextDouble() * 4 + 2;

                final speed = random.nextDouble() * 20;

                return Positioned(
                  left: x,
                  top: (y + sin(controller.value * pi * 2 + speed) * 20),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget glow(
    double size,
    Color color,
  ) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.25),
            blurRadius: 120,
            spreadRadius: 40,
          ),
        ],
      ),
    );
  }
}
