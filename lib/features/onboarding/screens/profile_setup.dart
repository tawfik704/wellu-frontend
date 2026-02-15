import 'package:flutter/material.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int currentStep = 0;
  static const int totalSteps = 11;

  @override
  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF22E1A0),
              Color(0xFF1E88E5),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40), // Made this smaller!

              // ─────────── Progress Header ───────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: Row(
                  children: [
                    Text(
                      'Step ${currentStep + 1} of $totalSteps',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 35),
// ─────────── Card ───────────
              Expanded(
                child: Center( // 🌟 THIS is the magic widget! It stops the stretching.
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // 🌟 Hugs the content perfectly!
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStepContent(),
                            const SizedBox(height: 32),

                            // ─────────── Next Button ───────────
                            SizedBox(
                              width: double.infinity,
                              height: 60,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF00C853),
                                      Color(0xFF2979FF),
                                    ],
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: _nextStep,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: Text(
                                    currentStep == 0 ? 'Start' : 'Next',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 140), // Replaced the giant 250 spacer
            ],
          ),
        ),
      ),
    );
  }
  // ─────────── Step Switcher ───────────
  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _GoalStep(
          onSelected: (value) {
            // later: save goal
          },
        );
      case 1:
        return _GenderStep(
          onSelected: (value) {
            // later: save gender
          },
          onBack: () {
            setState(() {
              currentStep--;
            });
          },
        );
      default:
        return const Text('Next steps coming...');
    }
  }



  void _nextStep() {
    if (currentStep < totalSteps - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      // Finished → go to dashboard later
    }
  }
}
class _GoalStep extends StatefulWidget {
  final Function(String) onSelected;

  const _GoalStep({required this.onSelected});

  @override
  State<_GoalStep> createState() => _GoalStepState();
}

class _GoalStepState extends State<_GoalStep> {
  String? selectedGoal;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.track_changes,
          size: 64,
          color: Color(0xFF2979FF),
        ),
        const SizedBox(height: 16),
        const Text(
          "Let's build your WellU profile",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'No forms. Just a few smart choices.',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),



      ],
    );
  }






}


class _GenderStep extends StatefulWidget {
  final Function(String) onSelected;
  final VoidCallback onBack;

  const _GenderStep({
    required this.onSelected,
    required this.onBack,
  });

  @override
  State<_GenderStep> createState() => _GenderStepState();
}

class _GenderStepState extends State<_GenderStep> {
  String? selectedGender;

  final genders = [
    {'label': 'Male', 'icon': Icons.person_outline},
    {'label': 'Female', 'icon': Icons.people_outline},
    {'label': 'Prefer not to say', 'icon': Icons.person_off_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'I identify as…',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        ...genders.map((gender) {
          final isSelected = selectedGender == gender['label'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedGender = gender['label'] as String;
                });
                widget.onSelected(gender['label'] as String);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2979FF)
                        : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        gender['icon'] as IconData,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      gender['label'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),

        const SizedBox(height: 16),

        // ─────────── Back Button ───────────
        TextButton(
          onPressed: widget.onBack,
          child: const Text(
            'Back',
            style: TextStyle(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

