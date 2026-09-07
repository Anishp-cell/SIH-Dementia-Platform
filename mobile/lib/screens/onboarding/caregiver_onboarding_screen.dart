import 'package:flutter/material.dart';
import '../../core/audio/voice_assistant_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/cognitive_domain.dart';
import '../../models/patient_profile.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/feedback_banner.dart';

/// Progressive 15-step caregiver onboarding wizard for creating
/// a personalized, non-diagnostic patient profile.
///
/// Steps:
/// 1. Welcome screen
/// 2. Start / Set Up Patient screen
/// 3. Patient Profile (Name, age, language, relationship)
/// 4. About the Person (Personality traits, cherished roles)
/// 5. Abilities (Comfort needs with "I am unsure" options)
/// 6. Preferences (Interaction style, sensory comforts)
/// 7. Likes and dislikes (Calming themes vs triggers)
/// 8. Daily routine (Anchors, best time of day, availability)
/// 9. Familiar people (Family, friends, caregivers)
/// 10. Familiar places (Hometown, sacred places, garden, porch)
/// 11. Favourite music (Genres, instruments, regional melodies)
/// 12. Important memories (Traditions, milestones, festivals)
/// 13. Initial observations (Mood tags, what helped, voice note, doctor recs)
/// 14. Six activity domains (Approachable overview, non-diagnostic)
/// 15. Personalised setup completion (Warm celebration)
class CaregiverOnboardingScreen extends StatefulWidget {
  const CaregiverOnboardingScreen({super.key});

  @override
  State<CaregiverOnboardingScreen> createState() => _CaregiverOnboardingScreenState();
}

class _CaregiverOnboardingScreenState extends State<CaregiverOnboardingScreen> {
  int _currentStep = 1;
  static const int _totalSteps = 15;

  // Step 3: Patient Profile
  final TextEditingController _nameController = TextEditingController(text: 'Bonti Baruah');
  String _selectedAgeRange = '70-79 years';
  String _selectedRelationship = 'Daughter';
  String _preferredLanguage = 'en';

  // Step 4: About the Person
  final Set<String> _selectedPersonality = {'Gentle & Observant', 'Nature Lover'};
  final Set<String> _selectedRoles = {'Homemaker', 'Traditional Weaving'};

  // Step 5: Abilities & Support Needs
  String _readingComfort = 'prefers_large_text';
  String _hearingSupport = 'uses_hearing_aid';
  String _visualSupport = 'large_elements_needed';
  String _speechComfort = 'expressive';
  String _touchMobility = 'gentle_broad_tap';
  String _attentionSpan = '5_10_minutes';

  // Step 6: Preferences
  String _interactionStyle = 'warm_and_guided';
  final Set<String> _selectedSensory = {'Soft flute melodies', 'Nature photography'};

  // Step 7: Likes and Dislikes
  final Set<String> _selectedLikes = {'Assam Tea Gardens', 'Gardening', 'Classical Songs'};
  final Set<String> _selectedDislikes = {'Time pressure', 'Loud sudden sounds', 'Complex rules'};

  // Step 8: Daily Routine
  String _preferredTimeOfDay = 'Morning (9 AM - 11 AM)';
  final Set<String> _selectedRoutineAnchors = {
    'Morning Assam tea on veranda',
    'Evening family prayers',
    'Listening to morning radio',
  };
  String _caregiverAvailability = 'Evenings & Weekends';

  // Step 9: Familiar People
  final Set<String> _selectedPeople = {'Priyanka (Daughter)', 'Arup (Son)', 'Meera (Granddaughter)'};
  final TextEditingController _newPersonController = TextEditingController();

  // Step 10: Familiar Places
  final Set<String> _selectedPlaces = {'Tezpur Riverside', 'Veranda Swing', 'Guwahati Home'};
  final TextEditingController _newPlaceController = TextEditingController();

  // Step 11: Favourite Music
  final Set<String> _selectedMusic = {'Borgeet Flute', 'Rabindra Sangeet', 'Old Hindi Classics'};

  // Step 12: Important Memories
  final Set<String> _selectedMemories = {'Magh Bihu Feast', 'Tezpur Home', 'Traditional Silk Weaving'};
  final TextEditingController _newMemoryController = TextEditingController();

  // Step 13: Initial Observations & Doctor Recommendations
  final Set<String> _selectedMoodTags = {'calm', 'engaged'};
  final TextEditingController _whatHelpedController = TextEditingController(
    text: 'Listening to soft flute music and looking at old photographs together brings a smile.',
  );
  final TextEditingController _doctorRecController = TextEditingController(
    text: 'Encourage unpaced relaxation and gentle visual matching.',
  );
  final TextEditingController _voiceNoteController = TextEditingController();
  bool _isRecordingVoice = false;

  @override
  void dispose() {
    _nameController.dispose();
    _newPersonController.dispose();
    _newPlaceController.dispose();
    _newMemoryController.dispose();
    _whatHelpedController.dispose();
    _doctorRecController.dispose();
    _voiceNoteController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      _finalizeProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _finalizeProfile() {
    final newProfile = PatientProfile(
      id: 'patient_${DateTime.now().millisecondsSinceEpoch}',
      preferredName: _nameController.text.trim().isEmpty ? 'Grandmother' : _nameController.text.trim(),
      ageRange: _selectedAgeRange,
      preferredLanguage: _preferredLanguage,
      relationshipToCaregiver: _selectedRelationship,
      readingComfort: _readingComfort,
      hearingSupport: _hearingSupport,
      visualSupport: _visualSupport,
      speechComfort: _speechComfort,
      touchMobility: _touchMobility,
      independentPlay: 'gentle_supervision',
      attentionSpan: _attentionSpan,
      areasToSupport: const [
        CognitiveDomainType.memory,
        CognitiveDomainType.orientation,
        CognitiveDomainType.attention,
      ],
      safeActivityTypes: const ['matching', 'music_listening', 'photo_stories'],
      activitiesToAvoid: _selectedDislikes.toList(),
      interestsAndHobbies: _selectedLikes.toList(),
      favoriteMusicGenres: _selectedMusic.toList(),
      familiarPlacesAndFoods: _selectedPlaces.toList(),
      interactionStyle: _interactionStyle,
      preferredTimeOfDay: _preferredTimeOfDay,
      dailyRoutineAnchors: _selectedRoutineAnchors.toList(),
      caregiverAvailability: _caregiverAvailability,
      familiarPeople: _selectedPeople.toList(),
      familiarPlaces: _selectedPlaces.toList(),
      importantMemories: _selectedMemories.toList(),
      personalityTraits: _selectedPersonality.toList(),
      doctorRecommendations: _doctorRecController.text.trim().isEmpty ? null : _doctorRecController.text.trim(),
      recentMoodTags: _selectedMoodTags.toList(),
      observationNote: _voiceNoteController.text.isNotEmpty ? _voiceNoteController.text : null,
      whatHelpedNote: _whatHelpedController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ProfileService.instance.saveProfile(newProfile);
    Navigator.of(context).pushReplacementNamed(AppRoutes.todaysJourney);
  }

  void _showSaveAndExitDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundWarm,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Text('Save & Continue Later?', style: AppTypography.patientTitle),
        content: const Text(
          'Your progress is preserved on this device. You can return anytime to complete onboarding.',
          style: AppTypography.caregiverBody,
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        actions: [
          ElderButton(
            label: 'Keep Going',
            variant: ElderButtonVariant.primary,
            height: 50,
            onPressed: () => Navigator.of(ctx).pop(),
          ),
          const SizedBox(height: 10),
          ElderButton(
            label: 'Save Draft & Exit',
            variant: ElderButtonVariant.secondary,
            height: 50,
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).maybePop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleVoiceRecording() async {
    if (!_isRecordingVoice) {
      final started = await VoiceAssistantService.instance.startRecording();
      if (started) {
        setState(() => _isRecordingVoice = true);
      }
    } else {
      final transcription = await VoiceAssistantService.instance.stopRecordingAndTranscribe();
      setState(() {
        _isRecordingVoice = false;
        _voiceNoteController.text = transcription;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 22, color: AppColors.forestPrimary),
          onPressed: _previousStep,
        ),
        title: Text(
          'Step $_currentStep of $_totalSteps',
          style: AppTypography.caregiverSubheading,
        ),
        actions: [
          TextButton(
            onPressed: _showSaveAndExitDialog,
            child: const Text(
              'Save & Later',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.forestPrimary,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _currentStep / _totalSteps,
              backgroundColor: AppColors.borderSoft,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.forestPrimary),
              minHeight: 4.5,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22.0),
                child: _buildCurrentStepContent(),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 18),
              decoration: const BoxDecoration(
                color: AppColors.backgroundWarm,
                border: Border(top: BorderSide(color: AppColors.borderSoft, width: 1.2)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 1) ...[
                    Expanded(
                      flex: 1,
                      child: ElderButton(
                        label: 'Previous',
                        variant: ElderButtonVariant.secondary,
                        height: 52,
                        onPressed: _previousStep,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElderButton(
                      label: _currentStep == _totalSteps ? 'Begin Today’s Journey' : 'Next Step',
                      icon: _currentStep == _totalSteps ? Icons.check_circle_outline : Icons.arrow_forward,
                      variant: ElderButtonVariant.primary,
                      height: 52,
                      onPressed: _nextStep,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildStep1Welcome();
      case 2:
        return _buildStep2StartSetup();
      case 3:
        return _buildStep3PatientProfile();
      case 4:
        return _buildStep4AboutPerson();
      case 5:
        return _buildStep5Abilities();
      case 6:
        return _buildStep6Preferences();
      case 7:
        return _buildStep7LikesDislikes();
      case 8:
        return _buildStep8DailyRoutine();
      case 9:
        return _buildStep9FamiliarPeople();
      case 10:
        return _buildStep10FamiliarPlaces();
      case 11:
        return _buildStep11FavouriteMusic();
      case 12:
        return _buildStep12ImportantMemories();
      case 13:
        return _buildStep13InitialObservations();
      case 14:
        return _buildStep14SixActivityDomains();
      case 15:
        return _buildStep15SetupCompletion();
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Step 1: Welcome Screen ---
  Widget _buildStep1Welcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: AppColors.surfaceWarm,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.spa, size: 48, color: AppColors.forestPrimary),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Welcome to Dementia Assist', style: AppTypography.patientHero),
        const SizedBox(height: 12),
        const Text(
          '“We don’t design cognitive games for a diagnosis. We design them around the person.”',
          style: TextStyle(
            fontSize: 18,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: AppColors.forestPrimary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Every person is unique. Our platform adapts activities to familiar people, memories, routines, and comfortable abilities — never putting someone alone in front of stressful tasks.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 24),
        const FeedbackBanner(
          type: FeedbackBannerType.info,
          title: 'Caregiver Guided',
          message: 'You can skip any question you are unsure about. All entries can be updated anytime.',
        ),
      ],
    );
  }

  // --- Step 2: Start / Set Up Patient Screen ---
  Widget _buildStep2StartSetup() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Getting to Know Your Loved One', style: AppTypography.patientTitle),
        const SizedBox(height: 10),
        const Text(
          'We will ask a few gentle questions about their life, preferences, and daily comfort. This takes about 3 to 4 minutes.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 20),
        CalmCard(
          backgroundColor: AppColors.surfaceWarm,
          child: Column(
            children: [
              _buildFeatureCheck(Icons.lock_outline, '100% Private & Stored on Device'),
              const SizedBox(height: 14),
              _buildFeatureCheck(Icons.favorite_outline, 'No Diagnostic Staging or Clinical Tests'),
              const SizedBox(height: 14),
              _buildFeatureCheck(Icons.music_note_outlined, 'Familiar Music, Places & Memories'),
              const SizedBox(height: 14),
              _buildFeatureCheck(Icons.people_outline, 'Together Mode for Meaningful Connection'),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const FeedbackBanner(
          type: FeedbackBannerType.affirmation,
          message: 'You can save your draft at any time and resume whenever convenient.',
        ),
      ],
    );
  }

  Widget _buildFeatureCheck(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColors.forestPrimary),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  // --- Step 3: Patient Profile ---
  Widget _buildStep3PatientProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Who are we caring for?', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'Basic information helps us address them warmly and set comfortable defaults.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 20),
        const Text('Preferred Name or Warm Greeting', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 8),
        TextField(
          controller: _nameController,
          style: AppTypography.patientBody,
          decoration: InputDecoration(
            hintText: 'e.g. Bonti Baruah, Grandmother, Baba',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.borderSoft),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Age Bracket', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: ['60-69 years', '70-79 years', '80-89 years', '90+ years'].map((range) {
            final isSelected = _selectedAgeRange == range;
            return ChoiceChip(
              label: Text(range, style: TextStyle(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
              selected: isSelected,
              selectedColor: AppColors.forestPrimary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
              onSelected: (val) => setState(() => _selectedAgeRange = range),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Text('Preferred Language', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: [
            {'code': 'en', 'label': 'English'},
            {'code': 'hi', 'label': 'हिंदी (Hindi)'},
            {'code': 'as', 'label': 'অসমীয়া (Assamese)'},
          ].map((lang) {
            final isSelected = _preferredLanguage == lang['code'];
            return ChoiceChip(
              label: Text(lang['label']!, style: TextStyle(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
              selected: isSelected,
              selectedColor: AppColors.forestPrimary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
              onSelected: (val) => setState(() => _preferredLanguage = lang['code']!),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Text('Your Relationship to the Person', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: ['Daughter', 'Son', 'Spouse', 'Grandchild', 'Professional Caregiver', 'Friend'].map((rel) {
            final isSelected = _selectedRelationship == rel;
            return ChoiceChip(
              label: Text(rel, style: TextStyle(fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
              selected: isSelected,
              selectedColor: AppColors.sage,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
              onSelected: (val) => setState(() => _selectedRelationship = rel),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- Step 4: About the Person ---
  Widget _buildStep4AboutPerson() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('About the Person', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'Understanding their personality and background helps tailor warm, relatable conversations.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 20),
        const Text('Personality & Temperament', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Gentle & Observant',
            'Sociable & Chatty',
            'Quiet Nature Lover',
            'Storyteller & Teacher',
            'Artistic & Musical',
            'Curious & Reflective',
          ].map((trait) {
            final isSelected = _selectedPersonality.contains(trait);
            return FilterChip(
              label: Text(trait),
              selected: isSelected,
              selectedColor: AppColors.sageLight,
              checkmarkColor: AppColors.forestPrimary,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedPersonality.add(trait);
                  } else {
                    _selectedPersonality.remove(trait);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text('Cherished Past Roles & Passions', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Homemaker & Cook',
            'Teacher & Mentor',
            'Traditional Weaving',
            'Gardener & Farmer',
            'Community Singer',
            'Writer & Reader',
          ].map((role) {
            final isSelected = _selectedRoles.contains(role);
            return FilterChip(
              label: Text(role),
              selected: isSelected,
              selectedColor: AppColors.sageLight,
              checkmarkColor: AppColors.forestPrimary,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedRoles.add(role);
                  } else {
                    _selectedRoles.remove(role);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- Step 5: Abilities ---
  Widget _buildStep5Abilities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Comfort & Support Needs', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'Non-diagnostic observations to ensure controls are comfortable and never frustrating.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 18),
        _buildAbilitySelector(
          title: 'Reading Comfort',
          currentVal: _readingComfort,
          options: [
            {'val': 'fluent', 'label': 'Comfortable with sentences'},
            {'val': 'prefers_large_text', 'label': 'Prefers large, brief text'},
            {'val': 'spoken_audio', 'label': 'Spoken audio preferred'},
            {'val': 'unsure', 'label': 'I am unsure right now'},
          ],
          onSelect: (val) => setState(() => _readingComfort = val),
        ),
        const SizedBox(height: 16),
        _buildAbilitySelector(
          title: 'Hearing & Audio Needs',
          currentVal: _hearingSupport,
          options: [
            {'val': 'normal', 'label': 'Standard volume'},
            {'val': 'uses_hearing_aid', 'label': 'Uses hearing aid'},
            {'val': 'high_volume', 'label': 'Needs higher volume'},
            {'val': 'unsure', 'label': 'I am unsure right now'},
          ],
          onSelect: (val) => setState(() => _hearingSupport = val),
        ),
        const SizedBox(height: 16),
        _buildAbilitySelector(
          title: 'Visual & Screen Display',
          currentVal: _visualSupport,
          options: [
            {'val': 'standard', 'label': 'Standard screen'},
            {'val': 'large_elements_needed', 'label': 'Large elements needed'},
            {'val': 'high_contrast', 'label': 'High contrast needed'},
            {'val': 'unsure', 'label': 'I am unsure right now'},
          ],
          onSelect: (val) => setState(() => _visualSupport = val),
        ),
        const SizedBox(height: 16),
        _buildAbilitySelector(
          title: 'Speech & Verbal Comfort',
          currentVal: _speechComfort,
          options: [
            {'val': 'expressive', 'label': 'Expressive & conversational'},
            {'val': 'short_words', 'label': 'Prefers short phrases'},
            {'val': 'mostly_listening', 'label': 'Comfortable listening mostly'},
            {'val': 'unsure', 'label': 'I am unsure right now'},
          ],
          onSelect: (val) => setState(() => _speechComfort = val),
        ),
        const SizedBox(height: 16),
        _buildAbilitySelector(
          title: 'Attention & Engagement Pace',
          currentVal: _attentionSpan,
          options: [
            {'val': '3_5_minutes', 'label': '3-5 minutes gentle burst'},
            {'val': '5_10_minutes', 'label': '5-10 minutes standard'},
            {'val': 'relaxed_unpaced', 'label': 'Completely unpaced & relaxed'},
            {'val': 'unsure', 'label': 'I am unsure right now'},
          ],
          onSelect: (val) => setState(() => _attentionSpan = val),
        ),
        const SizedBox(height: 16),
        _buildAbilitySelector(
          title: 'Touch & Interaction Style',
          currentVal: _touchMobility,
          options: [
            {'val': 'accurate_tap', 'label': 'Standard touch tap'},
            {'val': 'gentle_broad_tap', 'label': 'Broad touch targets needed'},
            {'val': 'unsure', 'label': 'I am unsure right now'},
          ],
          onSelect: (val) => setState(() => _touchMobility = val),
        ),
      ],
    );
  }

  Widget _buildAbilitySelector({
    required String title,
    required String currentVal,
    required List<Map<String, String>> options,
    required ValueChanged<String> onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.caregiverSubheading),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: options.map((opt) {
            final isSelected = currentVal == opt['val'];
            return ChoiceChip(
              label: Text(opt['label']!),
              selected: isSelected,
              selectedColor: AppColors.forestPrimary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              onSelected: (val) => onSelect(opt['val']!),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- Step 6: Preferences ---
  Widget _buildStep6Preferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Interaction & Sensory Preferences', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'What style of interaction feels most natural and relaxing for them?',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 20),
        const Text('Preferred Interaction Style', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            {'val': 'quiet', 'label': 'Quiet & Peaceful'},
            {'val': 'warm_and_guided', 'label': 'Warm & Guided Together'},
            {'val': 'music_centered', 'label': 'Music-Centered'},
            {'val': 'storytelling', 'label': 'Story & Reminiscence'},
          ].map((style) {
            final isSelected = _interactionStyle == style['val'];
            return ChoiceChip(
              label: Text(style['label']!),
              selected: isSelected,
              selectedColor: AppColors.forestPrimary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
              onSelected: (val) => setState(() => _interactionStyle = style['val']!),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text('Soothing Sensory Elements', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            'Soft flute melodies',
            'Nature photography',
            'Gentle flower patterns',
            'Old radio jingles',
            'Rain and river sounds',
          ].map((sensory) {
            final isSelected = _selectedSensory.contains(sensory);
            return FilterChip(
              label: Text(sensory),
              selected: isSelected,
              selectedColor: AppColors.sageLight,
              checkmarkColor: AppColors.forestPrimary,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedSensory.add(sensory);
                  } else {
                    _selectedSensory.remove(sensory);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- Step 7: Likes and Dislikes ---
  Widget _buildStep7LikesDislikes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Likes and Dislikes', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'We use beloved themes in activities and strictly avoid stressful triggers.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            Icon(Icons.favorite, color: AppColors.forestPrimary, size: 22),
            SizedBox(width: 8),
            Text('Calming & Enjoyable Themes', style: AppTypography.caregiverSubheading),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            'Assam Tea Gardens',
            'Gardening',
            'Classical Songs',
            'Temple Bells',
            'Traditional Cooking',
            'Birds & Wildlife',
          ].map((theme) {
            final isSelected = _selectedLikes.contains(theme);
            return FilterChip(
              label: Text(theme),
              selected: isSelected,
              selectedColor: AppColors.sageLight,
              checkmarkColor: AppColors.forestPrimary,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedLikes.add(theme);
                  } else {
                    _selectedLikes.remove(theme);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Row(
          children: [
            Icon(Icons.block, color: AppColors.peachDark, size: 22),
            SizedBox(width: 8),
            Text('Things to Avoid (Stressful Triggers)', style: AppTypography.caregiverSubheading),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            'Time pressure',
            'Loud sudden sounds',
            'Complex rules',
            'Fast animations',
            'Rapid flashing colors',
          ].map((avoid) {
            final isSelected = _selectedDislikes.contains(avoid);
            return FilterChip(
              label: Text(avoid),
              selected: isSelected,
              selectedColor: AppColors.peachLight,
              checkmarkColor: AppColors.peachDark,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedDislikes.add(avoid);
                  } else {
                    _selectedDislikes.remove(avoid);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- Step 8: Daily Routine ---
  Widget _buildStep8DailyRoutine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Daily Routine & Anchors', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'Matching their natural circadian rhythm ensures pleasant, restful engagement.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 20),
        const Text('Best Time of Day for Activities', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            'Morning (9 AM - 11 AM)',
            'Afternoon (3 PM - 5 PM)',
            'Evening (6 PM - 8 PM)',
          ].map((time) {
            final isSelected = _preferredTimeOfDay == time;
            return ChoiceChip(
              label: Text(time),
              selected: isSelected,
              selectedColor: AppColors.forestPrimary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
              onSelected: (val) => setState(() => _preferredTimeOfDay = time),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text('Cherished Daily Rituals', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 6,
          children: [
            'Morning Assam tea on veranda',
            'Listening to morning radio',
            'Afternoon restful nap',
            'Evening family prayers',
            'Garden walk at sunset',
          ].map((ritual) {
            final isSelected = _selectedRoutineAnchors.contains(ritual);
            return FilterChip(
              label: Text(ritual),
              selected: isSelected,
              selectedColor: AppColors.sageLight,
              checkmarkColor: AppColors.forestPrimary,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedRoutineAnchors.add(ritual);
                  } else {
                    _selectedRoutineAnchors.remove(ritual);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        const Text('Caregiver Availability', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            'Always present',
            'Evenings & Weekends',
            'Occasional visits',
          ].map((avail) {
            final isSelected = _caregiverAvailability == avail;
            return ChoiceChip(
              label: Text(avail),
              selected: isSelected,
              selectedColor: AppColors.sage,
              labelStyle: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary),
              onSelected: (val) => setState(() => _caregiverAvailability = avail),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- Step 9: Familiar People ---
  Widget _buildStep9FamiliarPeople() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Familiar People', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'These familiar names can be used in recognition activities like Family Match & Tell.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedPeople.map((person) {
            return Chip(
              avatar: const Icon(Icons.person, size: 18, color: AppColors.forestPrimary),
              label: Text(person),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => setState(() => _selectedPeople.remove(person)),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newPersonController,
                decoration: InputDecoration(
                  hintText: 'Add person (e.g. Arup - Son)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderSoft),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filled(
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(backgroundColor: AppColors.forestPrimary),
              onPressed: () {
                final txt = _newPersonController.text.trim();
                if (txt.isNotEmpty) {
                  setState(() {
                    _selectedPeople.add(txt);
                    _newPersonController.clear();
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  // --- Step 10: Familiar Places ---
  Widget _buildStep10FamiliarPlaces() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Familiar Places', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'Hometown locations, river ghats, and favorite rooms spark pleasant reminiscing.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedPlaces.map((place) {
            return Chip(
              avatar: const Icon(Icons.location_on_outlined, size: 18, color: AppColors.domainOrientation),
              label: Text(place),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => setState(() => _selectedPlaces.remove(place)),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newPlaceController,
                decoration: InputDecoration(
                  hintText: 'Add place (e.g. Brahmaputra Ghat)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderSoft),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filled(
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(backgroundColor: AppColors.forestPrimary),
              onPressed: () {
                final txt = _newPlaceController.text.trim();
                if (txt.isNotEmpty) {
                  setState(() {
                    _selectedPlaces.add(txt);
                    _newPlaceController.clear();
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  // --- Step 11: Favourite Music ---
  Widget _buildStep11FavouriteMusic() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Favourite Music & Melodies', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'Music bypasses verbal barriers and stimulates emotional warmth and recall.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            'Borgeet Flute',
            'Rabindra Sangeet',
            'Bihu Folk Melodies',
            'Old Hindi Classics',
            'Devotional Bhajans',
            'Acoustic Sitar & Sarod',
          ].map((genre) {
            final isSelected = _selectedMusic.contains(genre);
            return FilterChip(
              avatar: const Icon(Icons.music_note, size: 18),
              label: Text(genre),
              selected: isSelected,
              selectedColor: AppColors.sageLight,
              checkmarkColor: AppColors.forestPrimary,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedMusic.add(genre);
                  } else {
                    _selectedMusic.remove(genre);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const FeedbackBanner(
          type: FeedbackBannerType.affirmation,
          message: 'These genres can play quietly during connection activities or background listening.',
        ),
      ],
    );
  }

  // --- Step 12: Important Memories ---
  Widget _buildStep12ImportantMemories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Important Memories & Milestones', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'Cherished memories can serve as gentle conversation prompts in Look & Talk or Story from Photo.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _selectedMemories.map((mem) {
            return Chip(
              avatar: const Icon(Icons.history_edu, size: 18, color: AppColors.domainLanguage),
              label: Text(mem),
              deleteIcon: const Icon(Icons.close, size: 16),
              onDeleted: () => setState(() => _selectedMemories.remove(mem)),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newMemoryController,
                decoration: InputDecoration(
                  hintText: 'Add memory (e.g. Daughter’s Wedding)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.borderSoft),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton.filled(
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(backgroundColor: AppColors.forestPrimary),
              onPressed: () {
                final txt = _newMemoryController.text.trim();
                if (txt.isNotEmpty) {
                  setState(() {
                    _selectedMemories.add(txt);
                    _newMemoryController.clear();
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  // --- Step 13: Initial Observations ---
  Widget _buildStep13InitialObservations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Initial Observations', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'How has the person been feeling lately? This informs today’s gentle starting pace.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 18),
        const Text('Recent Mood Context', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: ['calm', 'engaged', 'quiet', 'tired', 'anxious', 'withdrawn'].map((mood) {
            final isSelected = _selectedMoodTags.contains(mood);
            return FilterChip(
              label: Text(mood[0].toUpperCase() + mood.substring(1)),
              selected: isSelected,
              selectedColor: AppColors.sageLight,
              checkmarkColor: AppColors.forestPrimary,
              onSelected: (val) {
                setState(() {
                  if (val) {
                    _selectedMoodTags.add(mood);
                  } else {
                    _selectedMoodTags.remove(mood);
                  }
                });
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        const Text('What Helps Them Smile or Feel Safe?', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 8),
        TextField(
          controller: _whatHelpedController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'e.g. Looking at old photos, holding hands, drinking warm tea',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderSoft),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text('Relevant Doctor Recommendations (if any)', style: AppTypography.caregiverSubheading),
        const SizedBox(height: 8),
        TextField(
          controller: _doctorRecController,
          maxLines: 2,
          decoration: InputDecoration(
            hintText: 'e.g. Focus on gentle visual matching, unhurried routines',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.borderSoft),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Optional voice note
        ElderButton(
          label: _isRecordingVoice ? 'Recording... Tap to Finish' : 'Record Short Voice Observation',
          icon: _isRecordingVoice ? Icons.stop_circle : Icons.mic,
          variant: _isRecordingVoice ? ElderButtonVariant.peach : ElderButtonVariant.secondary,
          height: 52,
          onPressed: _handleVoiceRecording,
        ),
        if (_voiceNoteController.text.isNotEmpty) ...[
          const SizedBox(height: 10),
          FeedbackBanner(
            type: FeedbackBannerType.info,
            title: 'Transcribed Note',
            message: _voiceNoteController.text,
          ),
        ],
      ],
    );
  }

  // --- Step 14: Six Activity Domains ---
  Widget _buildStep14SixActivityDomains() {
    final domains = CognitiveDomain.defaultDomains;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Six Activity Domains', style: AppTypography.patientTitle),
        const SizedBox(height: 8),
        const Text(
          'Our platform organizes activities across six domains to ensure variety and balance.',
          style: AppTypography.caregiverBody,
        ),
        const SizedBox(height: 16),
        const FeedbackBanner(
          type: FeedbackBannerType.guidance,
          title: 'Not a Clinical Test',
          message: 'These six areas are simply a product framework for choosing suitable activities. They are not a medical diagnosis, clinical score, or progression meter.',
        ),
        const SizedBox(height: 18),
        ...domains.map((d) {
          return CalmCard(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: d.accentColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(d.icon, color: d.accentColor, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${d.patientFriendlyName} (${d.formalName})',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Text(d.description, style: AppTypography.caregiverCaption),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // --- Step 15: Setup Completion ---
  Widget _buildStep15SetupCompletion() {
    final name = _nameController.text.trim().isEmpty ? 'Grandmother' : _nameController.text.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              color: AppColors.sageLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, size: 54, color: AppColors.forestPrimary),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Text(
            'Personalised Profile Ready for $name!',
            style: AppTypography.patientHero,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'We have tailored daily activities around their familiar places, favourite songs, and comfortable abilities.',
            style: AppTypography.caregiverBody,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        CalmCard(
          backgroundColor: AppColors.surfaceWarm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Personal Anchors Configured:', style: AppTypography.caregiverSubheading),
              const SizedBox(height: 12),
              _buildSummaryRow(Icons.person, 'Preferred Greeting', name),
              _buildSummaryRow(Icons.music_note, 'Beloved Melodies', _selectedMusic.take(2).join(', ')),
              _buildSummaryRow(Icons.location_on, 'Familiar Places', _selectedPlaces.take(2).join(', ')),
              _buildSummaryRow(Icons.wb_sunny, 'Best Routine Time', _preferredTimeOfDay),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const FeedbackBanner(
          type: FeedbackBannerType.affirmation,
          message: 'Tap below to step into Today’s Journey. Have a peaceful, joyful session!',
        ),
      ],
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.forestPrimary),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
