import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const Color textBlue = Color(0xFF0734A5);
  static const Color textPink = Color(0xFFF82A87);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
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
                      "Notifications",
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
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  children: [
                    _buildNotificationCard(
                      icon: Icons.card_giftcard,
                      title: "Congratulations! You've successfully unlocked 10 coupons.",
                      subtitle: "Don't miss out—redeem them now!",
                      time: "24-10-2024 | 12:32 PM",
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationCard(
                      icon: Icons.monetization_on,
                      title: "Treasure found! You earned 500 coins.",
                      time: "24-10-2024 | 12:32 PM",
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationCard(
                      icon: Icons.local_fire_department,
                      title: "Combo master! 🔥 New Fire Blast Booster unlocked.",
                      time: "24-10-2024 | 12:32 PM",
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationCard(
                      icon: Icons.card_giftcard,
                      title: "Congratulations! You've successfully unlocked 10 coupons.",
                      subtitle: "Don't miss out—redeem them now!",
                      time: "24-10-2024 | 12:32 PM",
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

  Widget _buildNotificationCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: textPink,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: "Rubik",
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: "Rubik",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    time,
                    style: const TextStyle(
                      fontFamily: "Rubik",
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}