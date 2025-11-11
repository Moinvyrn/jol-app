import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jol_app/screens/play/create_room_screen.dart';
import 'package:jol_app/screens/play/start_game_screen.dart';

import '../dashboard/notification_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../settings/account_screen.dart';
import 'join_room_screen.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFF82A87);

  String selectedLevel = "LEVEL 1";

  String getTitleSuffix(String level) {
    switch (level) {
      case "LEVEL 1":
        return "NOVICE";
      case "LEVEL 2":
        return "INTERMEDIATE";
      case "LEVEL 3":
        return "ADVANCED";
      case "LEVEL 4":
        return "EXPERT";
      default:
        return "NOVICE";
    }
  }

  String getComplexity(String level) {
    switch (level) {
      case "LEVEL 1":
        return "BRONZE";
      case "LEVEL 2":
        return "SILVER";
      case "LEVEL 3":
        return "GOLD";
      case "LEVEL 4":
        return "PLATINUM";
      default:
        return "BRONZE";
    }
  }

  String getEntry(String level) {
    final levelNumber = level.split(' ')[1];
    return "0$levelNumber";
  }

  @override
  Widget build(BuildContext context) {
    // Transparent status bar
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // Gradient background
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
            top: false,
            child: Column(
              children: [
                // 📌 App Bar
                _buildAppBar(context),

                // 📋 Game Board Container
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 25),
                  child: Container(
                    decoration: BoxDecoration(
                      color: textPink.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    height: MediaQuery.of(context).size.height *
                        0.55, // reduced height
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "GAMES BOARD",
                                style: TextStyle(
                                  fontFamily: 'Digitalt',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 1.5,
                                ),
                              ),
                              LevelSelector(
                                levels: [
                                  "LEVEL 1",
                                  "LEVEL 2",
                                  "LEVEL 3",
                                  "LEVEL 4"
                                ],
                                initialLevel: selectedLevel,
                                onLevelChanged: (level) {
                                  setState(() {
                                    selectedLevel = level;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Puzzle Cards
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return PuzzleCard(
                                imagePath: "lib/assets/images/logo.png",
                                title:
                                    "JOL PUZZLES ${getTitleSuffix(selectedLevel)}",
                                entry: getEntry(selectedLevel),
                                players: index.isEven
                                    ? "SINGLE PLAYER"
                                    : "MULTI PLAYER",
                                complexity: getComplexity(selectedLevel),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 🔘 Bottom Buttons
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: textBlue, // Blue
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const JoinRoomScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Enter Match Code",
                            style: TextStyle(
                              fontFamily: "Digitalt",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: textPink, // 0xFFF82A87
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateRoomScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Create Private Table",
                            style: TextStyle(
                              fontFamily: "Digitalt",
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔠 JOL logo builder
  Widget _buildJolLogo() {
    const letters = ["J", "O", "L"];
    const colors = [Color(0xFFf8bc64), textPink, Color(0xFFfc6839)];

    return Row(
      children: List.generate(
        letters.length,
        (index) => Text(
          letters[index],
          style: const TextStyle(
            fontFamily: 'Digitalt',
            fontWeight: FontWeight.w500,
            fontSize: 35,
            height: 0.82,
          ).copyWith(
            color: colors[index],
            letterSpacing: 1.5,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildJolLogo(),
          Row(
            children: [
              // ✅ HOW TO PLAY (pill button)
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const HelpDialog(),
                  );
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: textGreen,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.9), width: 2.5),
                  ),
                  child: const Text(
                    "HOW TO PLAY",
                    style: TextStyle(
                      fontFamily: 'Digitalt',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 🔔 Notification Bell
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NotificationScreen()), // Replace with NotificationScreen()
                  );
                },
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.notifications,
                    size: 20,
                    color: textPink,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // 💰 Coins
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  color: textPink,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    // Circle with "J"
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "J",
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textPink,
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "5M",
                        style: TextStyle(
                          fontFamily: 'Digitalt',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // 👤 Profile Avatar
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountScreen(),
                    ),
                  );
                },
                child: const CircleAvatar(
                  radius: 18,
                  backgroundImage:
                      AssetImage("lib/assets/images/settings_emoji.png"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LevelSelector extends StatefulWidget {
  final List<String> levels;
  final String initialLevel;
  final ValueChanged<String> onLevelChanged;

  const LevelSelector({
    super.key,
    required this.levels,
    required this.initialLevel,
    required this.onLevelChanged,
  });

  @override
  State<LevelSelector> createState() => _LevelSelectorState();
}

class _LevelSelectorState extends State<LevelSelector> {
  late String selectedLevel;

  @override
  void initState() {
    super.initState();
    selectedLevel = widget.initialLevel;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await showMenu<String>(
          context: context,
          position: const RelativeRect.fromLTRB(100, 100, 100, 100),
          items: widget.levels
              .map((level) => PopupMenuItem<String>(
                    value: level,
                    child: Text(
                      level,
                      style: const TextStyle(
                        fontFamily: 'Digitalt',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ))
              .toList(),
        );

        if (result != null && result != selectedLevel) {
          setState(() => selectedLevel = result);
          widget.onLevelChanged(result);
        }
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 2, vertical: 4), // smaller
        decoration: BoxDecoration(
          color: Colors.orange[600],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 1.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 12,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Text(
                selectedLevel,
                style: const TextStyle(
                  fontFamily: 'Digitalt',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PuzzleCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String entry;
  final String players;
  final String complexity;

  const PuzzleCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.entry,
    required this.players,
    required this.complexity,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle card tap
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const StartGameScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.asset(
                imagePath,
                width: 80,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Entry
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: "Digitalt",
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF82A87),
                          ),
                        ),
                        Text(
                          "ENTRY: $entry",
                          style: const TextStyle(
                            fontFamily: "Digitalt",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Players
                    Row(
                      children: [
                        const Text(
                          "PLAYERS:",
                          style: TextStyle(
                            fontFamily: "Digitalt",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF82A87),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange[600],
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                players,
                                style: const TextStyle(
                                  fontFamily: "Digitalt",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Complexity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "COMPLEXITY:",
                          style: TextStyle(
                            fontFamily: "Digitalt",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF82A87),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          complexity,
                          style: const TextStyle(
                            fontFamily: "Digitalt",
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
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
}