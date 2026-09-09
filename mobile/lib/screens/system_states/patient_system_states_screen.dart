import 'package:flutter/material.dart';
import '../../core/audio/voice_assistant_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/gentle_back_button.dart';

/// All 15 required patient-facing AI & system states for the SIH Dementia Platform.
enum PatientSystemStateType {
  personalisationLoading,
  recommendationLoading,
  recommendedAvailable,
  difficultyChanged,
  activityChanged,
  caregiverAssistance,
  noSuitableGame,
  gentleActivityRecommendation,
  offline,
  syncing,
  synced,
  voiceProcessing,
  error,
  retry,
  sessionCompleted,
}

class PatientSystemStatesScreen extends StatefulWidget {
  final PatientSystemStateType initialState;

  const PatientSystemStatesScreen({
    super.key,
    this.initialState = PatientSystemStateType.personalisationLoading,
  });

  @override
  State<PatientSystemStatesScreen> createState() => _PatientSystemStatesScreenState();
}

class _PatientSystemStatesScreenState extends State<PatientSystemStatesScreen>
    with TickerProviderStateMixin {
  late PatientSystemStateType _currentState;

  // Animation controllers for pulsing & voice wave
  late AnimationController _pulseController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _currentState = widget.initialState;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant PatientSystemStatesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialState != widget.initialState) {
      _currentState = widget.initialState;
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _setState(PatientSystemStateType state) {
    setState(() {
      _currentState = state;
    });
  }

  void _nextState() {
    final values = PatientSystemStateType.values;
    final nextIndex = (_currentState.index + 1) % values.length;
    _setState(values[nextIndex]);
  }

  void _previousState() {
    final values = PatientSystemStateType.values;
    final prevIndex = (_currentState.index - 1 + values.length) % values.length;
    _setState(values[prevIndex]);
  }

  String _getStateDisplayName(PatientSystemStateType type) {
    switch (type) {
      case PatientSystemStateType.personalisationLoading:
        return '1. Personalisation Loading';
      case PatientSystemStateType.recommendationLoading:
        return '2. Recommendation Loading';
      case PatientSystemStateType.recommendedAvailable:
        return '3. Recommended Activity Available';
      case PatientSystemStateType.difficultyChanged:
        return '4. Difficulty Changed (Gentle Adaptation)';
      case PatientSystemStateType.activityChanged:
        return '5. Activity Changed (Gentle Alternative)';
      case PatientSystemStateType.caregiverAssistance:
        return '6. Caregiver Assistance Required';
      case PatientSystemStateType.noSuitableGame:
        return '7. No Suitable Game (Quiet Connection)';
      case PatientSystemStateType.gentleActivityRecommendation:
        return '8. Gentle Activity Recommendation';
      case PatientSystemStateType.offline:
        return '9. Offline Mode (Local Protection)';
      case PatientSystemStateType.syncing:
        return '10. Syncing (Background)';
      case PatientSystemStateType.synced:
        return '11. Synced Successfully';
      case PatientSystemStateType.voiceProcessing:
        return '12. Voice Processing (Listening)';
      case PatientSystemStateType.error:
        return '13. Friendly Error (Calm Pause)';
      case PatientSystemStateType.retry:
        return '14. Retry State';
      case PatientSystemStateType.sessionCompleted:
        return '15. Session Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        leading: const GentleBackButton(),
        title: const Text('System & AI States (All 15)', style: AppTypography.patientTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.forestPrimary),
            tooltip: 'About SIH Non-Diagnostic States',
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Evaluation & Demo Navigation Header
            _buildEvaluationToolbar(),

            // Active State Presentation Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: _buildCurrentStateContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceWarm,
        border: const Border(
          bottom: BorderSide(color: AppColors.borderSoft, width: 1.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.forestPrimary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Interactive Demo Switcher (${_currentState.index + 1}/15)',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.forestDark),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Previous Button
              IconButton(
                icon: const Icon(Icons.chevron_left, color: AppColors.forestPrimary, size: 28),
                tooltip: 'Previous state',
                onPressed: _previousState,
              ),
              // Dropdown to jump directly to any of the 15 states
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.forestPrimary.withValues(alpha: 0.5)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<PatientSystemStateType>(
                      isExpanded: true,
                      value: _currentState,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.forestPrimary),
                      onChanged: (newState) {
                        if (newState != null) _setState(newState);
                      },
                      items: PatientSystemStateType.values.map((state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Text(
                            _getStateDisplayName(state),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              // Next Button
              IconButton(
                icon: const Icon(Icons.chevron_right, color: AppColors.forestPrimary, size: 28),
                tooltip: 'Next state',
                onPressed: _nextState,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStateContent() {
    switch (_currentState) {
      case PatientSystemStateType.personalisationLoading:
        return _buildPersonalisationLoading();
      case PatientSystemStateType.recommendationLoading:
        return _buildRecommendationLoading();
      case PatientSystemStateType.recommendedAvailable:
        return _buildRecommendedAvailable();
      case PatientSystemStateType.difficultyChanged:
        return _buildDifficultyChanged();
      case PatientSystemStateType.activityChanged:
        return _buildActivityChanged();
      case PatientSystemStateType.caregiverAssistance:
        return _buildCaregiverAssistance();
      case PatientSystemStateType.noSuitableGame:
        return _buildNoSuitableGame();
      case PatientSystemStateType.gentleActivityRecommendation:
        return _buildGentleActivityRecommendation();
      case PatientSystemStateType.offline:
        return _buildOffline();
      case PatientSystemStateType.syncing:
        return _buildSyncing();
      case PatientSystemStateType.synced:
        return _buildSynced();
      case PatientSystemStateType.voiceProcessing:
        return _buildVoiceProcessing();
      case PatientSystemStateType.error:
        return _buildError();
      case PatientSystemStateType.retry:
        return _buildRetry();
      case PatientSystemStateType.sessionCompleted:
        return _buildSessionCompleted();
    }
  }

  // 1. Personalisation Loading State
  Widget _buildPersonalisationLoading() {
    return _buildStateCard(
      badge: 'STATE 1: PERSONALISATION LOADING',
      badgeColor: AppColors.forestPrimary,
      iconWidget: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final scale = 0.95 + (_pulseController.value * 0.1);
          return Transform.scale(
            scale: scale,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.forestPrimary.withValues(alpha: 0.12),
                border: Border.all(color: AppColors.forestPrimary.withValues(alpha: 0.3), width: 3),
              ),
              child: const Icon(Icons.spa, size: 54, color: AppColors.forestPrimary),
            ),
          );
        },
      ),
      title: 'Preparing Your Special Space',
      description: 'Gathering your favourite songs, tea garden memories, and comforting sights...',
      clinicalDesignRule: 'Design Rule: No technical spinning bars or numeric progress percentages. A gentle rhythmic pulse soothes anticipation.',
      primaryButtonText: 'Preview Finished Space',
      primaryAction: () => _setState(PatientSystemStateType.recommendedAvailable),
    );
  }

  // 2. Recommendation Loading State
  Widget _buildRecommendationLoading() {
    return _buildStateCard(
      badge: 'STATE 2: RECOMMENDATION LOADING',
      badgeColor: AppColors.peach,
      iconWidget: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.peach.withValues(alpha: 0.12),
              border: Border.all(color: AppColors.peach.withValues(alpha: 0.4), width: 3),
            ),
            child: const Icon(Icons.wb_sunny_outlined, size: 54, color: AppColors.peach),
          );
        },
      ),
      title: 'Finding Today\'s Best Moment',
      description: 'Our gentle helper is checking what feels most peaceful and enjoyable for you today.',
      clinicalDesignRule: 'Design Rule: Calming phrasing ensures the elder feels attended to, not tested or evaluated.',
      primaryButtonText: 'See Chosen Activity',
      primaryAction: () => _setState(PatientSystemStateType.recommendedAvailable),
    );
  }

  // 3. Recommended Activity Available State
  Widget _buildRecommendedAvailable() {
    return _buildStateCard(
      badge: 'STATE 3: RECOMMENDED ACTIVITY AVAILABLE',
      badgeColor: AppColors.forestPrimary,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.sageLight,
          border: Border.all(color: AppColors.forestPrimary, width: 3),
        ),
        child: const Icon(Icons.music_note_rounded, size: 56, color: AppColors.forestPrimary),
      ),
      title: 'Today\'s Gentle Activity is Ready',
      description: 'Music & Memories of Assam\n\nChosen because you love morning raga, Bihu tunes, and quiet afternoon tea.',
      clinicalDesignRule: 'Design Rule: Transparent non-clinical reason anchors familiarity and eliminates disorientation.',
      primaryButtonText: 'Begin Gently Now',
      primaryAction: () {
        Navigator.of(context).pushNamed(AppRoutes.musicAndMemory);
      },
      secondaryButtonText: 'Change to Another Activity',
      secondaryAction: () => _setState(PatientSystemStateType.activityChanged),
    );
  }

  // 4. Difficulty Changed State (Gentle Comfort Adaptation)
  Widget _buildDifficultyChanged() {
    return _buildStateCard(
      badge: 'STATE 4: COMFORT ADAPTATION',
      badgeColor: AppColors.domainLanguage,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.domainLanguage.withValues(alpha: 0.2),
          border: Border.all(color: AppColors.domainLanguage, width: 3),
        ),
        child: const Icon(Icons.self_improvement_rounded, size: 54, color: AppColors.domainLanguage),
      ),
      title: 'Taking Things a Little Gentler',
      description: 'We are slowing the pace and giving you all the time you need. There is no rush at all, and no scores to worry about.',
      clinicalDesignRule: 'Design Rule: Never display "lowering difficulty" or "game level reduced". Frame as a calming pause that honors comfort.',
      primaryButtonText: 'Continue at Your Own Pace',
      primaryAction: () {
        _showActionSnackBar('Continuing comfortably without time pressure.');
      },
    );
  }

  // 5. Activity Changed State (Gentle Alternative Suggestion)
  Widget _buildActivityChanged() {
    return _buildStateCard(
      badge: 'STATE 5: ACTIVITY CHANGED',
      badgeColor: AppColors.peach,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.peach.withValues(alpha: 0.15),
          border: Border.all(color: AppColors.peach, width: 3),
        ),
        child: const Icon(Icons.photo_library_outlined, size: 54, color: AppColors.peach),
      ),
      title: 'How About Something Peaceful?',
      description: 'We thought you might enjoy looking at familiar family photographs instead: "Story from the Old Photo Album".',
      clinicalDesignRule: 'Design Rule: Smooth pivot prevents frustration. The elder always maintains control of their preference.',
      primaryButtonText: 'Switch to Photo Story',
      primaryAction: () {
        _showActionSnackBar('Switched to Photo Story activity.');
      },
      secondaryButtonText: 'Stay with Music & Memory',
      secondaryAction: () => _setState(PatientSystemStateType.recommendedAvailable),
    );
  }

  // 6. Caregiver Assistance Required State
  Widget _buildCaregiverAssistance() {
    return _buildStateCard(
      badge: 'STATE 6: CAREGIVER ASSISTANCE REQUIRED',
      badgeColor: AppColors.forestPrimary,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.forestPrimary.withValues(alpha: 0.12),
          border: Border.all(color: AppColors.forestPrimary, width: 3),
        ),
        child: const Icon(Icons.people_outline_rounded, size: 54, color: AppColors.forestPrimary),
      ),
      title: 'Let\'s Invite Your Companion',
      description: 'This moment is wonderful to share together. Would you like to call your family member or caregiver to sit beside you?',
      clinicalDesignRule: 'Design Rule: Replaces alarming "Error: Patient Assistance Needed" with warm social connection framing.',
      primaryButtonText: 'Invite Caregiver Together',
      primaryAction: () {
        Navigator.of(context).pushNamed(AppRoutes.togetherModeEntry);
      },
      secondaryButtonText: 'Try a Quiet Moment Solo',
      secondaryAction: () => _setState(PatientSystemStateType.gentleActivityRecommendation),
    );
  }

  // 7. No Suitable Game State (Quiet Connection Today)
  Widget _buildNoSuitableGame() {
    return _buildStateCard(
      badge: 'STATE 7: NO SUITABLE GAME',
      badgeColor: AppColors.sage,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.sage.withValues(alpha: 0.2),
          border: Border.all(color: AppColors.sage, width: 3),
        ),
        child: const Icon(Icons.coffee_outlined, size: 54, color: AppColors.forestDark),
      ),
      title: 'A Peaceful Day for Connection',
      description: 'No games needed today. A calm moment with tea, reminiscing about family, or listening to water sounds is best.',
      clinicalDesignRule: 'Design Rule: AI recognizes fatigue and refuses to push cognitive tasks. Normalizes resting.',
      primaryButtonText: 'Play River & Melodies',
      primaryAction: () => _setState(PatientSystemStateType.gentleActivityRecommendation),
      secondaryButtonText: 'Open Family Memories',
      secondaryAction: () {
        Navigator.of(context).pushNamed(AppRoutes.memoryVault);
      },
    );
  }

  // 8. Gentle Activity Recommendation State
  Widget _buildGentleActivityRecommendation() {
    return _buildStateCard(
      badge: 'STATE 8: GENTLE ACTIVITY RECOMMENDATION',
      badgeColor: AppColors.forestPrimary,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.sageLight,
          border: Border.all(color: AppColors.forestPrimary, width: 3),
        ),
        child: const Icon(Icons.nature_people_rounded, size: 54, color: AppColors.forestPrimary),
      ),
      title: 'Brahmaputra Evening Whispers',
      description: 'A soft melody accompanied by North Eastern river sounds, gently narrated in your preferred language.',
      clinicalDesignRule: 'Design Rule: Always provides zero-failure, sensory-first fallback engagement.',
      primaryButtonText: 'Start Calming Melody',
      primaryAction: () {
        VoiceAssistantService.instance.speak('Playing gentle river sounds and evening raga.');
        _showActionSnackBar('Playing gentle river sounds and evening raga.');
      },
      secondaryButtonText: 'Return to Home',
      secondaryAction: () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.todaysJourney);
      },
    );
  }

  // 9. Offline State
  Widget _buildOffline() {
    return _buildStateCard(
      badge: 'STATE 9: OFFLINE MODE',
      badgeColor: AppColors.forestPrimary,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.forestPrimary.withValues(alpha: 0.12),
          border: Border.all(color: AppColors.forestPrimary, width: 3),
        ),
        child: const Icon(Icons.cloud_off_rounded, size: 54, color: AppColors.forestPrimary),
      ),
      title: 'Everything is Safe on Your Device',
      description: 'All your photos, songs, and activities are saved right here on your phone. You don\'t need internet to enjoy them.',
      clinicalDesignRule: 'Design Rule: Avoid red offline banners. Highlight safety, privacy, and full offline availability.',
      primaryButtonText: 'Enjoy Saved Activities',
      primaryAction: () {
        _showActionSnackBar('All local memories and activities are fully accessible.');
      },
    );
  }

  // 10. Syncing State
  Widget _buildSyncing() {
    return _buildStateCard(
      badge: 'STATE 10: SYNCING IN BACKGROUND',
      badgeColor: AppColors.forestPrimary,
      iconWidget: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _pulseController.value * 3.14159,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.sageLight,
                border: Border.all(color: AppColors.forestPrimary.withValues(alpha: 0.4), width: 3),
              ),
              child: const Icon(Icons.sync_rounded, size: 54, color: AppColors.forestPrimary),
            ),
          );
        },
      ),
      title: 'Quietly Saving Your Moments',
      description: 'Safely keeping your memories and preferences backed up in the background while you relax.',
      clinicalDesignRule: 'Design Rule: Subtle, non-blocking indicator. Elders never feel interrupted by technical sync tasks.',
      primaryButtonText: 'See Saved Confirmation',
      primaryAction: () => _setState(PatientSystemStateType.synced),
    );
  }

  // 11. Synced State
  Widget _buildSynced() {
    return _buildStateCard(
      badge: 'STATE 11: SYNCED SUCCESSFULLY',
      badgeColor: AppColors.forestPrimary,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.sageLight,
          border: Border.all(color: AppColors.forestPrimary, width: 3),
        ),
        child: const Icon(Icons.check_circle_rounded, size: 56, color: AppColors.forestPrimary),
      ),
      title: 'All Memories Safely Preserved',
      description: 'Your photos, preferences, and moments are safely stored in your personal vault.',
      clinicalDesignRule: 'Design Rule: Quiet reassurance gives peace of mind without technical terminology.',
      primaryButtonText: 'Back to Today\'s Journey',
      primaryAction: () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.todaysJourney);
      },
    );
  }

  // 12. Voice Processing State
  Widget _buildVoiceProcessing() {
    return _buildStateCard(
      badge: 'STATE 12: VOICE PROCESSING',
      badgeColor: AppColors.forestPrimary,
      iconWidget: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.forestPrimary.withValues(alpha: 0.12),
              border: Border.all(
                color: AppColors.forestPrimary.withValues(alpha: 0.3 + (_waveController.value * 0.4)),
                width: 3.5,
              ),
            ),
            child: const Icon(Icons.mic, size: 58, color: AppColors.forestPrimary),
          );
        },
      ),
      title: 'Listening to You...',
      description: 'Take all the time you need. Speak comfortably whenever you feel ready.',
      clinicalDesignRule: 'Design Rule: No cut-off countdown timer. The wave animation indicates attentive listening.',
      additionalWidget: Container(
        margin: const EdgeInsets.symmetric(vertical: 14),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.sage, width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                final height = 16.0 + ((index + 1) * 6 * _waveController.value);
                return Container(
                  width: 8,
                  height: height,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: AppColors.forestPrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              },
            );
          }),
        ),
      ),
      primaryButtonText: 'I Have Finished Speaking',
      primaryAction: () {
        _showActionSnackBar('Voice recorded with warmth. Thank you!');
      },
      secondaryButtonText: 'Cancel Voice Input',
      secondaryAction: () => _setState(PatientSystemStateType.recommendedAvailable),
    );
  }

  // 13. Friendly Error State (Calm Pause)
  Widget _buildError() {
    return _buildStateCard(
      badge: 'STATE 13: FRIENDLY ERROR (CALM PAUSE)',
      badgeColor: AppColors.peach,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.peach.withValues(alpha: 0.15),
          border: Border.all(color: AppColors.peach, width: 3),
        ),
        child: const Icon(Icons.pause_circle_outline_rounded, size: 56, color: AppColors.peach),
      ),
      title: 'Let\'s Pause for a Moment',
      description: 'Something paused softly. Don\'t worry at all—nothing has been lost. We will help you get right back.',
      clinicalDesignRule: 'Design Rule: Zero technical error codes (no 404, 500, crash, null, or red warning banners). Calming amber palette.',
      primaryButtonText: 'Try Again Gently',
      primaryAction: () => _setState(PatientSystemStateType.retry),
      secondaryButtonText: 'Return to Home',
      secondaryAction: () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.todaysJourney);
      },
    );
  }

  // 14. Retry State
  Widget _buildRetry() {
    return _buildStateCard(
      badge: 'STATE 14: RETRY STATE',
      badgeColor: AppColors.forestPrimary,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.sageLight,
          border: Border.all(color: AppColors.forestPrimary, width: 3),
        ),
        child: const Icon(Icons.refresh_rounded, size: 56, color: AppColors.forestPrimary),
      ),
      title: 'Ready Whenever You Are',
      description: 'We are completely ready to try again. Take a gentle breath and tap the button when you wish.',
      clinicalDesignRule: 'Design Rule: Large 56dp+ touch target reduces motor hesitation.',
      primaryButtonText: 'Let\'s Try Again',
      primaryAction: () => _setState(PatientSystemStateType.recommendedAvailable),
      secondaryButtonText: 'Take a Rest First',
      secondaryAction: () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.todaysJourney);
      },
    );
  }

  // 15. Session Completed State
  Widget _buildSessionCompleted() {
    return _buildStateCard(
      badge: 'STATE 15: SESSION COMPLETED',
      badgeColor: AppColors.forestPrimary,
      iconWidget: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.sageLight,
          border: Border.all(color: AppColors.forestPrimary, width: 3),
        ),
        child: const Icon(Icons.favorite_rounded, size: 54, color: AppColors.forestPrimary),
      ),
      title: 'A Beautiful Day Together',
      description: 'You have shared lovely moments today. May your evening be peaceful, joyful, and restful.',
      clinicalDesignRule: 'Design Rule: Zero clinical scores, percentiles, or cognitive rankings. Only warm gratitude and gentle accomplishment.',
      primaryButtonText: 'Finish Today\'s Journey',
      primaryAction: () {
        Navigator.of(context).pushReplacementNamed(AppRoutes.todaysJourney);
      },
      secondaryButtonText: 'Look at Memories Again',
      secondaryAction: () {
        Navigator.of(context).pushNamed(AppRoutes.memoryVault);
      },
    );
  }

  // Generic Reusable Card for each state
  Widget _buildStateCard({
    required String badge,
    required Color badgeColor,
    required Widget iconWidget,
    required String title,
    required String description,
    required String clinicalDesignRule,
    Widget? additionalWidget,
    required String primaryButtonText,
    required VoidCallback primaryAction,
    String? secondaryButtonText,
    VoidCallback? secondaryAction,
  }) {
    return CalmCard(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 24),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          // State Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: badgeColor.withValues(alpha: 0.4), width: 1.2),
            ),
            child: Text(
              badge,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.8,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Central Icon
          iconWidget,
          const SizedBox(height: 20),

          // Title
          Text(
            title,
            style: AppTypography.patientTitle.copyWith(fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            description,
            style: AppTypography.caregiverBody.copyWith(fontSize: 16, height: 1.5),
            textAlign: TextAlign.center,
          ),

          ?additionalWidget,

          const SizedBox(height: 20),

          // Voice speak button
          OutlinedButton.icon(
            icon: const Icon(Icons.volume_up, size: 20, color: AppColors.forestPrimary),
            label: const Text('Read Aloud to Patient', style: TextStyle(color: AppColors.forestPrimary)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.forestPrimary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              VoiceAssistantService.instance.speak('$title. $description');
            },
          ),

          const SizedBox(height: 16),

          // Clinical Non-Diagnostic Rule Note Box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSoft),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.health_and_safety_outlined, size: 18, color: AppColors.forestPrimary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    clinicalDesignRule,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Primary Button
          ElderButton(
            label: primaryButtonText,
            variant: ElderButtonVariant.primary,
            height: 56,
            onPressed: primaryAction,
          ),

          if (secondaryButtonText != null && secondaryAction != null) ...[
            const SizedBox(height: 12),
            ElderButton(
              label: secondaryButtonText,
              variant: ElderButtonVariant.secondary,
              height: 54,
              onPressed: secondaryAction,
            ),
          ],
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundWarm,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('15 Patient-Facing States', style: AppTypography.caregiverHeading),
        content: const SingleChildScrollView(
          child: Text(
            'In accordance with SIH Guidelines, every system and AI state is designed specifically for people living with dementia in North Eastern India:\n\n'
            '• Zero clinical or test scores\n'
            '• Zero panic or error-red alerts\n'
            '• Reassuring plain-language descriptions\n'
            '• Automatic quiet offline fallbacks\n'
            '• Minimum 48–56dp touch targets\n'
            '• Multi-modal voice support',
            style: AppTypography.caregiverBody,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Understood', style: TextStyle(color: AppColors.forestPrimary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showActionSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontSize: 15)),
        backgroundColor: AppColors.forestPrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
