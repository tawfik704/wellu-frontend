import 'package:flutter/material.dart';
import '../../../core/theme/app_gradients.dart';

class AIAssistantCard extends StatelessWidget {
  final VoidCallback onChatTap;

  const AIAssistantCard({
    super.key,
    required this.onChatTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Title
          const Text(
            "WellU AI Assistant",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Ask me anything about your wellness",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          // Suggestion Pills
          _buildSuggestion("I ate 2 eggs for breakfast"),
          const SizedBox(height: 10),
          _buildSuggestion("I just finished a 30-minute run"),
          const SizedBox(height: 10),
          _buildSuggestion("How can I improve my posture?"),

          const SizedBox(height: 20),

          // Chat Button
          GestureDetector(
            onTap: onChatTap,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Chat Now",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestion(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }
}
