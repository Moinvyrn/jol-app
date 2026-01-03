import 'package:flutter/material.dart';
import 'package:jol_app/screens/settings/monetization_screen.dart';
import 'package:jol_app/screens/settings/remove_adds_screen.dart';

class MoneyScreen extends StatefulWidget {
  const MoneyScreen({super.key});

  @override
  State<MoneyScreen> createState() => _MoneyScreenState();
}

class _MoneyScreenState extends State<MoneyScreen> {
  static const Color textPink = Color(0xFFF82A87);
  static const Color textGreen = Color(0xFF4CAF50);
  static const Color accentPurple = Color(0xFF9B4BFF);

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Widget _walletCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: const Border(
          left: BorderSide(color: Colors.white, width: 2),
          right: BorderSide(color: Colors.white, width: 2),
          top: BorderSide(color: Colors.white, width: 2),
          bottom: BorderSide.none, // 👈 no border at the bottom
        ),
        color: Color(0xFFd66bff),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "WALLET",
            style: TextStyle(
              fontFamily: 'Digitalt',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          Divider(
              color: Colors.white.withOpacity(0.5), thickness: 1, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "TOTAL \nEARNIN",
                style: TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 18,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const Text(
                "€ 100",
                style: TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  top: BorderSide(color: Colors.white, width: 2),
                  left: BorderSide(color: Colors.white, width: 2),
                  right: BorderSide(color: Colors.white, width: 2),
                ),
              ),
              child: ElevatedButton(
                onPressed: () => _showSnack("Withdraw tapped"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Withdraw Now",
                  style: TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "MAX WITHDRAW DAY: € 50",
            style: TextStyle(
              fontFamily: 'Digitalt',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuRow(String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            Text(
              text.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'Digitalt',
                fontSize: 18,
                color: textPink,
                letterSpacing: 0.5,
              ),
            ),
            const Spacer(),
            Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: textPink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_forward_ios,
                    color: Colors.white, size: 12)),
          ],
        ),
      ),
    );
  }

  Widget _giftButton() {
    return SizedBox(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: const Border(
            top: BorderSide(color: Colors.white, width: 2),
            left: BorderSide(color: Colors.white, width: 2),
            right: BorderSide(color: Colors.white, width: 2),
          ),
        ),
        child: ElevatedButton(
          onPressed: () => _showSnack("Send Gift tapped"),
          style: ElevatedButton.styleFrom(
            backgroundColor: textGreen,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            "Send gift to family & Friends",
            style: TextStyle(
              fontFamily: 'Rubik',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
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
                          "MONEY MATTERS",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _walletCard(),
                      const SizedBox(height: 16),
                      _menuRow(
                          "Refer & Earn", () => _showSnack("Refer tapped")),
                      _menuRow("Daily Check-in & Get Points",
                          () => _showSnack("Daily check-in tapped")),
                      _menuRow(
                        "Remove Ads",
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RemoveAddsScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _giftButton(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
              "Money",
              style: TextStyle(
                fontFamily: "Rubik",
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            // 👇 New icon button for monetisation screen
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MonetizationScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: textPink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.upgrade, // 💰 you can change to any relevant icon
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
