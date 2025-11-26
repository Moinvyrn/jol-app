import 'package:flutter/material.dart';
import 'package:jol_app/screens/auth/login_screen.dart';  // Import LoginScreen for navigation
import 'package:jol_app/screens/auth/services/auth_services.dart';
import 'package:jol_app/screens/bnb/home_screen.dart';  // Import HomeScreen for success navigation

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFC42AF8);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();  // AuthService instance
  final _usernameController = TextEditingController();  // For Username
  final _emailController = TextEditingController();  // For Email
  final _passwordController = TextEditingController();  // For Password
  final _confirmPasswordController = TextEditingController();  // For Confirm Password
  bool _isLoading = false;  // Loading state for register
  bool _isGoogleLoading = false;  // Loading state for Google

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFC0CB), // light pink
              Color(0xFFADD8E6), // light blue
              Color(0xFFE6E6FA), // lavender
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Scrollable content
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 160),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),

                    // Title
                    Text(
                      'CREATE NEW ACCOUNT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: Color(0xFFF82A87),
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Username (replaced Nick Name)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _inputField(
                        icon: Icons.person_pin_circle_outlined,
                        hint: "USERNAME",
                        controller: _usernameController,  // Assign controller
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email/Phone (as Email)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _inputField(
                        icon: Icons.email_outlined,
                        hint: "EMAIL",
                        controller: _emailController,  // Assign controller
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _inputField(
                        icon: Icons.lock_outline,
                        hint: "PASSWORD",
                        obscure: true,
                        controller: _passwordController,  // Assign controller
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _inputField(
                        icon: Icons.lock_outline,
                        hint: "CONFIRM PASSWORD",
                        obscure: true,
                        controller: _confirmPasswordController,  // Assign controller
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Terms text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Text(
                        "BY CONTINUING TO USE SALSIVO, YOU AGREE WITH THE JOLPUZZLE TERMS AND PRIVACY NOTICE.",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Digitalt',
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider with OR
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Divider(thickness: 1, color: SignupScreen.textPink),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                fontFamily: 'Digitalt',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: SignupScreen.textPink,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(thickness: 1, color: SignupScreen.textPink),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Google button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _socialButton(
                        text: _isGoogleLoading ? "SIGNING UP..." : "CONTINUE WITH GMAIL",
                        icon: Image.asset(
                          "lib/assets/images/google.png",
                          height: 22,
                          width: 22,
                        ),
                        onTap: _isGoogleLoading ? null : _handleGoogleSignup,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Apple button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _socialButton(
                        text: "CONTINUE WITH APPLE",
                        icon: Image.asset(
                          "lib/assets/images/apple.png",
                          height: 22,
                          width: 22,
                        ),
                        onTap: () {
                          _showSocialDialog(context, "Apple");
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Bottom fixed elements
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Register button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SignupScreen.textPink,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleRegister,  // Add handler, disable if loading
                        child: _isLoading  // Show loading if in progress
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "REGISTER",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bottom row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "ALREADY HAVE AN ACCOUNT?",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(  // Or pushNamed if using routes
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            "SIGN IN",
                            style: TextStyle(
                              fontFamily: 'Digitalt',
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: SignupScreen.textPink,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Add this method: Handle register logic
  Future<void> _handleRegister() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await _authService.register(username, email, password, confirmPassword);
    setState(() => _isLoading = false);

    if (result.success) {
      // Success: Navigate to home (no verification)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Failure: Show error from service
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error ?? 'Registration failed. Try again.')),
      );
    }
  }

  // 🟢 Handle Google signup (mirroring login implementation)
  Future<void> _handleGoogleSignup() async {
    setState(() => _isGoogleLoading = true);
    final result = await _authService.googleSignIn();
    setState(() => _isGoogleLoading = false);

    if (result.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error ?? 'Google signup failed.')),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Input field widget (updated to accept controller and prevent capitalization)
  Widget _inputField({
    required IconData icon,
    required String hint,
    TextEditingController? controller,
    bool obscure = false,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SignupScreen.textPink, width: 1.4),
        color: Colors.white.withOpacity(0.4),
      ),
      child: TextField(
        controller: controller,  // Use controller
        textCapitalization: TextCapitalization.none,  // Prevent auto-capitalization
        obscureText: obscure,
        style: const TextStyle(
          // fontFamily: 'Digitalt',  // Simplified for input (system font to avoid issues)
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: SignupScreen.textPink),
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'Digitalt',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: SignupScreen.textPink,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // Social button widget
  Widget _socialButton({
    required String text,
    required Widget icon,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: SignupScreen.textPink, width: 1.4),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.5),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            icon,
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontFamily: 'Digitalt',
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: SignupScreen.textPink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Social login dialog
  void _showSocialDialog(BuildContext context, String provider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "$provider Sign Up",  // Updated to Sign Up
            style: const TextStyle(
              fontFamily: 'Digitalt',
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: SignupScreen.textPink,
            ),
          ),
          content: Text(
            "This is where $provider authentication will happen.",
            style: const TextStyle(
              fontFamily: 'Digitalt',
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text(
                "CLOSE",
                style: TextStyle(
                  fontFamily: 'Digitalt',
                  fontWeight: FontWeight.w700,
                  color: SignupScreen.textPink,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}