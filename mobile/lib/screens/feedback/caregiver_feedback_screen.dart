import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/caregiver_feedback.dart';
import '../../services/feedback_service.dart';
import '../../services/profile_service.dart';
import '../../services/recommendation_service.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/feedback_banner.dart';
import '../../widgets/common/gentle_back_button.dart';

/// Caregiver Feedback & Observation Screen.
/// Clearly framed as human caregiver observations, NEVER automated AI emotion detection or diagnosis.
/// Submitting observation updates the recommendation engine locally and immediately.
class CaregiverFeedbackScreen extends StatefulWidget {
  final String? sessionId;
  final String? activityTitle;

  const CaregiverFeedbackScreen({
    super.key,
    this.sessionId,
    this.activityTitle,
  });

  @override
  State<CaregiverFeedbackScreen> createState() => _CaregiverFeedbackScreenState();
}

class _CaregiverFeedbackScreenState extends State<CaregiverFeedbackScreen> {
  final Set<String> _selectedMoods = {'Calm', 'Engaged'};
  String _comfortRating = 'yes';
  final TextEditingController _notesController = TextEditingController();
  bool _isRecordingVoice = false;
  bool _hasRecordedVoice = false;
  bool _isSubmitted = false;
  final String _recommendationPreference = 'keep_similar';

  final List<String> _observationTags = [
    'Calm',
    'Engaged',
    'Quiet',
    'Tired',
    'Anxious',
    'Irritated',
    'Withdrawn',
    'Other',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _toggleMood(String mood) {
    setState(() {
      if (_selectedMoods.contains(mood)) {
        if (_selectedMoods.length > 1) {
          _selectedMoods.remove(mood);
        }
      } else {
        _selectedMoods.add(mood);
      }
    });
  }

  void _toggleVoiceRecording() {
    setState(() {
      _isRecordingVoice = !_isRecordingVoice;
      if (!_isRecordingVoice) {
        _hasRecordedVoice = true;
      }
    });
  }

  void _submitObservation() {
    final patient = ProfileService.instance.activeProfile;
    final patientId = patient?.id ?? 'patient_bonti_01';
    final sessionId = widget.sessionId ?? 'session_${DateTime.now().millisecondsSinceEpoch}';

    final feedback = CaregiverFeedback(
      id: 'fb_${DateTime.now().millisecondsSinceEpoch}',
      sessionId: sessionId,
      patientId: patientId,
      timestamp: DateTime.now(),
      observationTags: _selectedMoods.toList(),
      comfortRating: _comfortRating,
      whatHelped: _notesController.text.trim().isNotEmpty ? _notesController.text.trim() : 'Familiar memories and unpaced interaction.',
      transcriptionText: _hasRecordedVoice ? 'Voice observation recorded: Felt calm with music, smiled at photos.' : null,
      hasAudioAttachment: _hasRecordedVoice,
      enjoyedMusicOrMemory: true,
      recommendationPreference: _recommendationPreference,
      syncStatus: FeedbackService.instance.isOffline ? SyncStatus.pendingOffline : SyncStatus.synced,
    );

    FeedbackService.instance.submitFeedback(feedback);

    // Adapt next recommendation engine
    RecommendationService.instance.applyCaregiverObservation(
      moodTags: _selectedMoods.toList(),
      recommendationPreference: _recommendationPreference,
    );

    setState(() {
      _isSubmitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final patientName = ProfileService.instance.activeProfile?.preferredName ?? 'Your Loved One';
    final activityName = widget.activityTitle ?? 'Today’s Experience';

    if (_isSubmitted) {
      return _buildConfirmationView(patientName);
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWarm,
        elevation: 0,
        leading: const GentleBackButton(),
        title: const Text('Caregiver Observation', style: AppTypography.caregiverHeading),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Non-medical framing banner
              const FeedbackBanner(
                type: FeedbackBannerType.guidance,
                title: 'Caregiver Observation Only',
                message: 'Your human observations help tailor tomorrow’s pace. This is never clinical grading or AI emotion detection.',
              ),
              const SizedBox(height: 18),

              Text(
                'How was $patientName feeling during $activityName?',
                style: AppTypography.patientTitle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select any observations that resonate:',
                style: AppTypography.caregiverCaption,
              ),
              const SizedBox(height: 14),

              // Mood Chips Grid
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _observationTags.map((mood) {
                  final isSelected = _selectedMoods.contains(mood);
                  return FilterChip(
                    label: Text(mood),
                    selected: isSelected,
                    selectedColor: AppColors.forestPrimary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onSelected: (_) => _toggleMood(mood),
                  );
                }).toList(),
              ),

              const SizedBox(height: 22),

              // Comfort Rating
              const Text('Did the pace feel comfortable?', style: AppTypography.caregiverSubheading),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildComfortOption('yes', 'Yes, peaceful', Icons.sentiment_very_satisfied_rounded),
                  const SizedBox(width: 8),
                  _buildComfortOption('somewhat', 'Mostly calm', Icons.sentiment_satisfied_rounded),
                  const SizedBox(width: 8),
                  _buildComfortOption('no', 'Needed rest', Icons.sentiment_neutral_rounded),
                ],
              ),

              const SizedBox(height: 22),

              // Optional Text Notes
              const Text('Personal Notes & What Helped (Optional)', style: AppTypography.caregiverSubheading),
              const SizedBox(height: 8),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g. Smiled warmly when hearing the tea garden melody; preferred looking at river photos...',
                  hintStyle: const TextStyle(fontSize: 14, color: AppColors.textTertiary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderSoft),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.forestPrimary, width: 2),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Optional Voice Recording
              OutlinedButton.icon(
                onPressed: _toggleVoiceRecording,
                icon: Icon(
                  _isRecordingVoice ? Icons.stop_circle : (_hasRecordedVoice ? Icons.check_circle : Icons.mic_none_rounded),
                  color: _isRecordingVoice ? Colors.red : (_hasRecordedVoice ? AppColors.forestPrimary : AppColors.forestPrimary),
                ),
                label: Text(
                  _isRecordingVoice
                      ? 'Stop Recording Observation'
                      : (_hasRecordedVoice ? 'Voice Note Recorded ✓ (Tap to re-record)' : 'Speak Observation Voice Note'),
                  style: TextStyle(
                    color: _isRecordingVoice ? Colors.red : AppColors.forestPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: _isRecordingVoice ? Colors.red : AppColors.borderSoft),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),

              const SizedBox(height: 28),

              // Submit Button
              ElderButton(
                label: 'Save Observation & Adapt Next Pace',
                icon: Icons.check,
                variant: ElderButtonVariant.primary,
                height: 56,
                onPressed: _submitObservation,
              ),

              const SizedBox(height: 14),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComfortOption(String value, String label, IconData icon) {
    final isSelected = _comfortRating == value;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _comfortRating = value),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.forestPrimary : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.forestPrimary : AppColors.borderSoft,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 22, color: isSelected ? Colors.white : AppColors.forestPrimary),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationView(String patientName) {
    final isNoGame = RecommendationService.instance.isNoGameRecommended;

    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: AppColors.sageLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 52, color: AppColors.forestPrimary),
              ),
              const SizedBox(height: 22),

              const Text('Observation Saved Safely', style: AppTypography.patientHero, textAlign: TextAlign.center),
              const SizedBox(height: 10),

              Text(
                isNoGame
                    ? 'Because $patientName seemed tired or needed rest, the next journey is gently adapted to a soothing non-game experience (soft flute music & peaceful reminiscence).'
                    : 'Thank you. Next recommendations have been peacefully adapted based on your observations.',
                style: AppTypography.caregiverBody,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              CalmCard(
                backgroundColor: AppColors.surfaceWarm,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.sync_rounded, color: AppColors.forestPrimary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        FeedbackService.instance.isOffline
                            ? 'Saved locally on device (Offline queue synced when online).'
                            : 'Saved locally on device. Zero external cloud dependency.',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.forestDark),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              ElderButton(
                label: 'View Adapted Today’s Journey',
                icon: Icons.auto_awesome,
                variant: ElderButtonVariant.primary,
                height: 56,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.todaysJourney);
                },
              ),
              const SizedBox(height: 12),

              ElderButton(
                label: 'Go to Caregiver Dashboard',
                icon: Icons.dashboard_outlined,
                variant: ElderButtonVariant.secondary,
                height: 54,
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.caregiverDashboard);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
