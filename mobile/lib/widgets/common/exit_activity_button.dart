import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import 'elder_button.dart';

/// Accessible exit / pause button for patient-facing activities.
/// Provides a clear, non-punitive confirmation dialog to reduce anxiety.
class ExitActivityButton extends StatelessWidget {
  final String label;
  final VoidCallback? onExitConfirmed;
  final bool isPauseOnly;

  const ExitActivityButton({
    super.key,
    this.label = 'Finish for Now',
    this.onExitConfirmed,
    this.isPauseOnly = false,
  });

  Future<void> _showConfirmation(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundWarm,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.surfaceWarm,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.spa_outlined, color: AppColors.forestPrimary, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Take a Peaceful Rest?',
                style: AppTypography.patientTitle,
              ),
            ),
          ],
        ),
        content: const Text(
          'You can stop anytime you like. Everything you did today is preserved safely.',
          style: AppTypography.caregiverBody,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        actions: [
          ElderButton(
            label: 'Keep Playing',
            icon: Icons.play_arrow,
            variant: ElderButtonVariant.primary,
            height: 52,
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          const SizedBox(height: 10),
          ElderButton(
            label: 'Yes, Finish for Now',
            icon: Icons.home_outlined,
            variant: ElderButtonVariant.secondary,
            height: 52,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    );

    if (shouldExit == true && context.mounted) {
      if (onExitConfirmed != null) {
        onExitConfirmed!();
      } else {
        Navigator.of(context).maybePop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showConfirmation(context),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderSoft, width: 1.2),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPauseOnly ? Icons.pause_circle_outline : Icons.close,
                  size: 22,
                  color: AppColors.forestPrimary,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.forestPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
