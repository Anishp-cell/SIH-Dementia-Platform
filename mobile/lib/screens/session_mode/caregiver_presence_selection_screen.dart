import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/gentle_back_button.dart';

/// Choice screen asking if a caregiver is present right now.
/// Directs cleanly into Together Mode or Independent Session flow.
class CaregiverPresenceSelectionScreen extends StatelessWidget {
  const CaregiverPresenceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        leading: const GentleBackButton(),
        title: const Text('Session Setup', style: AppTypography.caregiverSubheading),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Is a caregiver with you right now?',
                style: AppTypography.patientTitle,
              ),
              const SizedBox(height: 8),
              const Text(
                'We adapt the session so you can either share a collaborative moment together or enjoy a peaceful solo experience.',
                style: AppTypography.caregiverBody,
              ),
              const SizedBox(height: 20),

              // Option 1: Caregiver Present (Together Mode)
              CalmCard(
                backgroundColor: AppColors.surfaceWarm,
                borderColor: AppColors.forestPrimary.withValues(alpha: 0.3),
                padding: const EdgeInsets.all(20),
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.togetherModeEntry);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.forestPrimary.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        size: 42,
                        color: AppColors.forestPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Yes, We Are Together',
                      style: AppTypography.patientTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Together Mode — Shared conversation prompts, family photo exploration, and collaborative activities with hints.',
                      style: AppTypography.caregiverBody,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    ElderButton(
                      label: 'Enter Together Mode',
                      icon: Icons.people,
                      variant: ElderButtonVariant.primary,
                      height: 52,
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.togetherModeEntry);
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Option 2: Caregiver Not Present (Independent Mode)
              CalmCard(
                backgroundColor: Colors.white,
                borderColor: AppColors.borderSoft,
                padding: const EdgeInsets.all(20),
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.independentModeEntry);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.sage.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 42,
                        color: AppColors.sageDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'No, Playing on My Own',
                      style: AppTypography.patientTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Independent Session — Self-paced gentle activities with large buttons, spoken instructions, and unhurried rest.',
                      style: AppTypography.caregiverBody,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    ElderButton(
                      label: 'Start Independent Play',
                      icon: Icons.play_arrow,
                      variant: ElderButtonVariant.secondary,
                      height: 52,
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.independentModeEntry);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
