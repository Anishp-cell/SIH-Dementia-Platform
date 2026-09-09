import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../services/profile_service.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/exit_activity_button.dart';
import '../../widgets/common/feedback_banner.dart';
import '../../widgets/common/voice_instruction_bar.dart';
import '../patient_activity/activity_completion_screen.dart';

class RoutineStepItem {
  final int correctOrder;
  final String title;
  final String timeHint;
  final IconData icon;
  final Color themeColor;

  RoutineStepItem({
    required this.correctOrder,
    required this.title,
    required this.timeHint,
    required this.icon,
    required this.themeColor,
  });
}

/// Cognitive Together Activity 5: Build the Day Together.
/// Arrange daily routines into a natural sequence.
/// Tap-to-move interaction avoids frustrating dragging for elders.
class BuildTheDayActivityScreen extends StatefulWidget {
  const BuildTheDayActivityScreen({super.key});

  @override
  State<BuildTheDayActivityScreen> createState() => _BuildTheDayActivityScreenState();
}

class _BuildTheDayActivityScreenState extends State<BuildTheDayActivityScreen> {
  late List<RoutineStepItem> _currentSequence;
  bool _isVerifiedCorrect = false;
  String? _feedbackMessage;

  final List<RoutineStepItem> _masterRoutine = [
    RoutineStepItem(
      correctOrder: 1,
      title: 'Morning Assam Tea on Veranda',
      timeHint: 'Early Morning (8:00 AM)',
      icon: Icons.emoji_food_beverage_rounded,
      themeColor: AppColors.domainExecutive,
    ),
    RoutineStepItem(
      correctOrder: 2,
      title: 'Listening to Morning Radio Melodies',
      timeHint: 'Mid Morning (9:30 AM)',
      icon: Icons.radio_rounded,
      themeColor: AppColors.domainLanguage,
    ),
    RoutineStepItem(
      correctOrder: 3,
      title: 'Gentle Afternoon Garden Stroll',
      timeHint: 'Afternoon (3:00 PM)',
      icon: Icons.nature_people_rounded,
      themeColor: AppColors.forestPrimary,
    ),
    RoutineStepItem(
      correctOrder: 4,
      title: 'Evening Brass Diya Lighting & Prayer',
      timeHint: 'Dusk (6:30 PM)',
      icon: Icons.light_mode_rounded,
      themeColor: AppColors.peachDark,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initShuffledSequence();
  }

  void _initShuffledSequence() {
    _isVerifiedCorrect = false;
    _feedbackMessage = null;
    // Create a shuffled copy
    final list = List<RoutineStepItem>.from(_masterRoutine);
    list.shuffle();
    _currentSequence = list;
  }

  void _moveUp(int index) {
    if (index > 0) {
      setState(() {
        final item = _currentSequence.removeAt(index);
        _currentSequence.insert(index - 1, item);
        _feedbackMessage = null;
      });
    }
  }

  void _moveDown(int index) {
    if (index < _currentSequence.length - 1) {
      setState(() {
        final item = _currentSequence.removeAt(index);
        _currentSequence.insert(index + 1, item);
        _feedbackMessage = null;
      });
    }
  }

  void _checkSequence() {
    bool isCorrect = true;
    for (int i = 0; i < _currentSequence.length; i++) {
      if (_currentSequence[i].correctOrder != i + 1) {
        isCorrect = false;
        break;
      }
    }

    setState(() {
      _isVerifiedCorrect = isCorrect;
      if (isCorrect) {
        _feedbackMessage = 'A wonderful rhythm! Your day flows peacefully from morning tea to evening prayer.';
      } else {
        _feedbackMessage = 'Notice the morning tea and evening prayer. Would you like a gentle hint?';
      }
    });
  }

  void _caregiverAutoAssist() {
    // Sort correctly with warm explanation
    setState(() {
      _currentSequence.sort((a, b) => a.correctOrder.compareTo(b.correctOrder));
      _isVerifiedCorrect = true;
      _feedbackMessage = 'Together we arranged the day in perfect harmony: Morning Tea first, then Radio, Walk, and Prayers.';
    });
  }

  void _finishActivity() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ActivityCompletionScreen(
          activityTitle: 'Build the Day Together',
          onNextActivity: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.familiarObjectMatch);
          },
          onFinishSession: () {
            Navigator.of(context).pushReplacementNamed(AppRoutes.caregiverFeedback);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final patientName = ProfileService.instance.activeProfile?.preferredName ?? 'Friend';

    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWarm,
        elevation: 0,
        leading: const ExitActivityButton(),
        leadingWidth: 160,
        title: const Text('Build the Day Together', style: AppTypography.caregiverSubheading),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VoiceInstructionBar(
                instructionText: 'Arrange $patientName’s day in a gentle order. Tap the arrows to move moments up or down.',
                autoPlay: false,
              ),
              const SizedBox(height: 16),

              if (_feedbackMessage != null) ...[
                FeedbackBanner(
                  type: _isVerifiedCorrect ? FeedbackBannerType.affirmation : FeedbackBannerType.hint,
                  title: _isVerifiedCorrect ? 'Wonderful Flow!' : 'Almost in Order',
                  message: _feedbackMessage!,
                ),
                const SizedBox(height: 16),
              ],

              // Sequence List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _currentSequence.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final step = _currentSequence[index];
                  final isOrderCorrect = _isVerifiedCorrect || step.correctOrder == index + 1;

                  return CalmCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    borderColor: isOrderCorrect ? step.themeColor.withValues(alpha: 0.5) : AppColors.borderSoft,
                    borderWidth: isOrderCorrect ? 2.0 : 1.2,
                    child: Row(
                      children: [
                        // Slot number pill
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: step.themeColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: step.themeColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),

                        Icon(step.icon, size: 30, color: step.themeColor),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                              Text(
                                step.timeHint,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                        // Accessible Up/Down Buttons
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (index > 0)
                              InkWell(
                                onTap: () => _moveUp(index),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceWarm,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.arrow_upward, size: 18, color: AppColors.forestPrimary),
                                ),
                              ),
                            const SizedBox(height: 4),
                            if (index < _currentSequence.length - 1)
                              InkWell(
                                onTap: () => _moveDown(index),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceWarm,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.arrow_downward, size: 18, color: AppColors.forestPrimary),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Caregiver assistance row
              Row(
                children: [
                  Expanded(
                    child: ElderButton(
                      label: 'Check Sequence',
                      icon: Icons.check_circle_outline,
                      variant: ElderButtonVariant.primary,
                      height: 52,
                      onPressed: _checkSequence,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElderButton(
                      label: 'Caregiver Assist',
                      icon: Icons.handshake_outlined,
                      variant: ElderButtonVariant.secondary,
                      height: 52,
                      onPressed: _caregiverAutoAssist,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              if (_isVerifiedCorrect)
                ElderButton(
                  label: 'Finish & Continue',
                  icon: Icons.arrow_forward,
                  variant: ElderButtonVariant.peach,
                  height: 54,
                  onPressed: _finishActivity,
                ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
