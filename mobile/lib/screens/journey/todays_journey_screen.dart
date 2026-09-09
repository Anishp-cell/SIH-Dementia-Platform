import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/activity_item.dart';
import '../../models/ai_recommendation.dart';
import '../../services/profile_service.dart';
import '../../services/recommendation_service.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/feedback_banner.dart';
import '../../widgets/common/language_toggle_widget.dart';
import '../../widgets/common/voice_instruction_bar.dart';
import '../activities/activities_catalog_sheet.dart';

/// Screen representing Today's Gentle Journey (Patient Home).
/// Driven by dynamic recommendation model, offers large touch targets,
/// spoken instructions, gentle music alternatives, and safe exit actions.
class TodaysJourneyScreen extends StatefulWidget {
  const TodaysJourneyScreen({super.key});

  @override
  State<TodaysJourneyScreen> createState() => _TodaysJourneyScreenState();
}

class _TodaysJourneyScreenState extends State<TodaysJourneyScreen> {
  bool _isCaregiverPresent = false;

  @override
  void initState() {
    super.initState();
    RecommendationService.instance.addListener(_onServiceUpdate);
    ProfileService.instance.addListener(_onServiceUpdate);
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    RecommendationService.instance.removeListener(_onServiceUpdate);
    ProfileService.instance.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _handleFinishSession() {
    showDialog(
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
              child: const Icon(Icons.spa, color: AppColors.forestPrimary, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Rest for Today?', style: AppTypography.patientTitle),
            ),
          ],
        ),
        content: const Text(
          'You have spent a wonderful, peaceful moment with us today. Your progress is completely preserved.',
          style: AppTypography.caregiverBody,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        actions: [
          ElderButton(
            label: 'Keep Exploring',
            icon: Icons.play_arrow,
            variant: ElderButtonVariant.primary,
            height: 50,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          const SizedBox(height: 10),
          ElderButton(
            label: 'Finish Session Gently',
            icon: Icons.check_circle_outline,
            variant: ElderButtonVariant.secondary,
            height: 50,
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelection);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final patient = ProfileService.instance.activeProfile;
    final patientName = patient?.preferredName ?? 'Friend';

    final activities = RecommendationService.instance.getTodaysJourneyActivities(
      isCaregiverPresent: _isCaregiverPresent,
    );

    final recommendation = RecommendationService.instance.currentRecommendation;
    final isDelayedOffline = recommendation?.status == AiProcessingStatus.delayedOffline;

    final primaryActivity = activities.isNotEmpty ? activities.first : null;

    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        title: Text(AppStrings.get('todays_journey'), style: AppTypography.patientTitle),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 6.0),
            child: LanguageToggleWidget(),
          ),
          IconButton(
            icon: const Icon(Icons.grid_view_rounded, color: AppColors.forestPrimary),
            tooltip: 'All 8 Experiences',
            onPressed: () => ActivitiesCatalogSheet.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.dashboard_outlined, color: AppColors.forestPrimary),
            tooltip: 'Caregiver Dashboard',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.caregiverDashboard);
            },
          ),
          IconButton(
            icon: const Icon(Icons.photo_album_outlined, color: AppColors.forestPrimary),
            tooltip: 'Personal Memory Space',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.memoryVault);
            },
          ),
          IconButton(
            icon: const Icon(Icons.auto_awesome_outlined, color: AppColors.forestPrimary),
            tooltip: '15 System & AI States Showcase',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.systemStatesShowcase);
            },
          ),
          IconButton(
            icon: const Icon(Icons.switch_account_outlined, color: AppColors.forestPrimary),
            tooltip: 'Switch Mode / Home',
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.roleSelection);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Voice Instruction & Greeting Bar
              VoiceInstructionBar(
                instructionText: 'Welcome back, $patientName. Today is peaceful. Here is your recommended activity.',
                autoPlay: false,
              ),
              const SizedBox(height: 16),

              // Offline notice banner if delayed offline
              if (isDelayedOffline) ...[
                const FeedbackBanner(
                  type: FeedbackBannerType.info,
                  title: 'Offline Mode Active',
                  message: 'Your activities are loaded safely from local storage. Everything works without internet.',
                ),
                const SizedBox(height: 14),
              ],

              // Caregiver Presence Triage Card
              CalmCard(
                backgroundColor: AppColors.surfaceWarm,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people_outline, color: AppColors.forestPrimary, size: 24),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppStrings.get('caregiver_present_q'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildPresenceChoice(
                            label: AppStrings.get('yes_together'),
                            icon: Icons.favorite,
                            isSelected: _isCaregiverPresent,
                            onTap: () => setState(() => _isCaregiverPresent = true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildPresenceChoice(
                            label: AppStrings.get('no_independent'),
                            icon: Icons.person,
                            isSelected: !_isCaregiverPresent,
                            onTap: () => setState(() => _isCaregiverPresent = false),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // No Game Today Gentle Alternative Banner if recommended
              if (RecommendationService.instance.isNoGameRecommended) ...[
                CalmCard(
                  backgroundColor: AppColors.peachLight,
                  borderColor: AppColors.peach,
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      const Icon(Icons.spa_rounded, color: AppColors.peachDark, size: 30),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Gentle Rest Day Recommended',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.peachDark),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              RecommendationService.instance.gentleAlternativeDescription,
                              style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, height: 1.3),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Dynamic Hero Card: Today's Recommended Activity
              if (primaryActivity != null) ...[
                const Row(
                  children: [
                    Icon(Icons.auto_awesome, color: AppColors.forestPrimary, size: 22),
                    SizedBox(width: 8),
                    Text("Today's Recommendation", style: AppTypography.patientTitle),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _isCaregiverPresent
                      ? 'Caregiver present: Shared connection and gentle recognition.'
                      : 'Independent play: Unpaced, self-guided gentle activity.',
                  style: AppTypography.caregiverBody,
                ),
                const SizedBox(height: 14),

                // Featured Hero Card
                CalmCard(
                  padding: const EdgeInsets.all(22),
                  borderColor: AppColors.forestPrimary.withValues(alpha: 0.25),
                  borderWidth: 1.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: primaryActivity.themeColor.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(primaryActivity.icon, size: 34, color: primaryActivity.themeColor),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  primaryActivity.patientFriendlyTitle,
                                  style: AppTypography.patientHero.copyWith(fontSize: 22),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  primaryActivity.subtitle,
                                  style: AppTypography.caregiverBody,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Gentle Non-Clinical Reason Badge
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceWarm,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.borderSoft),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb_outline, size: 18, color: AppColors.forestPrimary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Recommended for you: Based on your morning routine and fondness for familiar nature.',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.forestDark.withValues(alpha: 0.9),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Cultural tags chips
                      Wrap(
                        spacing: 6,
                        children: primaryActivity.culturalTags.map((tag) {
                          return Chip(
                            label: Text(tag, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                            backgroundColor: AppColors.surfaceWarm,
                            padding: EdgeInsets.zero,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),

                      // Large Start Activity Action
                      ElderButton(
                        label: 'Start Recommended Activity',
                        icon: Icons.play_arrow,
                        variant: ElderButtonVariant.primary,
                        height: 58,
                        onPressed: () {
                          Navigator.of(context).pushNamed(primaryActivity.routeName);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Gentle Alternative: Music & Peaceful Connection
              CalmCard(
                backgroundColor: AppColors.surfaceWarm,
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.music_note, color: AppColors.forestPrimary, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Prefer a Quiet Moment?',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Listen to soothing flute melodies or browse familiar photos together.',
                            style: AppTypography.caregiverCaption,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AppRoutes.connectionMusic);
                      },
                      child: const Text('Listen', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Other Gentle Choices
              const Row(
                children: [
                  Icon(Icons.park_outlined, color: AppColors.sage, size: 22),
                  SizedBox(width: 8),
                  Text('Other Gentle Activities Today', style: AppTypography.patientTitle),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Explore anytime. No timers, no scoring, and no pressure.',
                style: AppTypography.caregiverBody,
              ),
              const SizedBox(height: 12),

              // Activity Cards for index 1 and beyond
              ...List.generate(activities.length > 1 ? activities.length - 1 : 0, (i) {
                final activity = activities[i + 1];
                return _buildSecondaryActivityCard(context, activity);
              }),

              const SizedBox(height: 24),

              // Finish Session Action
              Center(
                child: ElderButton(
                  label: 'Finish Session for Today',
                  icon: Icons.check_circle_outline,
                  variant: ElderButtonVariant.secondary,
                  height: 52,
                  onPressed: _handleFinishSession,
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.science_outlined, size: 18, color: AppColors.forestPrimary),
                  label: const Text(
                    'Preview All 15 AI & System States',
                    style: TextStyle(color: AppColors.forestPrimary, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.systemStatesShowcase);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresenceChoice({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.forestPrimary : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.forestPrimary : AppColors.borderSoft,
            width: 1.4,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? Colors.white : AppColors.forestPrimary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryActivityCard(BuildContext context, ActivityItem activity) {
    return CalmCard(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: activity.themeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(activity.icon, size: 26, color: activity.themeColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.patientFriendlyTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                ),
                const SizedBox(height: 3),
                Text(activity.subtitle, style: AppTypography.caregiverCaption),
              ],
            ),
          ),
          IconButton.filled(
            icon: const Icon(Icons.arrow_forward),
            style: IconButton.styleFrom(backgroundColor: AppColors.forestPrimary),
            onPressed: () {
              Navigator.of(context).pushNamed(activity.routeName);
            },
          ),
        ],
      ),
    );
  }
}
