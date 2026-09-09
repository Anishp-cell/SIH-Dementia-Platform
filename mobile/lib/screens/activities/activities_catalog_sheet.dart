import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../models/activity_item.dart';
import '../../services/mock_data_repository.dart';
import '../../widgets/common/calm_card.dart';

/// Modal bottom sheet displaying all 8 fully playable dementia activities.
/// Allows evaluators, caregivers, and clinicians to test any experience instantly.
class ActivitiesCatalogSheet extends StatelessWidget {
  const ActivitiesCatalogSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ActivitiesCatalogSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activities = MockDataRepository.getCatalogActivities();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) => Container(
        padding: const EdgeInsets.fromLTRB(22, 16, 22, 24),
        decoration: const BoxDecoration(
          color: AppColors.backgroundWarm,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: ListView(
          controller: scrollController,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.borderSoft,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 18),

            const Row(
              children: [
                Icon(Icons.grid_view_rounded, size: 26, color: AppColors.forestPrimary),
                SizedBox(width: 10),
                Text('All 8 Experiences', style: AppTypography.caregiverHeading),
              ],
            ),
            const SizedBox(height: 4),
            const Text(
              'Fully playable prototype activities built around the person, not a diagnosis.',
              style: AppTypography.caregiverCaption,
            ),
            const SizedBox(height: 16),

            // Section 1: Connection Together
            _buildSectionHeader('A. Connection Together (No right/wrong, shared memories)'),
            ...activities.where((a) => a.modality == ActivityModality.connectionTogether).map(
              (act) => _buildActivityTile(context, act),
            ),
            const SizedBox(height: 16),

            // Section 2: Cognitive Together
            _buildSectionHeader('B. Cognitive / Together (Collaborative play with hints)'),
            ...activities.where((a) => a.modality == ActivityModality.cognitiveTogether).map(
              (act) => _buildActivityTile(context, act),
            ),
            const SizedBox(height: 16),

            // Section 3: Independent Cognitive
            _buildSectionHeader('C. Independent Cognitive (Unpaced, zero timers, accessible)'),
            ...activities.where((a) => a.modality == ActivityModality.independent).map(
              (act) => _buildActivityTile(context, act),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: AppColors.forestPrimary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildActivityTile(BuildContext context, ActivityItem act) {
    return CalmCard(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      onTap: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(act.routeName);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: act.themeColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(act.icon, size: 24, color: act.themeColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  act.patientFriendlyTitle,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const SizedBox(height: 2),
                Text(
                  act.subtitle,
                  style: AppTypography.caregiverCaption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.forestPrimary),
        ],
      ),
    );
  }
}
