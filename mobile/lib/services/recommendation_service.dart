import 'package:flutter/foundation.dart';
import '../models/activity_item.dart';
import '../models/ai_recommendation.dart';
import '../models/cognitive_domain.dart';
import 'mock_data_repository.dart';

/// Service managing AI recommendations, 6-domain support priorities,
/// simulation of multi-step processing states, and caregiver overrides.
class RecommendationService extends ChangeNotifier {
  static final RecommendationService instance = RecommendationService._internal();
  RecommendationService._internal();

  AiRecommendation? _currentRecommendation;
  bool _isProcessing = false;

  AiRecommendation? get currentRecommendation => _currentRecommendation;
  bool get isProcessing => _isProcessing;

  /// Simulates progressive AI analysis after caregiver onboarding
  Future<void> simulateAiAnalysis({
    required String patientId,
    AiProcessingStatus targetFinalStatus = AiProcessingStatus.ready,
  }) async {
    _isProcessing = true;
    
    // Stage 1: Preparing profile
    _currentRecommendation = AiRecommendation(
      patientId: patientId,
      generatedAt: DateTime.now(),
      status: AiProcessingStatus.preparing,
      sixDomainOverview: CognitiveDomain.defaultDomains,
      recommendedActivities: [],
      fallbackStarterActivities: MockDataRepository.getCatalogActivities().take(2).toList(),
      reasoningInfluences: const [
        'Organizing shared routine anchors',
        'Validating cultural music preferences',
      ],
      supportiveExplanation: 'Organizing the preferences and comfort needs you shared.',
    );
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1200));

    // Stage 2: Personalizing activities
    _currentRecommendation = _currentRecommendation!.copyWith(
      status: AiProcessingStatus.personalizing,
      supportiveExplanation: 'Finding gentle activities based on abilities, preferences, and routines.',
      reasoningInfluences: const [
        'Assam tea culture & gardening affinity',
        'Unhurried morning time anchor',
        'Preference for large text & soothing audio',
      ],
    );
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1400));

    // Final Stage
    final allActivities = MockDataRepository.getCatalogActivities();
    _currentRecommendation = _currentRecommendation!.copyWith(
      status: targetFinalStatus,
      recommendedActivities: allActivities.take(3).toList(),
      supportiveExplanation: targetFinalStatus == AiProcessingStatus.ready
          ? 'Today’s activities are ready. Selected to celebrate familiar memories with gentle, unpaced comfort.'
          : targetFinalStatus == AiProcessingStatus.delayedOffline
              ? 'Your profile is saved safely. We will use your information locally and update recommendations when connected.'
              : targetFinalStatus == AiProcessingStatus.insufficientInfo
                  ? 'Adding a few details about favorite music or morning routines will help personalize recommendations further.'
                  : 'We could not reach the recommendation service. Your saved data is safe, and gentle starter activities are ready.',
    );
    _isProcessing = false;
    notifyListeners();
  }

  /// Manually force a specific processing status for demo/testing purposes
  void setProcessingStatus(AiProcessingStatus status) {
    if (_currentRecommendation != null) {
      _currentRecommendation = _currentRecommendation!.copyWith(status: status);
      notifyListeners();
    }
  }

  /// Caregiver overrides support priority for a specific domain
  void overrideDomainPriority(CognitiveDomainType domainType, DomainSupportPriority newPriority) {
    if (_currentRecommendation == null) return;

    final updatedDomains = _currentRecommendation!.sixDomainOverview.map((domain) {
      if (domain.type == domainType) {
        return CognitiveDomain(
          type: domain.type,
          formalName: domain.formalName,
          patientFriendlyName: domain.patientFriendlyName,
          description: domain.description,
          icon: domain.icon,
          accentColor: domain.accentColor,
          priority: newPriority,
        );
      }
      return domain;
    }).toList();

    _currentRecommendation = _currentRecommendation!.copyWith(
      sixDomainOverview: updatedDomains,
      isOverriddenByCaregiver: true,
    );
    notifyListeners();
  }

  String _activeDifficulty = 'Gentle';
  String? _lastCaregiverMood;
  bool _isNoGameRecommended = false;
  String _gentleAlternativeTitle = 'Quiet River Soundscape & Memories';
  String _gentleAlternativeDescription = 'Rest gently by the sound of Tezpur river waters and look at beloved family photographs.';

  String get activeDifficulty => _activeDifficulty;
  String? get lastCaregiverMood => _lastCaregiverMood;
  bool get isNoGameRecommended => _isNoGameRecommended;
  String get gentleAlternativeTitle => _gentleAlternativeTitle;
  String get gentleAlternativeDescription => _gentleAlternativeDescription;

  /// Adapts recommendation when a caregiver provides session feedback
  void applyCaregiverObservation({
    required List<String> moodTags,
    String? recommendationPreference,
  }) {
    if (moodTags.isEmpty) return;
    _lastCaregiverMood = moodTags.first;

    final lowerMoods = moodTags.map((m) => m.toLowerCase()).toSet();

    if (lowerMoods.contains('tired') ||
        lowerMoods.contains('confused') ||
        lowerMoods.contains('frustrated') ||
        lowerMoods.contains('anxious') ||
        lowerMoods.contains('withdrawn') ||
        lowerMoods.contains('irritated') ||
        recommendationPreference == 'needs_rest' ||
        recommendationPreference == 'more_music') {
      // Gentle shift: suggest quiet connection, music, reminiscence or no game
      _activeDifficulty = 'Gentle';
      _isNoGameRecommended = true;
      _gentleAlternativeTitle = 'Gentle Flute & Veranda Rest';
      _gentleAlternativeDescription = 'Take a soothing pause with bamboo flute melodies, quiet conversation, and tea memories.';
    } else if (recommendationPreference == 'too_easy' || recommendationPreference == 'increase_challenge') {
      // Patient found it easy: adapt with a slightly higher focus / cognitive level
      _isNoGameRecommended = false;
      _activeDifficulty = 'Focus';
    } else if (recommendationPreference == 'too_hard' || recommendationPreference == 'gentler') {
      // Patient struggled: make simpler or switch domain
      _isNoGameRecommended = false;
      _activeDifficulty = 'Gentle';
    } else if (lowerMoods.contains('engaged') || lowerMoods.contains('calm')) {
      // Comfortable: normal cognitive engagement
      _isNoGameRecommended = false;
      _activeDifficulty = 'Standard';
    } else {
      _isNoGameRecommended = false;
      _activeDifficulty = 'Gentle';
    }

    notifyListeners();
  }

  void toggleNoGameRecommendation(bool enabled) {
    _isNoGameRecommended = enabled;
    notifyListeners();
  }

  /// Returns curated activities for Today's Journey based on caregiver presence and adaptive state
  List<ActivityItem> getTodaysJourneyActivities({required bool isCaregiverPresent}) {
    final catalog = MockDataRepository.getCatalogActivities();

    if (_isNoGameRecommended) {
      // Return calming connection activities (Look & Talk, Music & Memory, Story from Photo)
      return [
        catalog.firstWhere((a) => a.id == 'act_music_and_memory', orElse: () => catalog.first),
        catalog.firstWhere((a) => a.id == 'act_look_and_talk', orElse: () => catalog[1]),
        catalog.firstWhere((a) => a.id == 'act_story_from_photo', orElse: () => catalog[2]),
      ];
    }

    if (isCaregiverPresent) {
      // Prioritize Cognitive Together and Connection Together
      return [
        catalog.firstWhere((a) => a.id == 'act_family_match', orElse: () => catalog.first),
        catalog.firstWhere((a) => a.id == 'act_build_the_day', orElse: () => catalog[1]),
        catalog.firstWhere((a) => a.id == 'act_look_and_talk', orElse: () => catalog[2]),
        catalog.firstWhere((a) => a.id == 'act_music_and_memory', orElse: () => catalog[3]),
      ];
    } else {
      // Independent cognitive and gentle self-guided activities
      return [
        catalog.firstWhere((a) => a.id == 'act_remember_recall', orElse: () => catalog.first),
        catalog.firstWhere((a) => a.id == 'act_colour_word_focus', orElse: () => catalog[1]),
        catalog.firstWhere((a) => a.id == 'act_familiar_object_match', orElse: () => catalog[2]),
        catalog.firstWhere((a) => a.id == 'act_music_and_memory', orElse: () => catalog[3]),
      ];
    }
  }
}
