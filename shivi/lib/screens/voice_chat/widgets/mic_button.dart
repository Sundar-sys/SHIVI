import 'package:flutter/material.dart';
import '../../../providers/voice_provider.dart';
import '../../../core/constants/app_colors.dart';

class MicButton extends StatelessWidget {
  final ShiviState state;
  final VoidCallback onTap;

  const MicButton({super.key, required this.state, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isListening = state == ShiviState.listening;
    final isBusy = state == ShiviState.thinking || state == ShiviState.speaking;

    return GestureDetector(
      onTap: isBusy ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: 76,
        height: 76,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isListening
                ? [AppColors.softPurple, AppColors.softBlue]
                : [
                    AppColors.softBlue.withValues(alpha: 0.6),
                    AppColors.softPurple.withValues(alpha: 0.6)
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.softPurple
                  .withValues(alpha: isListening ? 0.4 : 0.15),
              blurRadius: isListening ? 20 : 8,
              spreadRadius: isListening ? 4 : 0,
            ),
          ],
        ),
        child: Icon(
          isListening ? Icons.mic : Icons.mic_none,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
