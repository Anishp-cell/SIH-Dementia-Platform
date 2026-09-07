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

void main() {
  testWidgets('Splash screen displays branding and offline badge', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const SplashScreen(),
        routes: {
          AppRoutes.language: (context) => const Scaffold(),
        },
      ),
    );

    await tester.pump();
    expect(find.text(AppStrings.get('app_title')), findsOneWidget);
    expect(find.byIcon(Icons.spa), findsOneWidget);
    expect(find.text('Works 100% Offline • Private & Safe'), findsOneWidget);

    // Drain timer to complete navigation
    await tester.pump(const Duration(seconds: 3));
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

  testWidgets('Caregiver onboarding screen renders 15-step flow and advances smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CaregiverOnboardingScreen(),
      ),
    );
    await tester.pump();

    // Verify Step 1 content (Welcome)
    expect(find.text('Step 1 of 15'), findsOneWidget);
    expect(find.text('Welcome to Dementia Assist'), findsOneWidget);

    // Tap Next Step to go to Step 2 (Start / Setup)
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();

    expect(find.text('Step 2 of 15'), findsOneWidget);
    expect(find.text('Getting to Know Your Loved One'), findsOneWidget);

    // Tap Next Step to go to Step 3 (Patient Profile)
    await tester.tap(find.text('Next Step'));
    await tester.pumpAndSettle();

    expect(find.text('Step 3 of 15'), findsOneWidget);
    expect(find.text('Who are we caring for?'), findsOneWidget);
    expect(find.text('Preferred Name or Warm Greeting'), findsOneWidget);

    // Test Previous button returns to Step 2
    await tester.tap(find.text('Previous'));
    await tester.pumpAndSettle();
    expect(find.text('Step 2 of 15'), findsOneWidget);
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

    expect(find.text('Is a caregiver with you right now?'), findsOneWidget);
    expect(find.text('Yes, We Are Together'), findsOneWidget);
    expect(find.text('No, Playing on My Own'), findsOneWidget);
    expect(find.text('Enter Together Mode'), findsOneWidget);
    expect(find.text('Start Independent Play'), findsOneWidget);
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
}
