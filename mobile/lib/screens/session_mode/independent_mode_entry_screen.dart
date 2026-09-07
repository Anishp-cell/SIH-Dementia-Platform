import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/feedback_banner.dart';
import '../../widgets/common/gentle_back_button.dart';
import '../../widgets/common/voice_instruction_bar.dart';

/// Entry contract screen for Independent Play.
/// Welcomes the patient, provides voice support, and ensures
/// calm, unpaced interaction before launching the activity shell.
class IndependentModeEntryScreen extends StatelessWidget {
  final String? activityTitle;
  final String? activitySubtitle;
  final bool requiresCaregiver;

  const IndependentModeEntryScreen({
    super.key,
    this.activityTitle = 'Familiar Nature Match',
    this.activitySubtitle = 'Notice and pair gentle tea leaves, flowers, and brass lamps.',
    this.requiresCaregiver = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        leading: const GentleBackButton(),
        title: const Text('Independent Session', style: AppTypography.caregiverHeading),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Voice guidance
              const VoiceInstructionBar(
                instructionText: 'Take all the time you need. There are no timers, and you can stop whenever you want.',
              ),
              const SizedBox(height: 20),

              // Title and Subtitle
              Text(
                activityTitle!,
                style: AppTypography.patientHero,
              ),
              const SizedBox(height: 8),
              Text(
                activitySubtitle!,
                style: AppTypography.caregiverBody,
              ),
              const SizedBox(height: 20),

              // Caregiver requirement check
              if (requiresCaregiver) ...[
                const FeedbackBanner(
                  type: FeedbackBannerType.hint,
                  title: 'Caregiver Recommended',
                  message: 'This activity is best enjoyed with someone nearby. You can still try, or switch to a relaxing music activity.',
                ),
                const SizedBox(height: 16),
              ],

              // Peaceful Play Rules
              CalmCard(
                backgroundColor: AppColors.surfaceWarm,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRuleRow(Icons.timer_off_outlined, 'No Pressure & No Timers', 'Play at your own natural pace without countdowns.'),
                    const SizedBox(height: 14),
                    _buildRuleRow(Icons.volume_up_outlined, 'Voice Support Always On', 'Tap any speaker button to listen to instructions aloud.'),
                    const SizedBox(height: 14),
                    _buildRuleRow(Icons.pause_circle_outline, 'Pause & Rest Anytime', 'Take a break or finish whenever you feel like resting.'),
                  ],
                ),
              ),

              const Spacer(),

              // Start button
              ElderButton(
                label: 'Begin Activity',
                icon: Icons.play_arrow,
                variant: ElderButtonVariant.primary,
                height: 56,
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.activityShell);
                },
              ),
              const SizedBox(height: 12),

              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.people_outline, size: 18, color: AppColors.forestPrimary),
                  label: const Text(
                    'Is a caregiver here? Switch to Together Mode',
                    style: TextStyle(color: AppColors.forestPrimary, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.togetherModeEntry);
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

  Widget _buildRuleRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 22, color: AppColors.forestPrimary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text(subtitle, style: AppTypography.caregiverCaption),
            ],
          ),
        ),
      ],
    );
  }
}
