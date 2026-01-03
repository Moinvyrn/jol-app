import 'package:flutter/material.dart';

class MonetizationScreen extends StatefulWidget {
  const MonetizationScreen({super.key});

  @override
  State<MonetizationScreen> createState() => _MonetizationScreenState();
}

class _MonetizationScreenState extends State<MonetizationScreen> {
  static const Color textPink = Color(0xFFF82A87);
  static const Color accentPurple = Color(0xFFC42AF8);

  // Plan data
  final String currentPlan = "Gold";

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(context),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "PLANS",
                  style: TextStyle(
                    fontFamily: 'Digitalt',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _currentPlanCard(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: textPink.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          "UPGRADE OPTIONS",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _planCard(
                        name: "Silver",
                        price: "€ 50",
                        color: const Color(0xFF4CAF50),
                        buttonColor: accentPurple,
                        onTap: () => _showSnack("Silver upgrade tapped"),
                      ),
                      _planCard(
                        name: "Bronze",
                        price: "FREE",
                        color: const Color(0xFFFC6839),
                        buttonColor: Colors.blue.shade900,
                        onTap: () => _showSnack("Bronze upgrade tapped"),
                      ),
                      _planCard(
                        name: "Gold",
                        price: "€ 200",
                        color: const Color(0xFF7A3C14),
                        buttonColor: Colors.grey.shade700,
                        disabled: true,
                      ),
                      _planCard(
                        name: "Platinum",
                        price: "€ 300",
                        color: const Color(0xFF4A4A4A),
                        buttonColor: Color(0xFF247D91),
                        onTap: () => _showSnack("Platinum upgrade tapped"),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 6,
        left: 12,
        right: 12,
        bottom: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: textPink,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            "Monetization Plans",
            style: TextStyle(
              fontFamily: "Rubik",
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _currentPlanCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentPurple,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CURRENT",
            style: TextStyle(
              fontFamily: 'Digitalt',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.8), thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "STATUS:",
                style: TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                currentPlan.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _planCard({
    required String name,
    required String price,
    required Color color,
    required Color buttonColor,
    bool disabled = false,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'Digitalt',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Divider(color: Colors.white.withOpacity(0.7), thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "PRICE:",
                style: TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: disabled ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.white, width: 2),
                ),
                disabledBackgroundColor: Colors.grey.shade700,
                disabledForegroundColor: Colors.white70,
              ),
              child: const Text(
                "Upgrade Now",
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
