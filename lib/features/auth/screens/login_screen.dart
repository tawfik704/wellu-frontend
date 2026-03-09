import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wellu1/features/home/home_screen.dart';
// import '../../home/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Logic: Controllers for login
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Logic: Function to authenticate with Rola's backend
  Future<void> loginUser() async {
    final url = Uri.parse("http://10.0.2.2:8081/user/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // 👇 WE NEED TO SEE WHAT THIS PRINTS!
        print("📦 EXACT BACKEND RESPONSE: ${response.body}");

        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Using 'dynamic' so it doesn't crash if it's not a String
        final dynamic jwtToken = responseData['Token'];
        print("🔑 FOUND TOKEN: $jwtToken");

        if (jwtToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', jwtToken.toString());
        }

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );

      } else {
        if (!mounted) return;
        _showErrorDialog();
      }
    } catch (e) {
      // 👇 THIS IS THE MOST IMPORTANT PRINT STATEMENT!
      print("🚨 THE REAL CRASH CAUSE: $e");

      if (!mounted) return;
      _showErrorDialog();
    }
  }
  // Logic: Modern Error Popup
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 10)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Shrinks to fit content
              children: [
                // Big Red X Icon
                const Icon(
                  Icons.cancel,
                  color: Colors.redAccent,
                  size: 70,
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  "Login Failed",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Subtitle / Message
                const Text(
                  "Invalid username and password.\nPlease check your details and try again.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 30),

                // Try Again Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C853), Color(0xFF2979FF)],
                  ),
                ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Closes the popup!
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Try Again",
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ),
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // Welcome Text
              const Center(
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Log in to continue your wellness journey',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),

              const SizedBox(height: 50),

              const _FieldLabel(text: 'Email Address'),
              _InputField(
                hint: 'your.email@example.com',
                icon: Icons.mail_outline,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              const _FieldLabel(text: 'Password'),
              _InputField(
                hint: 'Enter your password',
                icon: Icons.lock_outline,
                obscureText: true,
                controller: passwordController,
              ),

              // Forgot Password Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Color(0xFF2979FF), fontWeight: FontWeight.w600)
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Login Button with Gradient
              SizedBox(
                width: double.infinity,
                height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00C853), Color(0xFF2979FF)],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('or')),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 30),
              const _SocialButton(text: 'Continue with Google', icon: Icons.g_mobiledata_rounded),
              const SizedBox(height: 16),
              const _SocialButton(text: 'Continue with Apple', icon: Icons.apple),

              const SizedBox(height: 40),

              // Link to Sign Up
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context); // Goes back to Sign Up if we came from there
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(color: Color(0xFF2979FF), fontWeight: FontWeight.w600),
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

// ─────────── Helper Widgets ───────────
// I included these here so the file works out of the box!

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
  });
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Color(0xFF2979FF), width: 2),
        ),
      ),
    );
  }
}

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
        label: Text(text, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 16)),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    );
  }
}