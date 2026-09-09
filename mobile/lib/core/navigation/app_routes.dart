class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String language = '/language';
  static const String roleSelection = '/role';
  static const String consent = '/consent';
  static const String caregiverWelcome = '/caregiver_welcome';
  static const String caregiverOnboarding = '/caregiver_onboarding';
  static const String aiProcessing = '/ai_processing';
  static const String domainOverview = '/domain_overview';
  static const String todaysJourney = '/todays_journey';
  static const String sessionCompletion = '/activity/completion';
  static const String caregiverFeedback = '/caregiver_feedback';
  static const String caregiverDashboard = '/caregiver_dashboard';
  static const String memoryVault = '/memory_vault';
  static const String addMemory = '/memory_add';
  static const String sessionTriage = '/session_triage';
  static const String togetherModeEntry = '/together_entry';
  static const String independentModeEntry = '/independent_entry';
  static const String activityShell = '/activity/shell';
  static const String systemStatesShowcase = '/system_states';

  // 8 Specific Activity Routes
  static const String lookAndTalk = '/activity/look_and_talk';
  static const String musicAndMemory = '/activity/music_and_memory';
  static const String storyFromPhoto = '/activity/story_from_photo';
  static const String familyMatch = '/activity/family_match';
  static const String buildTheDay = '/activity/build_the_day';
  static const String familiarObjectMatch = '/activity/familiar_object_match';
  static const String rememberRecall = '/activity/remember_recall';
  static const String colourWordFocus = '/activity/colour_word_focus';

  // Backwards compatibility aliases
  static const String independentMatch = '/activity/match';
  static const String cognitiveTogether = '/activity/cognitive_together';
  static const String connectionMusic = '/activity/connection_music';
}
