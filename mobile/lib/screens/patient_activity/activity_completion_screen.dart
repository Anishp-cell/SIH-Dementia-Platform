import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/voice_instruction_bar.dart';

/// Reusable session / activity completion screen for patient experiences.
/// Celebrates human effort, connection, and calm engagement without numerical scores.
class ActivityCompletionScreen extends StatelessWidget {
  final String activityTitle;
  final VoidCallback? onNextActivity;
  final VoidCallback? onFinishSession;

  const ActivityCompletionScreen({
    super.key,
    this.activityTitle = 'Familiar Nature Match',
    this.onNextActivity,
    this.onFinishSession,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              // Calm Celebration Floral Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.sageLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.sage, width: 2),
                ),
                child: const Icon(
                  Icons.spa,
                  size: 52,
                  color: AppColors.forestPrimary,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                'Wonderful Effort Today!',
                style: AppTypography.patientHero,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              Text(
                'You spent a gentle, peaceful moment with $activityTitle. Every moment shared together brings warmth and familiarity.',
                style: AppTypography.patientBody.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Voice celebration message
              const VoiceInstructionBar(
                instructionText: 'You did wonderful today. Take a deep breath and relax.',
                autoPlay: false,
              ),
              const SizedBox(height: 20),

              // Non-medical affirmation card
              CalmCard(
                backgroundColor: AppColors.surfaceWarm,
                padding: const EdgeInsets.all(18),
                child: const Row(
                  children: [
                    Icon(Icons.favorite_outline, color: AppColors.forestPrimary, size: 28),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Your progress is saved safely. No rush, no scores — just peaceful connection.',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.forestDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Next Activity Action
              ElderButton(
                label: 'Next Gentle Activity',
                icon: Icons.play_arrow,
                variant: ElderButtonVariant.primary,
                height: 56,
                onPressed: onNextActivity ??
                    () {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.todaysJourney);
                    },
              ),
              const SizedBox(height: 12),

              // Finish Session Action
              ElderButton(
                label: 'Finish Session for Today',
                icon: Icons.home_outlined,
                variant: ElderButtonVariant.secondary,
                height: 54,
                onPressed: onFinishSession ??
                    () {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.todaysJourney);
                    },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
