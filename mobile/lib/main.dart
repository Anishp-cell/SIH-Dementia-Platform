import 'package:flutter/material.dart';
import 'core/navigation/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'screens/ai_processing/ai_processing_screen.dart';
import 'screens/ai_processing/domain_overview_screen.dart';
import 'screens/backend_test/backend_test_screen.dart';
import 'screens/journey/todays_journey_screen.dart';
import 'screens/language/language_selection_screen.dart';
import 'screens/memory/personal_memory_space_screen.dart';
import 'screens/onboarding/caregiver_onboarding_screen.dart';
import 'screens/patient_activity/activity_completion_screen.dart';
import 'screens/patient_activity/activity_shell_screen.dart';
import 'screens/role/role_selection_screen.dart';
import 'screens/session_mode/caregiver_presence_selection_screen.dart';
import 'screens/session_mode/independent_mode_entry_screen.dart';
import 'screens/session_mode/together_mode_entry_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/system_states/patient_system_states_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DementiaAssistApp());
}

class DementiaAssistApp extends StatelessWidget {
  const DementiaAssistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dementia Assist',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.language: (context) => const LanguageSelectionScreen(),
        AppRoutes.roleSelection: (context) => const RoleSelectionScreen(),
        AppRoutes.caregiverOnboarding: (context) => const CaregiverOnboardingScreen(),
        AppRoutes.aiProcessing: (context) => const AiProcessingScreen(),
        AppRoutes.domainOverview: (context) => const DomainOverviewScreen(),
        AppRoutes.todaysJourney: (context) => const TodaysJourneyScreen(),
        AppRoutes.memoryVault: (context) => const PersonalMemorySpaceScreen(),
        AppRoutes.sessionTriage: (context) => const CaregiverPresenceSelectionScreen(),
        AppRoutes.togetherModeEntry: (context) => const TogetherModeEntryScreen(),
        AppRoutes.independentModeEntry: (context) => const IndependentModeEntryScreen(),
        AppRoutes.activityShell: (context) => const ActivityShellScreen(),
        AppRoutes.sessionCompletion: (context) => const ActivityCompletionScreen(),
        AppRoutes.systemStatesShowcase: (context) => const PatientSystemStatesScreen(),
        '/backend_test': (context) => const BackendTestScreen(),
      },
    );
  }
}