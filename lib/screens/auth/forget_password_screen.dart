import 'package:flutter/material.dart';
import 'package:jol_app/screens/auth/services/auth_services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFC42AF8);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handlePasswordReset() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
      return;
    }

    // Basic email validation
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await _authService.requestPasswordReset(email);
    setState(() => _isLoading = false);

    if (result.success) {
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ForgotPasswordScreen.textGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mark_email_read_outlined,
                  color: ForgotPasswordScreen.textGreen,
                  size: 50,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'EMAIL SENT!',
                style: TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF82A87),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          content: const Text(
            'A password reset link has been sent to your email address. Please check your inbox and follow the instructions.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ForgotPasswordScreen.textPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'BACK TO LOGIN',
                  style: TextStyle(
                    fontFamily: 'Digitalt',
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.error ?? 'Failed to send reset email.'),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

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
                    const SizedBox(height: 40),

                    // Back button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ForgotPasswordScreen.textPink,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Icon
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_reset,
                          size: 60,
                          color: Color(0xFFF82A87),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Title
                    const Text(
                      'FORGOT PASSWORD?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: Color(0xFFF82A87),
                        letterSpacing: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Description
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: const Text(
                        'ENTER YOUR EMAIL ADDRESS AND WE\'LL SEND YOU A LINK TO RESET YOUR PASSWORD.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Digitalt',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                          height: 1.5,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email input
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: _inputField(
                        icon: Icons.email_outlined,
                        hint: "EMAIL ADDRESS",
                        controller: _emailController,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),

              // Bottom fixed button
              Positioned(
                left: 0,
                right: 0,
                bottom: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Submit button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ForgotPasswordScreen.textPink,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handlePasswordReset,
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
                          "SEND RESET LINK",
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

                    // Back to login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "REMEMBER YOUR PASSWORD?",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontFamily: 'Digitalt',
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                              color: ForgotPasswordScreen.textPink,
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

  Widget _inputField({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ForgotPasswordScreen.textPink, width: 1.4),
        color: Colors.white.withOpacity(0.4),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: ForgotPasswordScreen.textPink),
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: 'Digitalt',
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: ForgotPasswordScreen.textPink,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}