import 'package:flutter/material.dart';

class CouponScreen extends StatefulWidget {
  const CouponScreen({super.key});

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  static const Color textPink = Color(0xFFF82A87);

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
              Color(0xFFFFC0CB), // light pink
              Color(0xFFADD8E6), // light blue
              Color(0xFFE6E6FA), // lavender
            ],
          ),
        ),
        child: Column(
          children: [
            _buildAppBar(context),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: const [
                    CouponCard(
                      title: "MOVE+10",
                      statusText: "Expire On 15:10:2025",
                      statusColor: Color(0xFFC42AF8),
                      description:
                      "GET +10 EXTRA MOVES IN JOL PUZZLE. APPLIES TO ANY LEVEL.",
                      code: "2298AZ12",
                      codeEnabled: true,
                    ),
                    SizedBox(height: 14),
                    CouponCard(
                      title: "SKIP-1",
                      statusText: "Expired",
                      statusColor: Colors.red,
                      description:
                      "SKIP ANY ONE LEVEL INSTANTLY. NOT VALID ON BOSS LEVELS.",
                      code: "2298AZ12",
                      codeEnabled: false,
                    ),
                    SizedBox(height: 14),
                    CouponCard(
                      title: "GOLD",
                      statusText: "Used",
                      statusColor: Colors.red,
                      description:
                      "CLAIM GOLD MONETIZATION BY USING COUPON",
                      code: "9210AZC1",
                      codeEnabled: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.5),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: textPink,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            "My Coupons",
            style: TextStyle(
              fontFamily: "Rubik",
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

/// Coupon Card Widget
class CouponCard extends StatelessWidget {
  final String title;
  final String statusText;
  final Color statusColor;
  final String description;
  final String code;
  final bool codeEnabled;

  const CouponCard({
    super.key,
    required this.title,
    required this.statusText,
    required this.statusColor,
    required this.description,
    required this.code,
    this.codeEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title + Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              Text(
                statusText,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 1,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.pink,
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          /// Description
          Text(
            description,
            style: const TextStyle(
              fontFamily: 'Digitalt',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          /// Coupon Code Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: codeEnabled ? Colors.black : Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "COUPON CODE: $code",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: codeEnabled ? Colors.white : Colors.black38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
