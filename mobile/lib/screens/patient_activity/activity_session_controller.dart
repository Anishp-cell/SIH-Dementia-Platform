import 'package:flutter/material.dart';

enum ActivityLifecycleState {
  instructions,
  readyToStart,
  inProgress,
  correctFeedback,
  incorrectFeedback,
  hint,
  paused,
  nextRound,
  completed,
}

/// Generic controller managing the lifecycle states of patient activities.
/// Allows Priyanka's game implementations to plug in smoothly without
/// exposing clinical metrics or time pressure to the patient.
class ActivitySessionController extends ChangeNotifier {
  ActivityLifecycleState _state;
  final String activityTitle;
  final String instructionText;
  final String hintText;
  int _currentRound;
  final int totalRounds;
  final bool isTogetherMode;

  ActivitySessionController({
    required this.activityTitle,
    required this.instructionText,
    this.hintText = 'Notice the colors and gentle patterns. Take all the time you need.',
    ActivityLifecycleState initialState = ActivityLifecycleState.instructions,
    int initialRound = 1,
    this.totalRounds = 3,
    this.isTogetherMode = false,
  })  : _state = initialState,
        _currentRound = initialRound;

  ActivityLifecycleState get state => _state;
  int get currentRound => _currentRound;

  void showInstructions() {
    _state = ActivityLifecycleState.instructions;
    notifyListeners();
  }

  void readyToStart() {
    _state = ActivityLifecycleState.readyToStart;
    notifyListeners();
  }

  void startRound() {
    _state = ActivityLifecycleState.inProgress;
    notifyListeners();
  }

  void triggerCorrectFeedback() {
    _state = ActivityLifecycleState.correctFeedback;
    notifyListeners();
  }

  void triggerIncorrectFeedback() {
    _state = ActivityLifecycleState.incorrectFeedback;
    notifyListeners();
  }

  void showHint() {
    _state = ActivityLifecycleState.hint;
    notifyListeners();
  }

  void pause() {
    _state = ActivityLifecycleState.paused;
    notifyListeners();
  }

  void resume() {
    _state = ActivityLifecycleState.inProgress;
    notifyListeners();
  }

  void advanceRound() {
    if (_currentRound < totalRounds) {
      _currentRound++;
      _state = ActivityLifecycleState.nextRound;
    } else {
      _state = ActivityLifecycleState.completed;
    }
    notifyListeners();
  }

  void completeActivity() {
    _state = ActivityLifecycleState.completed;
    notifyListeners();
  }

  void setStateDirectly(ActivityLifecycleState newState) {
    _state = newState;
    notifyListeners();
  }
}
