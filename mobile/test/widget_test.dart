import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_strings.dart';
import 'package:mobile/core/navigation/app_routes.dart';
import 'package:mobile/screens/ai_processing/domain_overview_screen.dart';
import 'package:mobile/screens/journey/todays_journey_screen.dart';
import 'package:mobile/screens/language/language_selection_screen.dart';
import 'package:mobile/screens/memory/personal_memory_space_screen.dart';
import 'package:mobile/screens/onboarding/caregiver_onboarding_screen.dart';
import 'package:mobile/screens/patient_activity/activity_completion_screen.dart';
import 'package:mobile/screens/patient_activity/activity_shell_screen.dart';
import 'package:mobile/screens/role/role_selection_screen.dart';
import 'package:mobile/screens/session_mode/caregiver_presence_selection_screen.dart';
import 'package:mobile/screens/splash/splash_screen.dart';
import 'package:mobile/screens/system_states/patient_system_states_screen.dart';

import 'package:mobile/screens/activities/build_the_day_activity_screen.dart';
import 'package:mobile/screens/activities/colour_word_focus_activity_screen.dart';
import 'package:mobile/screens/activities/family_match_activity_screen.dart';
import 'package:mobile/screens/activities/familiar_object_match_activity_screen.dart';
import 'package:mobile/screens/activities/look_and_talk_activity_screen.dart';
import 'package:mobile/screens/activities/music_and_memory_activity_screen.dart';
import 'package:mobile/screens/activities/remember_recall_activity_screen.dart';
import 'package:mobile/screens/activities/story_from_photo_activity_screen.dart';
import 'package:mobile/screens/dashboard/caregiver_dashboard_screen.dart';
import 'package:mobile/screens/feedback/caregiver_feedback_screen.dart';
import 'package:mobile/screens/onboarding/caregiver_welcome_screen.dart';
import 'package:mobile/services/mock_data_repository.dart';
import 'package:mobile/services/profile_service.dart';
import 'package:mobile/widgets/common/language_toggle_widget.dart';
import 'package:mobile/widgets/common/voice_input_field.dart';

void main() {
  setUp(() {
    ProfileService.instance.clearProfile();
    AppStrings.setLanguage('en');
  });

  testWidgets('Splash screen displays branding, offline badge, and pops up Start button for first-time user', (WidgetTester tester) async {
    ProfileService.instance.clearProfile();
    await tester.pumpWidget(
      MaterialApp(
        home: const SplashScreen(),
        routes: {
          AppRoutes.caregiverWelcome: (context) => const Scaffold(),
        },
      ),
    );

    await tester.pump();
    expect(find.text(AppStrings.get('app_title')), findsOneWidget);
    expect(find.byIcon(Icons.spa_rounded), findsOneWidget);
    expect(find.text(AppStrings.get('tagline')), findsOneWidget);

    // Wait for Start button to pop up
    await tester.pump(const Duration(milliseconds: 2200));
    expect(find.text(AppStrings.get('start_button')), findsOneWidget);
  });

  testWidgets('Splash screen fetches profile for returning user and navigates directly', (WidgetTester tester) async {
    // Set active profile to simulate returning user without delay
    ProfileService.instance.saveProfile(MockDataRepository.createSamplePatient());

    await tester.pumpWidget(
      MaterialApp(
        home: const SplashScreen(),
        routes: {
          AppRoutes.todaysJourney: (context) => const Scaffold(body: Text("Today's Gentle Journey")),
        },
      ),
    );

    await tester.pump();
    expect(find.text(AppStrings.get('fetching_profile')), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text("Today's Gentle Journey"), findsOneWidget);
  });

  testWidgets('Caregiver welcome screen displays 5-minute setup message and language toggle', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CaregiverWelcomeScreen(),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.get('caregiver_welcome_title')), findsOneWidget);
    expect(find.text(AppStrings.get('start_profile_btn')), findsOneWidget);
    expect(find.byType(LanguageToggleWidget), findsOneWidget);
  });

  testWidgets('Language selection screen displays all 3 languages', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LanguageSelectionScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Choose Your Language'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
    expect(find.text('हिंदी'), findsOneWidget);
    expect(find.text('অসমীয়া'), findsOneWidget);
  });

  testWidgets('Role selection screen shows Caregiver and Patient entries', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RoleSelectionScreen(),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.get('role_caregiver')), findsOneWidget);
    expect(find.text(AppStrings.get('role_patient')), findsOneWidget);
    expect(find.text('Plain-Language Privacy & Zero Medical Claims Notice'), findsOneWidget);
  });

  testWidgets('Caregiver onboarding screen renders peaceful 3-part flow with voice support and advances smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CaregiverOnboardingScreen(),
      ),
    );
    await tester.pump();

    // Verify Part 1 content (General Information)
    expect(find.text('Step 1 of 3'), findsOneWidget);
    expect(find.text(AppStrings.get('part_1_title')), findsOneWidget);
    expect(find.text(AppStrings.get('patient_name_label')), findsOneWidget);
    expect(find.byType(VoiceInputField), findsWidgets);

    // Tap Next Step to go to Part 2 (Abilities, Preferences & Observations)
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();

    expect(find.text('Step 2 of 3'), findsOneWidget);
    expect(find.text(AppStrings.get('part_2_title')), findsOneWidget);

    // Tap Next Step to go to Part 3 (Routines & Doctor's Advises)
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();

    expect(find.text('Step 3 of 3'), findsOneWidget);
    expect(find.text(AppStrings.get('part_3_title')), findsOneWidget);
    expect(find.text(AppStrings.get('doctor_advises_label')), findsOneWidget);

    // Test Back button returns to Part 2
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Step 2 of 3'), findsOneWidget);
  });

  testWidgets('Domain overview screen displays all 6 domains', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DomainOverviewScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Six Cognitive Domains'), findsOneWidget);
    expect(find.text('Remember'), findsOneWidget);
    expect(find.text('Notice'), findsOneWidget);
    expect(find.text('Talk & Share'), findsOneWidget);
    expect(find.text('Plan & Sort'), findsOneWidget);
    expect(find.text('Today & Places'), findsOneWidget);
    expect(find.text('Explore & Match'), findsOneWidget);
  });

  testWidgets('Todays Journey screen renders recommendation hero, presence toggle, and gentle alternative', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TodaysJourneyScreen(),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.get('todays_journey')), findsOneWidget);
    expect(find.text(AppStrings.get('caregiver_present_q')), findsOneWidget);
    expect(find.text(AppStrings.get('yes_together')), findsOneWidget);
    expect(find.text(AppStrings.get('no_independent')), findsOneWidget);
    expect(find.text("Today's Recommendation"), findsOneWidget);
    expect(find.text('Start Recommended Activity'), findsOneWidget);
    expect(find.text('Prefer a Quiet Moment?'), findsOneWidget);
    expect(find.text('Finish Session for Today'), findsOneWidget);
  });

  testWidgets('Personal Memory Space displays category chips and memories with activity usage tags', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PersonalMemorySpaceScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Personal Memory Space'), findsOneWidget);
    expect(find.text('Photos'), findsOneWidget);
    expect(find.text('Music'), findsOneWidget);
    expect(find.text('Places'), findsOneWidget);
    expect(find.text('Add Content'), findsOneWidget);
    expect(find.text('Grandmother’s Veranda in Tezpur'), findsOneWidget);
    expect(find.textContaining('Used in:'), findsWidgets);
  });

  testWidgets('Caregiver Presence Selection Screen displays Together and Independent choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CaregiverPresenceSelectionScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Is someone with you right now?'), findsOneWidget);
    expect(find.text('No, I am alone'), findsOneWidget);
    expect(find.text('Yes, someone is with me'), findsOneWidget);
    expect(find.text("Let's Begin"), findsOneWidget);
  });

  testWidgets('Activity Shell renders instructions, advances to ready, and enters round', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ActivityShellScreen(),
      ),
    );
    await tester.pump();

    // Verify instructions state
    expect(find.text('How We Play'), findsOneWidget);
    expect(find.text('I am Ready'), findsOneWidget);

    // Tap I am Ready
    await tester.tap(find.text('I am Ready'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify ready to start state
    expect(find.text('Ready for Round 1?'), findsOneWidget);
    expect(find.text('Start Round'), findsOneWidget);

    // Tap Start Round
    await tester.tap(find.text('Start Round'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify interactive viewport is present
    expect(find.text('Touch to Match Familiar Elements'), findsOneWidget);
    expect(find.text('Need a Hint?'), findsOneWidget);
  });

  testWidgets('Activity Completion Screen displays calm celebration without numerical scores', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ActivityCompletionScreen(
          activityTitle: 'Familiar Nature Match',
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Wonderful Effort Today!'), findsOneWidget);
    expect(find.text('Next Gentle Activity'), findsOneWidget);
    expect(find.text('Finish Session for Today'), findsOneWidget);
  });

  testWidgets('Patient System States Screen showcases all 15 states with interactive switcher', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: PatientSystemStatesScreen(
          initialState: PatientSystemStateType.personalisationLoading,
        ),
      ),
    );
    await tester.pump();

    // Verify State 1 renders
    expect(find.text('STATE 1: PERSONALISATION LOADING'), findsOneWidget);
    expect(find.text('Preparing Your Special Space'), findsOneWidget);

    // Tap next state button
    final nextButton = find.byTooltip('Next state');
    expect(nextButton, findsOneWidget);
    await tester.tap(nextButton);
    await tester.pump();

    // Verify State 2 renders
    expect(find.text('STATE 2: RECOMMENDATION LOADING'), findsOneWidget);
    expect(find.text("Finding Today's Best Moment"), findsOneWidget);

    // Re-pump with Offline Mode directly
    await tester.pumpWidget(
      const MaterialApp(
        home: PatientSystemStatesScreen(
          initialState: PatientSystemStateType.offline,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('STATE 9: OFFLINE MODE'), findsOneWidget);
    expect(find.text('Everything is Safe on Your Device'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);

    // Re-pump with Voice Processing directly
    await tester.pumpWidget(
      const MaterialApp(
        home: PatientSystemStatesScreen(
          initialState: PatientSystemStateType.voiceProcessing,
        ),
      ),
    );
    await tester.pump();
    expect(find.text('STATE 12: VOICE PROCESSING'), findsOneWidget);
    expect(find.text("Listening to You..."), findsOneWidget);
    expect(find.byIcon(Icons.mic), findsOneWidget);
  });

  test('AppStrings provides comprehensive translations across English, Hindi, and Assamese', () {
    // English
    AppStrings.setLanguage('en');
    expect(AppStrings.get('memory_vault'), 'Personal Memory Space');
    expect(AppStrings.get('todays_journey'), "Today's Gentle Journey");
    expect(AppStrings.get('system_states'), 'System & AI States');

    // Hindi
    AppStrings.setLanguage('hi');
    expect(AppStrings.get('memory_vault'), 'व्यक्तिगत स्मृति संदूक');
    expect(AppStrings.get('todays_journey'), 'आज का शांत सफर');
    expect(AppStrings.get('system_states'), 'सिस्टम और एआई स्थितियां');

    // Assamese
    AppStrings.setLanguage('as');
    expect(AppStrings.get('memory_vault'), 'ব্যক্তিগত স্মৃতি ভঁৰাল');
    expect(AppStrings.get('todays_journey'), 'আজিৰ শান্ত যাত্ৰা');
    expect(AppStrings.get('system_states'), 'ছিষ্টেম আৰু এআই অৱস্থা');

    // Reset back to en
    AppStrings.setLanguage('en');
  });

  testWidgets('Activity 1: Look & Talk renders photo, prompt, and next photo progression', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LookAndTalkActivityScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Look & Talk'), findsOneWidget);
    expect(find.text('Conversation Starter'), findsOneWidget);
    expect(find.text('Next Cherished Photo'), findsOneWidget);
  });

  testWidgets('Activity 2: Music & Memory renders music player, play/pause, and reminiscence prompt', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MusicAndMemoryActivityScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Music & Memory'), findsOneWidget);
    expect(find.text('Borgeet Bamboo Flute (Morning Raga)'), findsOneWidget);
    expect(find.text('Reminiscence Prompt'), findsOneWidget);
    expect(find.text('Pause Melody'), findsOneWidget);
  });

  testWidgets('Activity 3: Story from Photo renders storytelling prompt and steps', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: StoryFromPhotoActivityScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Story from Photo'), findsOneWidget);
    expect(find.text('The Green Tea Hills of Assam'), findsOneWidget);
    expect(find.textContaining('Story Starter'), findsOneWidget);
    expect(find.text('Continue This Story'), findsOneWidget);
  });

  testWidgets('Activity 4: Family Match & Tell renders family cards and hint', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FamilyMatchActivityScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Family Match & Tell'), findsOneWidget);
    expect(find.text('Touch to Flip'), findsWidgets);
    expect(find.text('Caregiver Clue'), findsOneWidget);
  });

  testWidgets('Activity 5: Build the Day Together renders sequence steps and check button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BuildTheDayActivityScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Build the Day Together'), findsOneWidget);
    expect(find.text('Morning Assam Tea on Veranda'), findsOneWidget);
    expect(find.text('Check Sequence'), findsOneWidget);
    expect(find.text('Caregiver Assist'), findsOneWidget);
  });

  testWidgets('Activity 6: Familiar Object Match renders cultural artifacts and hint', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: FamiliarObjectMatchActivityScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Familiar Object Match'), findsOneWidget);
    expect(find.text('Show a Clue'), findsOneWidget);
    expect(find.text('Continue Gently'), findsOneWidget);
  });

  testWidgets('Activity 7: Remember & Recall renders memorize phase and ready button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RememberRecallActivityScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Remember & Recall'), findsOneWidget);
    expect(find.text('Assam Chai Kettle'), findsOneWidget);
    expect(find.text('I am Ready to Recall'), findsOneWidget);
  });

  testWidgets('Activity 8: Colour-Word Focus renders accessible symbol choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ColourWordFocusActivityScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Colour–Word Focus'), findsOneWidget);
    expect(find.text('Tea Leaf (Green)'), findsOneWidget);
    expect(find.text('Morning Sun (Yellow)'), findsOneWidget);
    expect(find.text('Skip / Next Round'), findsOneWidget);
  });

  testWidgets('Caregiver Dashboard renders patient profile, 6-domain coverage, and routine reminders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CaregiverDashboardScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Caregiver Dashboard'), findsOneWidget);
    expect(find.text('Six Cognitive Domains Covered'), findsOneWidget);
    expect(find.text('Weekly Activity Consistency'), findsOneWidget);
    expect(find.text('Daily Routine & Wellness Reminders'), findsOneWidget);
  });

  testWidgets('Caregiver Feedback screen renders observation chips and comfort rating', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CaregiverFeedbackScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Caregiver Observation'), findsOneWidget);
    expect(find.text('Calm'), findsOneWidget);
    expect(find.text('Engaged'), findsOneWidget);
    expect(find.text('Save Observation & Adapt Next Pace'), findsOneWidget);
  });
}
