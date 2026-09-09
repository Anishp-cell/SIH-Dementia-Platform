import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/activity_item.dart';
import '../../models/ai_recommendation.dart';
import '../../services/mock_data_repository.dart';
import '../../services/profile_service.dart';
import '../../services/recommendation_service.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/feedback_banner.dart';
import '../../widgets/common/language_toggle_widget.dart';
import '../../widgets/common/voice_instruction_bar.dart';

/// Screen representing Today's Experience (Patient Home).
/// Driven by dynamic recommendation model and structured into 3 clear sections:
/// 1. Think & Play (Independent Cognitive)
/// 2. Cognitive Together (Caregiver-Supported)
/// 3. Remember & Connect (Social / Reminiscence)
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
    final isNoGame = RecommendationService.instance.isNoGameRecommended;
    final activeDifficulty = RecommendationService.instance.activeDifficulty;

    final primaryActivity = activities.isNotEmpty ? activities.first : null;
    final catalog = MockDataRepository.getCatalogActivities();

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
            icon: const Icon(Icons.dashboard_outlined, color: AppColors.forestPrimary),
            tooltip: 'Caregiver Dashboard',
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.caregiverDashboard);
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
                instructionText: 'Welcome back, $patientName. Today is peaceful. Here is your recommended experience.',
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
              const SizedBox(height: 20),

              // ==========================================
              // HERO: TODAY'S PERSONALISED RECOMMENDATION
              // ==========================================
              if (isNoGame) ...[
                // Gentle Rest Day Hero (No Game Today)
                CalmCard(
                  padding: const EdgeInsets.all(22),
                  backgroundColor: AppColors.peachLight,
                  borderColor: AppColors.peach,
                  borderWidth: 1.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.spa_rounded, size: 34, color: AppColors.peachDark),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gentle Rest Moment',
                                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.peachDark),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Soothing flute melodies & quiet connection ("No Game Today")',
                                  style: TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.peach.withValues(alpha: 0.5)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, size: 18, color: AppColors.peachDark),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Recommended for you: Based on your recent mood, we are taking a restful pause with music and familiar photos instead of cognitive games.',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.peachDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElderButton(
                        label: 'Listen to Calming Flute Melodies',
                        icon: Icons.music_note,
                        variant: ElderButtonVariant.peach,
                        height: 58,
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.musicAndMemory);
                        },
                      ),
                      const SizedBox(height: 10),
                      ElderButton(
                        label: 'Browse Familiar Photos Together',
                        icon: Icons.photo_library_outlined,
                        variant: ElderButtonVariant.secondary,
                        height: 52,
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.lookAndTalk);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ] else if (primaryActivity != null) ...[
                // Active Recommendation Hero Card
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.forestPrimary, size: 22),
                    const SizedBox(width: 8),
                    const Text("Today's Recommendation", style: AppTypography.patientTitle),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.sageLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Pace: $activeDifficulty',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.forestPrimary),
                      ),
                    ),
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
                const SizedBox(height: 20),

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
              ],

              // ==========================================
              // SECTION 1: THINK & PLAY (INDEPENDENT)
              // ==========================================
              _buildSectionHeader(
                icon: Icons.psychology_outlined,
                title: 'Think & Play',
                subtitle: 'Independent cognitive activities with zero timers',
              ),
              const SizedBox(height: 10),
              _buildActivityRow(
                context: context,
                activity: catalog.firstWhere((a) => a.id == 'act_remember_recall'),
              ),
              _buildActivityRow(
                context: context,
                activity: catalog.firstWhere((a) => a.id == 'act_colour_word_focus'),
              ),
              const SizedBox(height: 22),

              // ==========================================
              // SECTION 2: COGNITIVE TOGETHER (SUPPORTED)
              // ==========================================
              _buildSectionHeader(
                icon: Icons.people_rounded,
                title: 'Cognitive Together',
                subtitle: 'Caregiver-supported collaborative play with hints',
              ),
              const SizedBox(height: 10),
              _buildActivityRow(
                context: context,
                activity: catalog.firstWhere((a) => a.id == 'act_family_match'),
              ),
              _buildActivityRow(
                context: context,
                activity: catalog.firstWhere((a) => a.id == 'act_build_the_day'),
              ),
              _buildActivityRow(
                context: context,
                activity: catalog.firstWhere((a) => a.id == 'act_familiar_object_match'),
              ),
              const SizedBox(height: 22),

              // ==========================================
              // SECTION 3: REMEMBER & CONNECT (SOCIAL)
              // ==========================================
              _buildSectionHeader(
                icon: Icons.favorite_border_rounded,
                title: 'Remember & Connect',
                subtitle: 'Social, music, and shared reminiscence experiences',
              ),
              const SizedBox(height: 10),
              _buildActivityRow(
                context: context,
                activity: catalog.firstWhere((a) => a.id == 'act_look_and_talk'),
              ),
              _buildActivityRow(
                context: context,
                activity: catalog.firstWhere((a) => a.id == 'act_music_and_memory'),
              ),
              _buildActivityRow(
                context: context,
                activity: catalog.firstWhere((a) => a.id == 'act_story_from_photo'),
              ),
              const SizedBox(height: 28),

              // ==========================================
              // FINISH SESSION FOR TODAY
              // ==========================================
              Center(
                child: ElderButton(
                  label: 'Finish Session for Today',
                  icon: Icons.check_circle_outline,
                  variant: ElderButtonVariant.secondary,
                  height: 54,
                  onPressed: _handleFinishSession,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.forestPrimary, size: 22),
            const SizedBox(width: 8),
            Text(title, style: AppTypography.caregiverHeading),
          ],
        ),
        const SizedBox(height: 2),
        Text(subtitle, style: AppTypography.caregiverCaption),
      ],
    );
  }

  Widget _buildActivityRow({
    required BuildContext context,
    required ActivityItem activity,
  }) {
    return CalmCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.symmetric(vertical: 6),
      onTap: () {
        Navigator.of(context).pushNamed(activity.routeName);
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: activity.themeColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(activity.icon, size: 24, color: activity.themeColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.patientFriendlyTitle,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(activity.subtitle, style: AppTypography.caregiverCaption),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.forestPrimary),
        ],
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
}

