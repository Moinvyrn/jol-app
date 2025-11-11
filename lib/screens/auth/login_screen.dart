import 'package:flutter/material.dart';
import 'package:jol_app/screens/auth/services/auth_services.dart';
import 'package:jol_app/screens/auth/signup_screen.dart';
import 'package:jol_app/screens/bnb/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFC42AF8);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isGoogleLoading = false;

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
              Color(0xFFFFC0CB),
              Color(0xFFADD8E6),
              Color(0xFFE6E6FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 80),
                    Text(
                      'LOGIN',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Digitalt',
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: Color(0xFFF82A87),
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Username / Email
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _inputField(
                        icon: Icons.email_outlined,
                        hint: "USERNAME OR EMAIL",
                        controller: _usernameController,
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
                        controller: _passwordController,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Forgot password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "FORGOT PASSWORD?",
                          style: const TextStyle(
                            fontFamily: 'Digitalt',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFFF82A87),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Divider(thickness: 1, color: LoginScreen.textPink),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "OR",
                              style: const TextStyle(
                                fontFamily: 'Digitalt',
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: LoginScreen.textPink,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(thickness: 1, color: LoginScreen.textPink),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Google Login Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _socialButton(
                        text: _isGoogleLoading
                            ? "SIGNING IN..."
                            : "CONTINUE WITH GMAIL",
                        icon: Image.asset(
                          "lib/assets/images/google.png",
                          height: 22,
                          width: 22,
                        ),
                        onTap: _isGoogleLoading ? null : _handleGoogleLogin,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Apple (still placeholder)
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

              // Bottom fixed
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Sign in button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: LoginScreen.textPink,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "SIGN IN",
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

                    // Signup link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "DON'T HAVE AN ACCOUNT?",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignupScreen()),
                            );
                          },
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontFamily: 'Digitalt',
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: LoginScreen.textPink,
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

  // 🟢 Handle standard login
  Future<void> _handleLogin() async {
    final input = _usernameController.text.trim();
    if (input.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final bool isEmail = input.contains('@');
    final String username = isEmail ? '' : input;
    final String email = isEmail ? input : '';

    setState(() => _isLoading = true);
    final result = await _authService.login(
      username,
      email,
      _passwordController.text,
    );
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error ?? 'Login failed.')),
      );
    }
  }

  // 🟢 Handle Google login
  Future<void> _handleGoogleLogin() async {
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
        SnackBar(content: Text(result.error ?? 'Google login failed.')),
      );
    }
  }

  // Input field
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
        border: Border.all(color: LoginScreen.textPink, width: 1.4),
        color: Colors.white.withOpacity(0.4),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: LoginScreen.textPink),
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Digitalt',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: LoginScreen.textPink,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // Social button
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
          border: Border.all(color: LoginScreen.textPink, width: 1.4),
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
                color: LoginScreen.textPink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Old dialog (still used for Apple placeholder)
  void _showSocialDialog(BuildContext context, String provider) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            "$provider Login",
            style: const TextStyle(
              fontFamily: 'Digitalt',
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: LoginScreen.textPink,
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
                  color: LoginScreen.textPink,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
