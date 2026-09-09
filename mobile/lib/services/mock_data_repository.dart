import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/navigation/app_routes.dart';
import '../models/activity_item.dart';
import '../models/caregiver_feedback.dart';
import '../models/cognitive_domain.dart';
import '../models/dashboard_data.dart';
import '../models/memory_item.dart';
import '../models/patient_profile.dart';

/// Rich mock data repository infused with authentic North Eastern Indian
/// and familiar cultural anchors (Assam tea gardens, folk melodies, regional crafts).
class MockDataRepository {
  MockDataRepository._();

  static PatientProfile createSamplePatient() {
    return PatientProfile(
      id: 'patient_bonti_01',
      preferredName: 'Bonti Baruah',
      ageRange: '70-75 years',
      preferredLanguage: 'en',
      relationshipToCaregiver: 'Daughter (Priyanka)',
      profilePhotoUrl: null,
      readingComfort: 'prefers_large_text',
      hearingSupport: 'uses_hearing_aid',
      visualSupport: 'large_elements_needed',
      speechComfort: 'expressive',
      touchMobility: 'gentle_broad_tap',
      independentPlay: 'gentle_supervision',
      attentionSpan: '5_10_minutes',
      areasToSupport: const [
        CognitiveDomainType.memory,
        CognitiveDomainType.orientation,
        CognitiveDomainType.attention,
      ],
      safeActivityTypes: const [
        'matching_nature',
        'music_listening',
        'photo_conversation',
        'routine_sorting'
      ],
      activitiesToAvoid: const ['time_pressure', 'rapid_flashing'],
      interestsAndHobbies: const [
        'Assam Tea Gardens',
        'Traditional Weaving',
        'Morning Garden Walks',
        'Rabindra Sangeet'
      ],
      favoriteMusicGenres: const [
        'Borgeet Flute',
        'Rabindra Sangeet',
        'Old Hindi Classics'
      ],
      familiarPlacesAndFoods: const [
        'Tezpur Ghats',
        'Assam Chai',
        'Pitha & Laru',
        'Veranda Swing'
      ],
      interactionStyle: 'warm_and_guided',
      preferredTimeOfDay: 'Morning (9 AM - 11 AM)',
      dailyRoutineAnchors: const [
        'Morning Assam tea on veranda',
        'Listening to morning radio',
        'Evening family prayers'
      ],
      caregiverAvailability: 'Evenings & Weekends',
      recentMoodTags: const ['calm', 'engaged'],
      observationNote: 'Smiles warmly when hearing familiar songs from Tezpur.',
      whatHelpedNote: 'Allowing unhurried time to touch and explore each card.',
      createdAt: DateTime.now().subtract(const Duration(days: 14)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 3)),
    );
  }

  static List<ActivityItem> getCatalogActivities() {
    return [
      // 1. Look & Talk (Connection Together)
      const ActivityItem(
        id: 'act_look_and_talk',
        title: 'Look & Talk — Cherished Photos',
        patientFriendlyTitle: 'Look & Talk',
        subtitle: 'Browse familiar memories and share peaceful stories together.',
        domain: CognitiveDomainType.memory,
        modality: ActivityModality.connectionTogether,
        difficultyLabel: 'Comfort',
        estimatedDurationMinutes: 5,
        requiresCaregiver: false,
        supportsPersonalizedMedia: true,
        supportsAudioGuidance: true,
        culturalTags: ['Tezpur Veranda', 'Graduation Sari', 'Family Garden'],
        icon: Icons.photo_camera_back_outlined,
        themeColor: AppColors.domainMemory,
        routeName: AppRoutes.lookAndTalk,
      ),

      // 2. Music & Memory (Connection Together)
      const ActivityItem(
        id: 'act_music_and_memory',
        title: 'Music & Memory — Soothing Melodies',
        patientFriendlyTitle: 'Heartfelt Melodies',
        subtitle: 'Relax with soothing flute music, morning ragas, and nostalgic tunes.',
        domain: CognitiveDomainType.language,
        modality: ActivityModality.connectionTogether,
        difficultyLabel: 'Relaxed',
        estimatedDurationMinutes: 6,
        requiresCaregiver: false,
        supportsPersonalizedMedia: true,
        supportsAudioGuidance: true,
        culturalTags: ['Borgeet Flute', 'Rabindra Sangeet', 'Old Classics'],
        icon: Icons.music_note_outlined,
        themeColor: AppColors.domainLanguage,
        routeName: AppRoutes.musicAndMemory,
      ),

      // 3. Story from Photo (Connection Together)
      const ActivityItem(
        id: 'act_story_from_photo',
        title: 'Story from Photo — Shared Reminiscence',
        patientFriendlyTitle: 'Story from Photo',
        subtitle: 'Look at a warm picture and tell a gentle story at your own pace.',
        domain: CognitiveDomainType.language,
        modality: ActivityModality.connectionTogether,
        difficultyLabel: 'Unhurried',
        estimatedDurationMinutes: 5,
        requiresCaregiver: true,
        supportsPersonalizedMedia: true,
        supportsAudioGuidance: true,
        culturalTags: ['Magh Bihu', 'Til Pitha', 'River Ghats'],
        icon: Icons.auto_stories_outlined,
        themeColor: AppColors.forestPrimary,
        routeName: AppRoutes.storyFromPhoto,
      ),

      // 4. Family Match & Tell (Cognitive / Together)
      const ActivityItem(
        id: 'act_family_match',
        title: 'Family Match & Tell',
        patientFriendlyTitle: 'Family Photos Together',
        subtitle: 'Turn gentle cards to find matching family photos and share sweet memories.',
        domain: CognitiveDomainType.memory,
        modality: ActivityModality.cognitiveTogether,
        difficultyLabel: 'Gentle Guided',
        estimatedDurationMinutes: 5,
        requiresCaregiver: true,
        supportsPersonalizedMedia: true,
        supportsAudioGuidance: true,
        culturalTags: ['Priyanka', 'Aarav', 'Tezpur Home'],
        icon: Icons.people_outline,
        themeColor: AppColors.domainMemory,
        routeName: AppRoutes.familyMatch,
      ),

      // 5. Build the Day Together (Cognitive / Together)
      const ActivityItem(
        id: 'act_build_the_day',
        title: 'Build the Day Together',
        patientFriendlyTitle: 'Daily Morning Rhythm',
        subtitle: 'Gently arrange everyday morning moments in a peaceful sequence.',
        domain: CognitiveDomainType.executive,
        modality: ActivityModality.cognitiveTogether,
        difficultyLabel: 'Gentle Sequence',
        estimatedDurationMinutes: 4,
        requiresCaregiver: true,
        supportsPersonalizedMedia: true,
        supportsAudioGuidance: true,
        culturalTags: ['Morning Tea', 'Veranda', 'Radio', 'Evening Prayers'],
        icon: Icons.wb_sunny_outlined,
        themeColor: AppColors.domainExecutive,
        routeName: AppRoutes.buildTheDay,
      ),

      // 6. Familiar Object Match (Cognitive / Together)
      const ActivityItem(
        id: 'act_familiar_object_match',
        title: 'Heritage & Crafts Match',
        patientFriendlyTitle: 'Familiar Object Match',
        subtitle: 'Explore and match familiar traditional crafts, brass lamps, and tea leaves.',
        domain: CognitiveDomainType.visuospatial,
        modality: ActivityModality.cognitiveTogether,
        difficultyLabel: 'Gentle',
        estimatedDurationMinutes: 3,
        requiresCaregiver: false,
        supportsPersonalizedMedia: false,
        supportsAudioGuidance: true,
        culturalTags: ['Tea Leaves', 'Diya Lamp', 'Gamosa', 'Japi Hat'],
        icon: Icons.filter_vintage_outlined,
        themeColor: AppColors.domainVisuospatial,
        routeName: AppRoutes.familiarObjectMatch,
      ),

      // 7. Remember & Recall (Independent Cognitive)
      const ActivityItem(
        id: 'act_remember_recall',
        title: 'Remember & Recall — Peaceful Memory',
        patientFriendlyTitle: 'Look, Rest & Remember',
        subtitle: 'Look at gentle familiar items, pause peacefully, and recall them with no rush.',
        domain: CognitiveDomainType.orientation,
        modality: ActivityModality.independent,
        difficultyLabel: 'Calm Pace',
        estimatedDurationMinutes: 4,
        requiresCaregiver: false,
        supportsPersonalizedMedia: true,
        supportsAudioGuidance: true,
        culturalTags: ['Tea Kettle', 'Reading Glasses', 'Prayer Bell'],
        icon: Icons.psychology_outlined,
        themeColor: AppColors.domainOrientation,
        routeName: AppRoutes.rememberRecall,
      ),

      // 8. Colour–Word Focus (Independent Cognitive)
      const ActivityItem(
        id: 'act_colour_word_focus',
        title: 'Colour–Word Focus — Gentle Attention',
        patientFriendlyTitle: 'Gentle Focus & Touch',
        subtitle: 'An accessible matching experience pairing colors, symbols, and nature.',
        domain: CognitiveDomainType.attention,
        modality: ActivityModality.independent,
        difficultyLabel: 'Gentle Touch',
        estimatedDurationMinutes: 3,
        requiresCaregiver: false,
        supportsPersonalizedMedia: false,
        supportsAudioGuidance: true,
        culturalTags: ['Golden Sun', 'Tea Leaf Green', 'Sky Blue', 'Lotus Rose'],
        icon: Icons.center_focus_strong_outlined,
        themeColor: AppColors.domainAttention,
        routeName: AppRoutes.colourWordFocus,
      ),
    ];
  }

  static List<MemoryItem> getSampleMemories() {
    return [
      MemoryItem(
        id: 'mem_01',
        title: 'Grandmother’s Veranda in Tezpur',
        type: MemoryType.place,
        relationOrContext: 'Where she loved having morning ginger chai looking at the garden.',
        iconOrImagePath: 'assets/images/veranda.jpg',
        tags: ['Home', 'Tezpur', 'Garden'],
        allowedUsage: ['recognition', 'conversation'],
        dateAdded: DateTime.now().subtract(const Duration(days: 10)),
      ),
      MemoryItem(
        id: 'mem_02',
        title: 'Priyanka’s College Graduation',
        type: MemoryType.photo,
        relationOrContext: 'With granddaughter Priyanka wearing the muga silk sari.',
        iconOrImagePath: 'assets/images/graduation.jpg',
        tags: ['Family', 'Milestone', 'Priyanka'],
        allowedUsage: ['recognition', 'conversation'],
        dateAdded: DateTime.now().subtract(const Duration(days: 8)),
      ),
      MemoryItem(
        id: 'mem_03',
        title: 'Golden Assam Tea Harvest Song',
        type: MemoryType.music,
        relationOrContext: 'Traditional folk flute melody played during autumn.',
        tags: ['Music', 'Flute', 'Autumn'],
        allowedUsage: ['music_together', 'conversation'],
        dateAdded: DateTime.now().subtract(const Duration(days: 5)),
      ),
      MemoryItem(
        id: 'mem_04',
        title: 'Making Til Pitha on Magh Bihu',
        type: MemoryType.story,
        relationOrContext: 'Gathering around the kitchen fire in January to roll sweet sesame pithas.',
        tags: ['Festival', 'Bihu', 'Tradition'],
        allowedUsage: ['conversation'],
        dateAdded: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }

  static DashboardData getSampleDashboardData(String patientName) {
    return DashboardData(
      patientName: patientName,
      completedTodayCount: 2,
      targetDailyActivities: 3,
      pendingFeedbackCount: 1,
      recommendedNextActivities: getCatalogActivities().take(2).toList(),
      weeklyConsistency: const [
        DailyContextPoint(
          dayLabel: 'Mon',
          completedActivitiesCount: 2,
          engagementLevel: 4.2,
          primaryMood: 'calm',
          hadTogetherSession: true,
          hadMusicActivity: false,
        ),
        DailyContextPoint(
          dayLabel: 'Tue',
          completedActivitiesCount: 3,
          engagementLevel: 4.8,
          primaryMood: 'joyful',
          hadTogetherSession: true,
          hadMusicActivity: true,
        ),
        DailyContextPoint(
          dayLabel: 'Wed',
          completedActivitiesCount: 2,
          engagementLevel: 3.5,
          primaryMood: 'tired',
          hadTogetherSession: false,
          hadMusicActivity: true,
        ),
        DailyContextPoint(
          dayLabel: 'Thu',
          completedActivitiesCount: 3,
          engagementLevel: 4.6,
          primaryMood: 'engaged',
          hadTogetherSession: true,
          hadMusicActivity: false,
        ),
        DailyContextPoint(
          dayLabel: 'Fri',
          completedActivitiesCount: 2,
          engagementLevel: 4.0,
          primaryMood: 'calm',
          hadTogetherSession: false,
          hadMusicActivity: true,
        ),
        DailyContextPoint(
          dayLabel: 'Sat',
          completedActivitiesCount: 3,
          engagementLevel: 4.9,
          primaryMood: 'joyful',
          hadTogetherSession: true,
          hadMusicActivity: true,
        ),
        DailyContextPoint(
          dayLabel: 'Sun (Today)',
          completedActivitiesCount: 2,
          engagementLevel: 4.5,
          primaryMood: 'calm',
          hadTogetherSession: true,
          hadMusicActivity: true,
        ),
      ],
      domainExposure: const [
        DomainExposureMetric(
          domain: CognitiveDomainType.memory,
          domainName: 'Memory & Recognition',
          sessionsCountThisWeek: 5,
          comfortSummary: 'Comfortable with family photos & familiar places',
        ),
        DomainExposureMetric(
          domain: CognitiveDomainType.attention,
          domainName: 'Attention & Focus',
          sessionsCountThisWeek: 4,
          comfortSummary: 'Unhurried focus during morning hours',
        ),
        DomainExposureMetric(
          domain: CognitiveDomainType.language,
          domainName: 'Language & Communication',
          sessionsCountThisWeek: 6,
          comfortSummary: 'Shared pleasant memories during music time',
        ),
        DomainExposureMetric(
          domain: CognitiveDomainType.executive,
          domainName: 'Executive Function',
          sessionsCountThisWeek: 3,
          comfortSummary: 'Gentle routine sequencing was well-received',
        ),
        DomainExposureMetric(
          domain: CognitiveDomainType.orientation,
          domainName: 'Orientation & Daily Context',
          sessionsCountThisWeek: 4,
          comfortSummary: 'Recognized morning tea & evening prayer anchors',
        ),
        DomainExposureMetric(
          domain: CognitiveDomainType.visuospatial,
          domainName: 'Visuospatial Skills',
          sessionsCountThisWeek: 4,
          comfortSummary: 'High comfort with nature & flower matching',
        ),
      ],
      recentFeedback: [
        CaregiverFeedback(
          id: 'fb_01',
          sessionId: 'sess_prev_01',
          patientId: 'patient_bonti_01',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          observationTags: const ['calm', 'engaged'],
          comfortRating: 'yes',
          whatHelped: 'Recognized the photo of Tezpur river ghat and smiled.',
          transcriptionText: 'She seemed peaceful and enjoyed pointing at the water.',
          enjoyedMusicOrMemory: true,
          recommendationPreference: 'keep_similar',
          syncStatus: SyncStatus.synced,
        ),
      ],
      lastUpdated: DateTime.now().subtract(const Duration(minutes: 15)),
    );
  }
}
