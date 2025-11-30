import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../auth/models/user.dart';
import '../settings/services/user_profile_services.dart';

class AffiliatesScreen extends StatefulWidget {
  const AffiliatesScreen({super.key});

  @override
  State<AffiliatesScreen> createState() => _AffiliatesScreenState();
}

class _AffiliatesScreenState extends State<AffiliatesScreen> {
  static const Color textPink = Color(0xFFF82A87);

  final UserProfileService _profileService = UserProfileService();
  UserProfile? _profile;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result = await _profileService.getUserProfile();

    if (result.success && result.profile != null) {
      setState(() {
        _profile = result.profile;
        _isLoading = false;
      });
    } else {
      setState(() {
        _error = result.error ?? 'Failed to load profile';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Container(
          height: 300,
          decoration: BoxDecoration(
            color: Color(0xFFFF4CA1), // pink header
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              /// 🔖 Pink Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Text(
                  "AFFILIATES",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Digitalt',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: _isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: textPink,
                      ),
                    )
                        : _error != null
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _loadProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: textPink,
                            ),
                            child: const Text(
                              'RETRY',
                              style: TextStyle(
                                fontFamily: 'Digitalt',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                        : Column(
                      children: [
                        /// 💼 Affiliate Program Header
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          child: Text(
                            "EARN WITH REFERRALS",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Digitalt',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE6005C), // dark pink
                            ),
                          ),
                        ),

                        /// Divider
                        Divider(
                          color: Colors.grey.shade300,
                          thickness: 1,
                          indent: 20,
                          endIndent: 20,
                        ),

                        const SizedBox(height: 16),

                        /// 📢 Invite Info
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Share your referral link and earn 10% commission on every successful referral",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Rubik',
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: textPink,
                              height: 1.4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 🔘 Custom Invite Button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: InviteAffiliatesButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => InviteAffiliateDialog(
                                  referralLink:
                                  _profile?.referralLink ?? '',
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// 🎨 Custom Gradient Invite Button
class InviteAffiliatesButton extends StatelessWidget {
  final VoidCallback onPressed;

  const InviteAffiliatesButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B3CFF), Color(0xFFFF4CA1)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        ),
        onPressed: onPressed,
        child: const Text(
          "INVITE AFFILIATE",
          style: TextStyle(
            fontFamily: 'Digitalt',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// 📌 Invite Affiliate Dialog
class InviteAffiliateDialog extends StatefulWidget {
  final String referralLink;

  const InviteAffiliateDialog({super.key, required this.referralLink});

  @override
  State<InviteAffiliateDialog> createState() => _InviteAffiliateDialogState();
}

class _InviteAffiliateDialogState extends State<InviteAffiliateDialog> {
  bool _isCopied = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.referralLink));
    setState(() => _isCopied = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Referral link copied to clipboard!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF43AC45),
      ),
    );

    // Reset the copied state after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isCopied = false);
      }
    });
  }

  void _shareReferralLink() {
    if (widget.referralLink.isEmpty) return;

    Share.share(
      'Join Jol Puzzles using my referral link and get amazing rewards! ${widget.referralLink}',
      subject: 'Join Jol Puzzles!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 🧑 Avatar floating on top
            const Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                radius: 28,
                backgroundImage:
                AssetImage("lib/assets/images/settings_emoji.png"),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Invite Affiliate",
              style: TextStyle(
                fontFamily: "Rubik",
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFfc6839),
              ),
            ),

            const SizedBox(height: 12),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "REFER & GET 10% COMMISSION",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Digitalt",
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE6005C), // dark pink
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              "Invite your friend to get 10% commission. "
                  "You receive a 10% off coupon after their first purchase.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFF82A87),
                height: 1.4,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔗 Referral Link Display
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.referralLink.isEmpty
                          ? "No referral link available"
                          : widget.referralLink,
                      style: TextStyle(
                        fontFamily: "Rubik",
                        fontSize: 13,
                        color: widget.referralLink.isEmpty
                            ? Colors.grey.shade600
                            : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// 🔘 Action Buttons Row
            Row(
              children: [
                // Copy Button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.referralLink.isEmpty
                            ? [Colors.grey.shade400, Colors.grey.shade400]
                            : [const Color(0xFF8B3CFF), const Color(0xFFFF4CA1)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed:
                      widget.referralLink.isEmpty ? null : _copyToClipboard,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isCopied ? Icons.check : Icons.copy,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isCopied ? "COPIED!" : "COPY",
                            style: const TextStyle(
                              fontFamily: 'Digitalt',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Share Button
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: widget.referralLink.isEmpty
                            ? [Colors.grey.shade400, Colors.grey.shade400]
                            : [const Color(0xFF43AC45), const Color(0xFF2E7D32)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: widget.referralLink.isEmpty
                          ? null
                          : _shareReferralLink,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.share,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "SHARE",
                            style: TextStyle(
                              fontFamily: 'Digitalt',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}