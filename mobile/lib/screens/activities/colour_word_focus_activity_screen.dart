import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/navigation/app_routes.dart';
import '../../widgets/common/calm_card.dart';
import '../../widgets/common/elder_button.dart';
import '../../widgets/common/exit_activity_button.dart';
import '../../widgets/common/voice_instruction_bar.dart';
import '../patient_activity/activity_completion_screen.dart';

class ColorWordStimulus {
  final String promptInstruction;
  final String displayedWord;
  final Color textColor;
  final String correctTarget;
  final IconData targetSymbol;
  final String natureSymbolName;

  const ColorWordStimulus({
    required this.promptInstruction,
    required this.displayedWord,
    required this.textColor,
    required this.correctTarget,
    required this.targetSymbol,
    required this.natureSymbolName,
  });
}

/// Independent Cognitive Activity 8: Colour–Word Focus.
/// Accessible visual focus experience that DOES NOT rely on color alone:
/// every color choice has a distinct natural symbol and clear label (e.g. Leaf for Green, Sun for Yellow).
class ColourWordFocusActivityScreen extends StatefulWidget {
  const ColourWordFocusActivityScreen({super.key});

  @override
  State<ColourWordFocusActivityScreen> createState() => _ColourWordFocusActivityScreenState();
}

class _ColourWordFocusActivityScreenState extends State<ColourWordFocusActivityScreen> {
  int _currentRound = 0;
  final int _totalRounds = 3;
  String? _feedbackText;
  bool _isSuccess = false;

  final List<ColorWordStimulus> _rounds = const [
    ColorWordStimulus(
      promptInstruction: 'Touch the color of the TEA LEAF:',
      displayedWord: 'GOLDEN SUN',
      textColor: AppColors.forestPrimary, // Green
      correctTarget: 'Green',
      targetSymbol: Icons.eco_rounded,
      natureSymbolName: 'Tea Leaf (Green)',
    ),
    ColorWordStimulus(
      promptInstruction: 'Touch the color of the MORNING SUN:',
      displayedWord: 'BLUE RIVER',
      textColor: AppColors.peachDark, // Amber/Yellow
      correctTarget: 'Yellow',
      targetSymbol: Icons.wb_sunny_rounded,
      natureSymbolName: 'Morning Sun (Yellow)',
    ),
    ColorWordStimulus(
      promptInstruction: 'Touch the color of the BRAHMAPUTRA WATER:',
      displayedWord: 'LOTUS FLOWER',
      textColor: AppColors.domainOrientation, // Blue
      correctTarget: 'Blue',
      targetSymbol: Icons.water_rounded,
      natureSymbolName: 'River Water (Blue)',
    ),
  ];

  final List<Map<String, dynamic>> _answerChoices = const [
    {
      'colorName': 'Green',
      'label': 'Tea Leaf (Green)',
      'icon': Icons.eco_rounded,
      'color': AppColors.forestPrimary,
    },
    {
      'colorName': 'Yellow',
      'label': 'Morning Sun (Yellow)',
      'icon': Icons.wb_sunny_rounded,
      'color': AppColors.peachDark,
    },
    {
      'colorName': 'Blue',
      'label': 'River Water (Blue)',
      'icon': Icons.water_rounded,
      'color': AppColors.domainOrientation,
    },
    {
      'colorName': 'Red',
      'label': 'Lotus Rose (Red)',
      'icon': Icons.local_florist_rounded,
      'color': Color(0xFFC62828),
    },
  ];

  void _onAnswerSelected(String selectedColorName) {
    final stimulus = _rounds[_currentRound];
    final isCorrect = selectedColorName == stimulus.correctTarget;

    setState(() {
      _isSuccess = isCorrect;
      if (isCorrect) {
        _feedbackText = 'Wonderful! You touched ${stimulus.natureSymbolName}.';
      } else {
        _feedbackText = 'No hurry! Take a gentle look at the symbol: ${stimulus.natureSymbolName}.';
      }
    });

    if (isCorrect) {
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (mounted) {
          _advanceRound();
        }
      });
    }
  }

  void _advanceRound() {
    if (_currentRound < _totalRounds - 1) {
      setState(() {
        _currentRound++;
        _feedbackText = null;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ActivityCompletionScreen(
            activityTitle: 'Colour–Word Focus',
            onNextActivity: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.todaysJourney);
            },
            onFinishSession: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.caregiverFeedback);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stimulus = _rounds[_currentRound];

    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundWarm,
        elevation: 0,
        leading: const ExitActivityButton(),
        leadingWidth: 160,
        title: const Text('Colour–Word Focus', style: AppTypography.caregiverSubheading),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceWarm,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSoft),
            ),
            child: Text(
              'Round ${_currentRound + 1} of $_totalRounds',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.forestDark),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              VoiceInstructionBar(
                instructionText: stimulus.promptInstruction,
                autoPlay: false,
              ),
              const SizedBox(height: 18),

              // Stimulus Card
              CalmCard(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                child: Column(
                  children: [
                    Text(
                      stimulus.promptInstruction,
                      style: AppTypography.patientTitle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),

                    // High-contrast word display with color and natural symbol
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceWarm,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: stimulus.textColor.withValues(alpha: 0.4), width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(stimulus.targetSymbol, size: 36, color: stimulus.textColor),
                          const SizedBox(width: 14),
                          Text(
                            stimulus.displayedWord,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: stimulus.textColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              if (_feedbackText != null) ...[
                CalmCard(
                  backgroundColor: _isSuccess ? AppColors.sageLight : AppColors.peachLight,
                  borderColor: _isSuccess ? AppColors.sage : AppColors.peach,
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Icon(_isSuccess ? Icons.check_circle : Icons.favorite, size: 22, color: _isSuccess ? AppColors.forestDark : AppColors.peachDark),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _feedbackText!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _isSuccess ? AppColors.forestDark : AppColors.peachDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
              ],

              // Answer Buttons Grid (Accessible: large targets, distinct symbols & text)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.8,
                ),
                itemCount: _answerChoices.length,
                itemBuilder: (context, index) {
                  final choice = _answerChoices[index];
                  final colorName = choice['colorName'] as String;
                  final label = choice['label'] as String;
                  final icon = choice['icon'] as IconData;
                  final color = choice['color'] as Color;

                  return InkWell(
                    onTap: () => _onAnswerSelected(colorName),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
                        boxShadow: const [
                          BoxShadow(color: Color(0x08000000), blurRadius: 8, offset: Offset(0, 3)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, size: 24, color: color),
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              label,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.textPrimary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              ElderButton(
                label: 'Skip / Next Round',
                icon: Icons.arrow_forward,
                variant: ElderButtonVariant.secondary,
                height: 52,
                onPressed: _advanceRound,
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
