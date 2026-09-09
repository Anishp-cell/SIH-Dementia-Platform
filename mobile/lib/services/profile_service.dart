import 'package:flutter/foundation.dart';
import '../models/patient_profile.dart';
import 'mock_data_repository.dart';

/// Service managing patient profile state, onboarding progress, voice notes, and draft edits.
class ProfileService extends ChangeNotifier {
  static final ProfileService instance = ProfileService._internal();
  ProfileService._internal();

  PatientProfile? _activeProfile;
  bool _isLoading = false;
  bool _hasCompletedOnboarding = false;

  // Voice recordings stored during profile setup
  String? generalVoiceNote;
  String? observationVoiceNote;
  String? doctorVoiceNote;

  PatientProfile? get activeProfile => _activeProfile;
  bool get hasProfile => _activeProfile != null;
  bool get isReturningUser => _activeProfile != null && _hasCompletedOnboarding;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  bool get isLoading => _isLoading;

  /// Loads initial profile or default mock profile
  Future<void> loadProfile({bool useMock = true}) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 300));
    if (useMock && _activeProfile == null) {
      _activeProfile = MockDataRepository.createSamplePatient();
      _hasCompletedOnboarding = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Sets or saves a completed profile from caregiver onboarding
  void saveProfile(PatientProfile profile, {
    String? generalVoice,
    String? obsVoice,
    String? drVoice,
  }) {
    _activeProfile = profile;
    _hasCompletedOnboarding = true;
    if (generalVoice != null) generalVoiceNote = generalVoice;
    if (obsVoice != null) observationVoiceNote = obsVoice;
    if (drVoice != null) doctorVoiceNote = drVoice;
    notifyListeners();
  }

  /// Updates specific fields of the active profile
  void updateProfile(PatientProfile updated) {
    _activeProfile = updated;
    notifyListeners();
  }

  /// Clears active profile (for testing fresh onboarding)
  void clearProfile() {
    _activeProfile = null;
    _hasCompletedOnboarding = false;
    generalVoiceNote = null;
    observationVoiceNote = null;
    doctorVoiceNote = null;
    notifyListeners();
  }
}
