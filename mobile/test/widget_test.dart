import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/constants/app_strings.dart';
import 'package:mobile/core/navigation/app_routes.dart';
import 'package:mobile/screens/ai_processing/domain_overview_screen.dart';
import 'package:mobile/screens/journey/todays_journey_screen.dart';
import 'package:mobile/screens/language/language_selection_screen.dart';
import 'package:mobile/screens/memory/personal_memory_space_screen.dart';
import 'package:mobile/screens/onboarding/caregiver_onboarding_screen.dart';
import 'package:mobile/screens/role/role_selection_screen.dart';
import 'package:mobile/screens/splash/splash_screen.dart';

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

  testWidgets('Todays Journey screen renders garden path and activities', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: TodaysJourneyScreen(),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.get('todays_journey')), findsOneWidget);
    expect(find.text('Is a caregiver with you right now?'), findsOneWidget);
    expect(find.text(AppStrings.get('yes_together')), findsOneWidget);
    expect(find.text(AppStrings.get('no_independent')), findsOneWidget);
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
}
