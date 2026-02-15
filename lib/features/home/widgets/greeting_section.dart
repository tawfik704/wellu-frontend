import 'package:flutter/material.dart';

class GreetingSection extends StatelessWidget {
  final String name;

  const GreetingSection({super.key, required this.name});

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) return "Good Morning";
    if (hour < 18) return "Good Afternoon";
    return "Good Evening";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${_getGreeting()}, $name",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          "Let's make today amazing!",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
