import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/navigation/app_routes.dart';
import '../../widgets/common/gentle_back_button.dart';
import '../../widgets/common/language_toggle_widget.dart';

/// Friendly, uncluttered triage: Is someone with you right now?
/// Default: No (Independent). Changing default removes pressure on the patient.
class CaregiverPresenceSelectionScreen extends StatefulWidget {
  const CaregiverPresenceSelectionScreen({super.key});

  @override
  State<CaregiverPresenceSelectionScreen> createState() =>
      _CaregiverPresenceSelectionScreenState();
}

class _CaregiverPresenceSelectionScreenState
    extends State<CaregiverPresenceSelectionScreen> {
  // Default to "No, I am alone" — patient should not feel pressure
  bool _isWithCaregiver = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWarm,
        elevation: 0,
        leading: const GentleBackButton(),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 14.0),
            child: LanguageToggleWidget(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: Column(
            children: [
              const SizedBox(height: 24),

              // Question — large and clear
              const Text(
                'Is someone with you right now?',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1.25,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              const Text(
                'This helps us set the right pace for today.',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              // Option: No, I am alone (DEFAULT — larger, highlighted at top)
              _buildOptionCard(
                selected: !_isWithCaregiver,
                icon: Icons.person_rounded,
                title: 'No, I am alone',
                subtitle: 'I will go at my own pace',
                onTap: () => setState(() => _isWithCaregiver = false),
              ),

              const SizedBox(height: 16),

              // Option: Yes, caregiver is here
              _buildOptionCard(
                selected: _isWithCaregiver,
                icon: Icons.people_rounded,
                title: 'Yes, someone is with me',
                subtitle: 'We will explore together',
                onTap: () => setState(() => _isWithCaregiver = true),
              ),

              const Spacer(),

              // Single big action button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed: () {
                    if (_isWithCaregiver) {
                      Navigator.of(context).pushNamed(AppRoutes.togetherModeEntry);
                    } else {
                      Navigator.of(context).pushNamed(AppRoutes.independentModeEntry);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestPrimary,
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: AppColors.forestPrimary.withValues(alpha: 0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Let's Begin",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded, size: 26),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required bool selected,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        decoration: BoxDecoration(
          color: selected ? AppColors.sageLight : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.forestPrimary : AppColors.borderSoft,
            width: selected ? 2.5 : 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.forestPrimary.withValues(alpha: 0.14),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.forestPrimary.withValues(alpha: 0.12)
                    : AppColors.surfaceWarm,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: selected ? AppColors.forestPrimary : AppColors.textTertiary,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: selected ? AppColors.forestPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.textSecondary : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            // Selection indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.forestPrimary : Colors.transparent,
                border: Border.all(
                  color: selected ? AppColors.forestPrimary : AppColors.borderSoft,
                  width: 2.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
