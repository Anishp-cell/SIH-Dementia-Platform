import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/audio/voice_assistant_service.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_typography.dart';

/// Dementia-friendly dual-mode text and voice input field.
/// Allows caregivers and elders to easily speak their responses or type manually.
class VoiceInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? voiceSimulationSample;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onVoiceRecorded;

  const VoiceInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.voiceSimulationSample,
    this.maxLines = 1,
    this.onChanged,
    this.onVoiceRecorded,
  });

  @override
  State<VoiceInputField> createState() => _VoiceInputFieldState();
}

class _VoiceInputFieldState extends State<VoiceInputField>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  int _recordSeconds = 0;
  Timer? _timer;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  void _toggleRecording() async {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
      _recordSeconds = 0;
    });
    _waveController.repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _recordSeconds++;
      });
      // Auto-stop after 5 seconds of sample speech in simulation
      if (_recordSeconds >= 4) {
        _stopRecording();
      }
    });
  }

  void _stopRecording() {
    _timer?.cancel();
    _waveController.stop();

    final spokenText = widget.voiceSimulationSample ??
        (widget.controller.text.isNotEmpty
            ? widget.controller.text
            : 'Recorded voice response');

    setState(() {
      _isRecording = false;
      widget.controller.text = spokenText;
    });

    widget.onChanged?.call(spokenText);
    widget.onVoiceRecorded?.call(spokenText);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.mic, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(AppStrings.get('voice_recorded'))),
          ],
        ),
        backgroundColor: AppColors.forestPrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _playSpokenText() {
    if (widget.controller.text.isNotEmpty) {
      VoiceAssistantService.instance.speak(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (widget.controller.text.isNotEmpty) ...[
              const SizedBox(width: 8),
              InkWell(
                onTap: _playSpokenText,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.volume_up, size: 16, color: AppColors.forestPrimary),
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.get('spoken_help'),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.forestPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),

        // Input Card with Embedded Microphone Button
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isRecording ? AppColors.errorGentle : AppColors.borderSoft,
              width: _isRecording ? 2.0 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isRecording
                    ? AppColors.peach.withValues(alpha: 0.18)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: widget.maxLines > 1
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      maxLines: widget.maxLines,
                      onChanged: widget.onChanged,
                      style: AppTypography.caregiverBody.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: widget.hint,
                        hintStyle: TextStyle(
                          color: AppColors.textTertiary,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Microphone Tap Target (Min 48x48dp touch target)
                  Semantics(
                    button: true,
                    label: _isRecording ? 'Stop recording voice' : 'Tap to speak voice note',
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _toggleRecording,
                        borderRadius: BorderRadius.circular(24),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _isRecording
                                ? AppColors.errorGentle
                                : AppColors.surfaceWarm,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _isRecording
                                  ? AppColors.errorGentle
                                  : AppColors.forestPrimary.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Icon(
                            _isRecording ? Icons.stop : Icons.mic,
                            color: _isRecording ? Colors.white : AppColors.forestPrimary,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Active Recording Wave & Timer Indicator
              if (_isRecording) ...[
                const Divider(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      AnimatedBuilder(
                        animation: _waveController,
                        builder: (context, child) {
                          return Row(
                            children: List.generate(4, (index) {
                              final height = 8.0 + (index * 4.0) * _waveController.value;
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                width: 3,
                                height: height.clamp(4.0, 20.0),
                                decoration: BoxDecoration(
                                  color: AppColors.errorGentle,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${AppStrings.get('voice_listening')} (0:0$_recordSeconds)',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.errorGentle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
