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
  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _GoalStep(onSelected: (value) {});
      case 1:
        return _GenderStep(
          onSelected: (value) {},
          onBack: () => setState(() => currentStep--),
        );
      case 2:
        return _BodyStatsStep(onSaved: (stats) {});
      case 3: // 🌟 Your new Goal step!
        return _MainGoalStep(
          onSaved: (selectedGoals) {
            // later: save this list of 1 or 2 goals
            print(selectedGoals);
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


class GradientThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const GradientThumbShape({this.thumbRadius = 14.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;

    // 1. Draw the gradient background (the border)
    final Paint gradientPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF22E1A0),
          Color(0xFF1E88E5),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: thumbRadius))
      ..style = PaintingStyle.fill;

    // 2. Draw the white center
    final Paint whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Stamp the gradient circle first
    canvas.drawCircle(center, thumbRadius, gradientPaint);

    // Stamp a slightly smaller white circle on top (leaving a 4px gradient border!)
    canvas.drawCircle(center, thumbRadius - 4, whitePaint);
  }
}








class _BodyStatsStep extends StatefulWidget {
  final Function(Map<String, double>) onSaved;

  const _BodyStatsStep({required this.onSaved});

  @override
  State<_BodyStatsStep> createState() => _BodyStatsStepState();
}

class _BodyStatsStepState extends State<_BodyStatsStep> {
  // Starting default values based on your design
  double age = 25;
  double heightVal = 170;
  double weightVal = 70;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Tell us a bit about your body',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // ─────────── Age Slider ───────────
        _buildCustomSlider(
          label: 'Age',
          value: age,
          min: 18,
          max: 65,
          unit: '',
          onChanged: (val) {
            setState(() => age = val);
            _saveData();
          },
        ),

        const SizedBox(height: 24),

        // ─────────── Height Slider ───────────
        _buildCustomSlider(
          label: 'Height',
          value: heightVal,
          min: 140,
          max: 220,
          unit: '',
          onChanged: (val) {
            setState(() => heightVal = val);
            _saveData();
          },
        ),

        const SizedBox(height: 24),

        // ─────────── Weight Slider ───────────
        _buildCustomSlider(
          label: 'Weight',
          value: weightVal,
          min: 40,
          max: 150,
          unit: ' kg',
          onChanged: (val) {
            setState(() => weightVal = val);
            _saveData();
          },
        ),
      ],
    );
  }

  // Sends the data back up whenever a slider moves
  void _saveData() {
    widget.onSaved({
      'age': age,
      'height': heightVal,
      'weight': weightVal,
    });
  }

  // ─────────── Reusable Slider Builder ───────────
  Widget _buildCustomSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required String unit,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: Label & Value Pill
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF22E1A0),
                    Color(0xFF1E88E5),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${value.toInt()}$unit',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Middle Row: Custom Slider Track
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: const Color(0xFF22E1A0),
            inactiveTrackColor: Colors.grey.shade200,

            // 🌟 Here is your new custom gradient thumb!
            thumbShape: const GradientThumbShape(thumbRadius: 14),

            overlayShape: SliderComponentShape.noOverlay,
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        // Bottom Row: Min & Max Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${min.toInt()}',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              Text(
                '${max.toInt()}',
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




class _MainGoalStep extends StatefulWidget {
  final Function(List<String>) onSaved;

  const _MainGoalStep({required this.onSaved});

  @override
  State<_MainGoalStep> createState() => _MainGoalStepState();
}

class _MainGoalStepState extends State<_MainGoalStep> {
  // We use a Set to easily handle multiple selections!
  Set<String> selectedGoals = {};

  final List<Map<String, dynamic>> goals = [
    {'label': 'Fat Loss', 'icon': Icons.local_fire_department_outlined},
    {'label': 'Muscle Gain', 'icon': Icons.fitness_center},
    {'label': 'Strength', 'icon': Icons.bolt_outlined},
    {'label': 'General Health', 'icon': Icons.favorite_border},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "What's your main goal?",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        const Text(
          'You can select a secondary goal too',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 32),

        // Generate the list of goal cards
        ...goals.map((goal) {
          final isSelected = selectedGoals.contains(goal['label']);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  final label = goal['label'] as String;

                  if (selectedGoals.contains(label)) {
                    // Deselect if already tapped
                    selectedGoals.remove(label);
                  } else {
                    // Only allow up to 2 selections
                    if (selectedGoals.length < 2) {
                      selectedGoals.add(label);
                    }
                  }
                });

                // Send the list of selected goals back up
                widget.onSaved(selectedGoals.toList());
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  // Give it a subtle blue tint when selected
                  color: isSelected ? const Color(0xFF2979FF).withOpacity(0.05) : Colors.transparent,
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
                        color: isSelected ? Colors.white : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: isSelected ? Border.all(color: const Color(0xFF2979FF).withOpacity(0.3)) : null,
                      ),
                      child: Icon(
                        goal['icon'] as IconData,
                        color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      goal['label'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? const Color(0xFF2979FF) : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}

