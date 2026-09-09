import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

enum FeedbackBannerType {
  affirmation, // Gentle positive affirmation
  guidance,    // Calm support / take your time
  hint,        // Helpful hint without pressure
  info,        // General neutral note
}

/// Reusable supportive feedback banner for patient and caregiver contexts.
/// Strictly non-judgmental, warm, and accessible.
class FeedbackBanner extends StatelessWidget {
  final String message;
  final String? title;
  final FeedbackBannerType type;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  const FeedbackBanner({
    super.key,
    required this.message,
    this.title,
    this.type = FeedbackBannerType.guidance,
    this.icon,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color border;
    Color iconColor;
    IconData defaultIcon;

    switch (type) {
      case FeedbackBannerType.affirmation:
        bg = AppColors.sageLight;
        border = AppColors.sage;
        iconColor = AppColors.forestDark;
        defaultIcon = Icons.spa_outlined;
        break;
      case FeedbackBannerType.guidance:
        bg = AppColors.surfaceWarm;
        border = AppColors.borderSoft;
        iconColor = AppColors.forestPrimary;
        defaultIcon = Icons.favorite_outline;
        break;
      case FeedbackBannerType.hint:
        bg = AppColors.peachLight;
        border = AppColors.peach;
        iconColor = AppColors.peachDark;
        defaultIcon = Icons.lightbulb_outline;
        break;
      case FeedbackBannerType.info:
        bg = AppColors.backgroundWarm;
        border = AppColors.borderSoft;
        iconColor = AppColors.infoBlueSoft;
        defaultIcon = Icons.info_outline;
        break;
    }

    return Semantics(
      label: '${title ?? ''} $message',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border, width: 1.4),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? defaultIcon,
                size: 24,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    Text(
                      title!,
                      style: AppTypography.caregiverSubheading.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    message,
                    style: AppTypography.patientBody.copyWith(
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  foregroundColor: iconColor,
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
