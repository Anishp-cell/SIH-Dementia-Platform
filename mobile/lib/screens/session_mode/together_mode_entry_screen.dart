import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/feedback_banner.dart';
import '../../widgets/common/gentle_back_button.dart';

/// Entry contract screen for Together Mode.
/// Prepares caregiver and patient for collaborative interaction
/// before handing off to Priyanka's Together Mode mechanics.
class TogetherModeEntryScreen extends StatelessWidget {
  final String? activityTitle;
  final String? activityDescription;

  const TogetherModeEntryScreen({
    super.key,
    this.activityTitle = 'Family Photos Together',
    this.activityDescription = 'Look at familiar family photographs and explore warm storytelling prompts together.',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        leading: const GentleBackButton(),
        title: const Text('Together Mode', style: AppTypography.caregiverHeading),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Together Mode Pill Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.sageLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, size: 16, color: AppColors.forestDark),
                    SizedBox(width: 8),
                    Text(
                      'Caregiver & Patient Collaboration',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.forestDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Text(
                activityTitle!,
                style: AppTypography.patientHero,
              ),
              const SizedBox(height: 8),
              Text(
                activityDescription!,
                style: AppTypography.caregiverBody,
              ),
              const SizedBox(height: 20),

              // Caregiver Collaboration Tips Card
              CalmCard(
                backgroundColor: AppColors.surfaceWarm,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.handshake_outlined, color: AppColors.forestPrimary, size: 24),
                        SizedBox(width: 10),
                        Text('Caregiver Participation Guide', style: AppTypography.caregiverSubheading),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildTipRow(Icons.check_circle_outline, 'Sit beside each other comfortably with the screen in view.'),
                    const SizedBox(height: 10),
                    _buildTipRow(Icons.chat_bubble_outline, 'Read prompts aloud or use voice assistance to guide unhurriedly.'),
                    const SizedBox(height: 10),
                    _buildTipRow(Icons.sentiment_satisfied_alt, 'Celebrate every memory shared — there are no wrong answers.'),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              const FeedbackBanner(
                type: FeedbackBannerType.guidance,
                title: 'No Performance Pressure',
                message: 'Technology here is a facilitator of human connection, not a test.',
              ),

              const Spacer(),

              // Launch Together Mode action
              ElderButton(
                label: 'Begin Together Session',
                icon: Icons.play_arrow,
                variant: ElderButtonVariant.primary,
                height: 56,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.lookAndTalk);
                },
              ),
              const SizedBox(height: 12),

              // Switch to independent alternative
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.person_outline, size: 18, color: AppColors.forestPrimary),
                  label: const Text(
                    'Prefer an independent activity instead?',
                    style: TextStyle(color: AppColors.forestPrimary, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.independentModeEntry);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipRow(IconData icon, String tip) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.forestPrimary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            tip,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.35),
          ),
        ),
      ],
    );
  }
}
