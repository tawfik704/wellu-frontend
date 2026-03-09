import 'package:flutter/material.dart';
import 'dart:convert'; // 🌟 This gives you the jsonEncode superpower!
 import '../../home/home_screen.dart'; // Make sure your path is correct!
import '../screens/user_profile_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  int currentStep = 0;
  static const int totalSteps = 11;

  // 🌟 Your brand new, strongly-typed Data Model!
  final UserProfileModel userProfile = UserProfileModel();

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
              const SizedBox(height: 40),

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
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              // ─────────── Card ───────────
              Expanded(
                child: Center(
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
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildStepContent(),
                            const SizedBox(height: 32),

                            // ─────────── Dynamic Bottom Buttons ───────────
                            if (currentStep == 10) ...[
                              // 🌟 Step 11: Final Summary Screen (Stacked Buttons)
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00C853), Color(0xFF2979FF)],
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      // 1. Wait for the profile to be sent to Rola's backend! ⏳
                                      await submitProfile();

                                      // 2. Safety check: make sure the screen is still visible
                                      if (!context.mounted) return;

                                      // 3. Blast off to the Home Screen! 🚀
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const HomeScreen(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(28),
                                      ),
                                    ),
                                    child: const Text(
                                      'Generate My Personalized Plan',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: OutlinedButton(
                                  onPressed: () {
                                    setState(() => currentStep = 0);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(28),
                                    ),
                                  ),
                                  child: const Text(
                                    'Edit Profile',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ] else if (currentStep == 4 || currentStep == 9) ...[
                              // 🌟 Steps 5 & 10: Skip & Continue
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 60,
                                      child: OutlinedButton(
                                        onPressed: _nextStep,
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(28),
                                          ),
                                        ),
                                        child: const Text(
                                          'Skip',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: SizedBox(
                                      height: 60,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(28),
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF00C853), Color(0xFF2979FF)],
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
                                          child: const Text(
                                            'Continue',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ] else ...[
                              // 🌟 All other steps: Single Main Button
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(28),
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFF00C853), Color(0xFF2979FF)],
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
                                      currentStep == 0 ? 'Start' : 'Continue',
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Logic: Send the complete profile to the backend!
  Future<void> submitProfile() async {
    // 1. Grab the saved VIP Pass (Token) 🎟️
    final prefs = await SharedPreferences.getInstance();
    final String? myToken = prefs.getString('auth_token');

    if (myToken == null) {
      print("❌ No token found! The user might not be logged in.");
      // You could redirect them back to the login screen here!
      return;
    }

    // 2. The Backend Endpoint
    // ⚠️ Ask Rola what the exact path is! (I guessed /user/profile)
    final url = Uri.parse("http://10.0.2.2:8081/user/profile");

    try {
      // 3. Post the data! 📦
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $myToken", // 🔐 Attaching your token!
        },
        body: jsonEncode(userProfile.toJson()), // 🪄 Your magical Model!
      );

      // 4. Check the server's response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Profile successfully saved to the database!");

        if (!mounted) return;

        // 🚀 Blast off to the Home Screen!
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );

      } else {
        print("❌ Server rejected the profile. Status: ${response.statusCode}");
        print("Backend said: ${response.body}");

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to save profile: ${response.body}")),
        );
      }
    } catch (e) {
      print("💥 Connection error: $e");

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connection failed. Check your network.")),
      );
    }
  }


  // 🌟 Updated to use your new Model!
  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _GoalStep(onSelected: (val) => userProfile.goal = val);
      case 1:
        return _GenderStep(
          onSelected: (val) => userProfile.gender = val,
          onBack: () => setState(() => currentStep--),
        );
      case 2:
        return _BodyStatsStep(onSaved: (val) {
          userProfile.age = val['age'];
          userProfile.height = val['height'];
          userProfile.weight = val['weight'];
        });
      case 3:
        return _MainGoalStep(onSaved: (val) => userProfile.mainGoals = val);
      case 4:
        return _PrecisionStep(onSaved: (val) {
          userProfile.bodyType = val['bodyType'] as String?;
          userProfile.bodyFat = val['bodyFat'] as double?;
          userProfile.muscleMass = val['muscleMass'] as String?;
        });
      case 5:
        return _FitnessLevelStep(onSaved: (val) => userProfile.fitnessLevel = val);
      case 6:
        return _TrainingPreferenceStep(onSaved: (val) {
          userProfile.duration = val['duration'];
          userProfile.intensity = val['intensity'];
        });
      case 7:
        return _WorkoutTimeStep(onSaved: (val) => userProfile.workoutTime = val);
      case 8:
        return _DietPreferenceStep(onSaved: (val) => userProfile.diet = val);
      case 9:
        return _InjuryStep(onSaved: (val) => userProfile.injuries = val);
      case 10:
        return _SummaryStep(data: userProfile); // Pass the model down
      default:
        return const Text('Next steps coming...');
    }
  }

  void _nextStep() {
    if (currentStep < totalSteps - 1) {
      setState(() {
        currentStep++;
      });
    }
  }
}

// ─────────── Step Widgets ───────────

class _GoalStep extends StatefulWidget {
  final Function(String) onSelected;
  const _GoalStep({required this.onSelected});
  @override
  State<_GoalStep> createState() => _GoalStepState();
}

class _GoalStepState extends State<_GoalStep> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Icon(Icons.track_changes, size: 64, color: Color(0xFF2979FF)),
        SizedBox(height: 16),
        Text(
          "Let's build your WellU profile",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'No forms. Just a few smart choices.',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),
      ],
    );
  }
}

class _GenderStep extends StatefulWidget {
  final Function(String) onSelected;
  final VoidCallback onBack;
  const _GenderStep({required this.onSelected, required this.onBack});
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
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...genders.map((gender) {
          final isSelected = selectedGender == gender['label'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedGender = gender['label'] as String);
                widget.onSelected(gender['label'] as String);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade300,
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
                      child: Icon(gender['icon'] as IconData, color: Colors.grey.shade700),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      gender['label'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 16),
        TextButton(
          onPressed: widget.onBack,
          child: const Text('Back', style: TextStyle(decoration: TextDecoration.underline)),
        ),
      ],
    );
  }
}

class GradientThumbShape extends SliderComponentShape {
  final double thumbRadius;
  const GradientThumbShape({this.thumbRadius = 14.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.fromRadius(thumbRadius);

  @override
  void paint(
      PaintingContext context, Offset center, {
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
    final Paint gradientPaint = Paint()
      ..shader = const LinearGradient(colors: [Color(0xFF22E1A0), Color(0xFF1E88E5)])
          .createShader(Rect.fromCircle(center: center, radius: thumbRadius))
      ..style = PaintingStyle.fill;
    final Paint whitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRadius, gradientPaint);
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
  double age = 25;
  double heightVal = 170;
  double weightVal = 70;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Tell us a bit about your body',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _buildCustomSlider(
          label: 'Age', value: age, min: 18, max: 65, unit: '',
          onChanged: (val) { setState(() => age = val); _saveData(); },
        ),
        const SizedBox(height: 24),
        _buildCustomSlider(
          label: 'Height', value: heightVal, min: 140, max: 220, unit: '',
          onChanged: (val) { setState(() => heightVal = val); _saveData(); },
        ),
        const SizedBox(height: 24),
        _buildCustomSlider(
          label: 'Weight', value: weightVal, min: 40, max: 150, unit: ' kg',
          onChanged: (val) { setState(() => weightVal = val); _saveData(); },
        ),
      ],
    );
  }

  void _saveData() {
    widget.onSaved({'age': age, 'height': heightVal, 'weight': weightVal});
  }

  Widget _buildCustomSlider({
    required String label, required double value, required double min,
    required double max, required String unit, required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF22E1A0), Color(0xFF1E88E5)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${value.toInt()}$unit',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: const Color(0xFF22E1A0),
            inactiveTrackColor: Colors.grey.shade200,
            thumbShape: const GradientThumbShape(thumbRadius: 14),
            overlayShape: SliderComponentShape.noOverlay,
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min.toInt()}', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              Text('${max.toInt()}', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
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
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'You can select a secondary goal too',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...goals.map((goal) {
          final isSelected = selectedGoals.contains(goal['label']);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  final label = goal['label'] as String;
                  if (selectedGoals.contains(label)) {
                    selectedGoals.remove(label);
                  } else {
                    if (selectedGoals.length < 2) selectedGoals.add(label);
                  }
                });
                widget.onSaved(selectedGoals.toList());
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2979FF).withOpacity(0.05) : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade300,
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

class _PrecisionStep extends StatefulWidget {
  final Function(Map<String, dynamic>) onSaved;
  const _PrecisionStep({required this.onSaved});
  @override
  State<_PrecisionStep> createState() => _PrecisionStepState();
}

class _PrecisionStepState extends State<_PrecisionStep> {
  String? selectedBodyType;
  bool showAdvancedNumbers = false;
  double bodyFat = 20;
  String? selectedMuscleMass;
  final List<Map<String, dynamic>> bodyTypes = [
    {'label': 'Lean / Athletic', 'icon': Icons.monitor_heart_outlined},
    {'label': 'Average', 'icon': Icons.person_outline},
    {'label': 'Soft', 'icon': Icons.account_circle_outlined},
    {'label': 'Overfat', 'icon': Icons.group_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Want us to be more precise?",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'This helps us personalize better',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...bodyTypes.map((type) {
          final isSelected = selectedBodyType == type['label'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedBodyType = type['label'] as String);
                _saveData();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2979FF).withOpacity(0.05) : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade300,
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
                        type['icon'] as IconData,
                        color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      type['label'] as String,
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
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: OutlinedButton(
            onPressed: () => setState(() => showAdvancedNumbers = !showAdvancedNumbers),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child: Text(
              showAdvancedNumbers ? '- Hide' : '+ I know my numbers',
              style: TextStyle(
                color: showAdvancedNumbers ? Colors.grey.shade500 : Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (showAdvancedNumbers) ...[
          const SizedBox(height: 32),
          _buildCustomSlider(
            label: 'Body Fat %', value: bodyFat, min: 5, max: 50, unit: ' %',
            onChanged: (val) { setState(() => bodyFat = val); _saveData(); },
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Muscle Mass', style: TextStyle(fontSize: 16, color: Colors.black87)),
              const SizedBox(height: 12),
              Row(
                children: ['Low', 'Medium', 'High'].map((level) {
                  final isSelected = selectedMuscleMass == level;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: level != 'High' ? 8.0 : 0,
                        left: level != 'Low' ? 8.0 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () { setState(() => selectedMuscleMass = level); _saveData(); },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF22E1A0).withOpacity(0.05) : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF22E1A0) : Colors.grey.shade300,
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            level,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected ? const Color(0xFF00C853) : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _saveData() {
    widget.onSaved({
      'bodyType': selectedBodyType,
      'bodyFat': showAdvancedNumbers ? bodyFat : null,
      'muscleMass': showAdvancedNumbers ? selectedMuscleMass : null,
    });
  }

  Widget _buildCustomSlider({
    required String label, required double value, required double min,
    required double max, required String unit, required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF22E1A0), Color(0xFF1E88E5)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${value.toInt()}$unit',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: const Color(0xFF22E1A0),
            inactiveTrackColor: Colors.grey.shade200,
            thumbShape: const GradientThumbShape(thumbRadius: 14),
            overlayShape: SliderComponentShape.noOverlay,
            trackShape: const RoundedRectSliderTrackShape(),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min.toInt()}', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
              Text('${max.toInt()}', style: TextStyle(color: Colors.grey.shade400, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}

class _FitnessLevelStep extends StatefulWidget {
  final Function(String) onSaved;
  const _FitnessLevelStep({required this.onSaved});
  @override
  State<_FitnessLevelStep> createState() => _FitnessLevelStepState();
}

class _FitnessLevelStepState extends State<_FitnessLevelStep> {
  String? selectedLevel;
  final List<Map<String, dynamic>> levels = [
    {'title': 'Beginner', 'subtitle': 'New to fitness', 'icon': Icons.show_chart},
    {'title': 'Intermediate', 'subtitle': 'Regular workouts', 'icon': Icons.trending_up},
    {'title': 'Advanced', 'subtitle': 'Experienced athlete', 'icon': Icons.bolt_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "How would you describe your fitness level?",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...levels.map((level) {
          final isSelected = selectedLevel == level['title'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedLevel = level['title'] as String);
                widget.onSaved(selectedLevel!);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2979FF).withOpacity(0.05) : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade300,
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
                        level['icon'] as IconData,
                        color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level['title'] as String,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected ? const Color(0xFF2979FF) : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          level['subtitle'] as String,
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                        ),
                      ],
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

class _TrainingPreferenceStep extends StatefulWidget {
  final Function(Map<String, String>) onSaved;
  const _TrainingPreferenceStep({required this.onSaved});
  @override
  State<_TrainingPreferenceStep> createState() => _TrainingPreferenceStepState();
}

class _TrainingPreferenceStepState extends State<_TrainingPreferenceStep> {
  String? selectedDuration;
  String? selectedIntensity;
  final List<String> durations = ['30 minutes', '45 minutes', '60 minutes'];
  final List<Map<String, dynamic>> intensities = [
    {'label': 'Low intensity', 'icon': Icons.show_chart},
    {'label': 'High intensity', 'icon': Icons.local_fire_department_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "How do you prefer to train?",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 32),
        const Text('Duration', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        ...durations.map((duration) => _buildOptionCard(
          label: duration,
          icon: Icons.access_time,
          isSelected: selectedDuration == duration,
          onTap: () { setState(() => selectedDuration = duration); _saveData(); },
        )).toList(),
        const SizedBox(height: 16),
        const Text('Intensity', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        ...intensities.map((intensity) => _buildOptionCard(
          label: intensity['label'] as String,
          icon: intensity['icon'] as IconData,
          isSelected: selectedIntensity == intensity['label'],
          onTap: () { setState(() => selectedIntensity = intensity['label'] as String); _saveData(); },
        )).toList(),
      ],
    );
  }

  void _saveData() {
    if (selectedDuration != null && selectedIntensity != null) {
      widget.onSaved({'duration': selectedDuration!, 'intensity': selectedIntensity!});
    }
  }

  Widget _buildOptionCard({
    required String label, required IconData icon, required bool isSelected, required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2979FF).withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade300,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected ? Border.all(color: const Color(0xFF2979FF).withOpacity(0.3)) : null,
                ),
                child: Icon(icon, color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade700, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                label,
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
  }
}

class _WorkoutTimeStep extends StatefulWidget {
  final Function(String) onSaved;
  const _WorkoutTimeStep({required this.onSaved});
  @override
  State<_WorkoutTimeStep> createState() => _WorkoutTimeStepState();
}

class _WorkoutTimeStepState extends State<_WorkoutTimeStep> {
  String? selectedTime;
  final List<Map<String, dynamic>> times = [
    {'label': 'Morning', 'icon': Icons.wb_twilight},
    {'label': 'Afternoon', 'icon': Icons.light_mode_outlined},
    {'label': 'Evening', 'icon': Icons.brightness_3_outlined},
    {'label': 'Night', 'icon': Icons.dark_mode_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "When do you usually work out?",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...times.map((time) {
          final isSelected = selectedTime == time['label'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedTime = time['label'] as String);
                widget.onSaved(selectedTime!);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF22E1A0).withOpacity(0.08) : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF22E1A0) : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(colors: [Color(0xFF2979FF), Color(0xFF1E88E5)])
                            : null,
                        color: isSelected ? null : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(time['icon'] as IconData, color: isSelected ? Colors.white : Colors.grey.shade700),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      time['label'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? const Color(0xFF22E1A0) : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF22E1A0), size: 24),
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

class _DietPreferenceStep extends StatefulWidget {
  final Function(String) onSaved;
  const _DietPreferenceStep({required this.onSaved});
  @override
  State<_DietPreferenceStep> createState() => _DietPreferenceStepState();
}

class _DietPreferenceStepState extends State<_DietPreferenceStep> {
  String? selectedDiet;
  final List<Map<String, dynamic>> diets = [
    {'label': 'Omnivore', 'icon': Icons.restaurant},
    {'label': 'Vegetarian', 'icon': Icons.soup_kitchen_outlined},
    {'label': 'Vegan', 'icon': Icons.eco_outlined},
    {'label': 'Mediterranean', 'icon': Icons.set_meal_outlined},
    {'label': 'Lactose-Free', 'icon': Icons.water_drop_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "How do you usually eat?",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...diets.map((diet) {
          final isSelected = selectedDiet == diet['label'];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() => selectedDiet = diet['label'] as String);
                widget.onSaved(selectedDiet!);
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2979FF).withOpacity(0.05) : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade300,
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
                      child: Icon(diet['icon'] as IconData, color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade700),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      diet['label'] as String,
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

class _InjuryStep extends StatefulWidget {
  final Function(List<String>) onSaved;
  const _InjuryStep({required this.onSaved});
  @override
  State<_InjuryStep> createState() => _InjuryStepState();
}

class _InjuryStepState extends State<_InjuryStep> {
  Set<String> selectedAreas = {};
  final List<String> areas = ['Knee', 'Shoulder', 'Lower Back'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Anything we should be careful with?",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Select any areas of concern',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ...areas.map((area) {
          final isSelected = selectedAreas.contains(area);
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedAreas.remove(area);
                  } else {
                    selectedAreas.add(area);
                  }
                });
                widget.onSaved(selectedAreas.toList());
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2979FF).withOpacity(0.05) : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade300,
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
                      child: Icon(Icons.error_outline, color: isSelected ? const Color(0xFF2979FF) : Colors.grey.shade700),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      area,
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

// 🌟 Updated to read from your new Model!
class _SummaryStep extends StatelessWidget {
  final UserProfileModel data;
  const _SummaryStep({required this.data});

  @override
  Widget build(BuildContext context) {
    final age = data.age?.toInt() ?? 25;
    final height = data.height?.toInt() ?? 170;
    final weight = data.weight?.toInt() ?? 70;
    final gender = (data.gender ?? 'Not specified').toLowerCase();

    final goalsStr = (data.mainGoals ?? ['Health']).join(' & ').toLowerCase();
    final level = (data.fitnessLevel ?? 'beginner').toLowerCase();

    final duration = data.duration ?? '60 minutes';
    final intensity = (data.intensity ?? 'low intensity').toLowerCase();
    final time = (data.workoutTime ?? 'morning').toLowerCase();

    final diet = (data.diet ?? 'Not specified').toLowerCase();

    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [Color(0xFF22E1A0), Color(0xFF1E88E5)]),
          ),
          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 16),
        const Text(
          "Here's your WellU profile",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Review your personalized settings',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _buildSummaryCard(title: 'Body Basics', content: '$age years • $height cm • $weight kg • $gender'),
        _buildSummaryCard(title: 'Fitness', content: 'Goal: $goalsStr • Level: $level'),
        _buildSummaryCard(title: 'Workout Preferences', content: '${duration.replaceAll(' minutes', ' min')} • $intensity • $time'),
        _buildSummaryCard(title: 'Nutrition', content: diet),
      ],
    );
  }

  Widget _buildSummaryCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        ],
      ),
    );
  }
}

// ─────────── The Data Model ───────────
// 🌟 I added this right to the bottom so it works instantly!
// You can cut this out and put it in a separate `user_profile_model.dart` file later!
