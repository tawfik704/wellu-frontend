import 'package:flutter/material.dart';
import '../../onboarding/screens/profile_setup.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ─────────── Top Card (Image Placeholder) ───────────
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ─────────── Title ───────────
              const Center(
                child: Text(
                  'Create Your WellU Account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ─────────── Subtitle ───────────
              const Center(
                child: Text(
                  'Sign up to personalize your workouts,\n'
                      'nutrition, and wellness guidance',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // ─────────── Full Name ───────────
              const _FieldLabel(text: 'Full Name'),
              const _InputField(
                hint: 'Enter your full name',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 20),

              // ─────────── Email ───────────
              const _FieldLabel(text: 'Email Address'),
              const _InputField(
                hint: 'your.email@example.com',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              // ─────────── Password ───────────
              const _FieldLabel(text: 'Password'),
              const _InputField(
                hint: 'Create a strong password',
                icon: Icons.lock_outline,
                obscureText: true,
              ),

              const SizedBox(height: 20),

              // ─────────── Confirm Password ───────────
              const _FieldLabel(text: 'Confirm Password'),
              const _InputField(
                hint: 'Re-enter your password',
                icon: Icons.lock_outline,
                obscureText: true,
              ),

              const SizedBox(height: 30),

              // ─────────── Sign Up Button ───────────
              SizedBox(
                width: double.infinity,
                height: 56,
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileSetupScreen(),
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
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ─────────── Divider OR ───────────
              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 24),

              // ─────────── Google Button ───────────
              _SocialButton(
                text: 'Continue with Google',
                icon: Icons.g_mobiledata_rounded,
              ),

              const SizedBox(height: 16),

              // ─────────── Apple Button ───────────
              _SocialButton(
                text: 'Continue with Apple',
                icon: Icons.apple,
              ),

              const SizedBox(height: 32),

              // ─────────── Bottom Text ───────────
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: Color(0xFF2979FF),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
// -------------------------------------------------
// PASTE THESE WIDGETS AT THE END OF YOUR FILE
// -------------------------------------------------

/// A private helper widget for displaying a field label.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}

/// A private helper widget for a styled text input field.
class _InputField extends StatelessWidget {
  const _InputField({
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),

        // Fallback border
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0),
            width: 1.5,
          ),
        ),

        // Border when NOT focused
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFFE0E0E0), // light grey
            width: 1.5,
          ),
        ),

        // Border when focused
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFF2979FF), // your blue brand color
            width: 2,
          ),
        ),
      ),

    );
  }
}

/// A private helper widget for social login buttons.
class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.black87),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}