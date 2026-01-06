import 'package:flutter/material.dart';
import 'package:jol_app/screens/auth/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  // Colors from splash screen
  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFC42AF8);

  // Font size for logo
  static const double logoFontSize = 90;

  TextSpan _coloredLetter(String letter, int index) {
    final colors = [textBlue, textGreen, textPink];
    return TextSpan(
      text: letter,
      style: const TextStyle(
        fontFamily: 'Digitalt',
        fontWeight: FontWeight.w500,
        height: 0.82, // 🔑 forces even tighter vertical spacing
      ).copyWith(
        color: colors[index % 3],
        fontSize: logoFontSize,
        letterSpacing: logoFontSize * 0.04,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topPadding =
        MediaQuery.of(context).padding.top + 40; // dynamic + extra space

    final combinedText = <TextSpan>[
      _coloredLetter('J', 0),
      _coloredLetter('O', 1),
      _coloredLetter('L', 2),
      const TextSpan(text: '\n'),
      _coloredLetter('P', 3),
      _coloredLetter('U', 4),
      _coloredLetter('Z', 5),
      _coloredLetter('Z', 6),
      _coloredLetter('L', 7),
      _coloredLetter('E', 8),
      _coloredLetter('S', 9),
    ];

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top left-aligned logo text with better top spacing
            Padding(
              padding: EdgeInsets.only(top: topPadding, left: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  text: TextSpan(children: combinedText),
                  textAlign: TextAlign.start,
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                ),
              ),
            ),
            // Bottom buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const HelpDialog(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textBlue,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.question_mark,
                        color: Colors.white, size: 26),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen())),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: textPink,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 15),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => showSettingsDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textGreen,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    child: const Icon(Icons.settings,
                        color: Colors.white, size: 26),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  double volume = 0.5;
  double music = 0.5;
  bool hapticEnabled = true;

  // Colors from your palette
  static const Color textPink = Color(0xFFC42AF8);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textBlue = Color(0xFF0734A5);
  static const Color settingsOrange = Color(0xFFF47A62);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: settingsOrange,
                  ),
                ),
                const SizedBox(height: 20),

                // Volume Slider
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // center horizontally
                  children: [
                    const Icon(Icons.volume_up, color: textPink),
                    const SizedBox(width: 12), // spacing between icon & slider
                    SizedBox(
                      width: 200,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 16,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12,
                          ),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: volume,
                          onChanged: (value) => setState(() => volume = value),
                          activeColor: textPink,
                          inactiveColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

// Music Slider
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // center horizontally
                  children: [
                    const Icon(Icons.music_note_outlined, color: textGreen),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 16,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 12,
                          ),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: music,
                          onChanged: (value) => setState(() => music = value),
                          activeColor: textGreen,
                          inactiveColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Haptic Feedback toggle with ON/OFF text
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'HAPTIC FEEDBACK',
                      style: const TextStyle(
                        fontFamily: 'Digitalt',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: textBlue,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          hapticEnabled ? 'ON' : 'OFF',
                          style: const TextStyle(
                            fontFamily: 'Digitalt',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: textBlue,
                          ),
                        ),
                        Switch(
                          value: hapticEnabled,
                          onChanged: (value) =>
                              setState(() => hapticEnabled = value),
                          activeColor: Colors.white,
                          activeTrackColor: textBlue,
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Close button
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: textPink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'CLOSE',
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top image
          Positioned(
            top: -40,
            child: Image.asset(
              'lib/assets/images/settings_emoji.png',
              height: 80,
            ),
          ),
        ],
      ),
    );
  }
}

void showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const SettingsDialog(),
  );
}

class HelpDialog extends StatefulWidget {
  const HelpDialog({super.key});

  @override
  State<HelpDialog> createState() => _HelpDialogState();
}

class _HelpDialogState extends State<HelpDialog> {
  // Colors from your palette
  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFC42AF8);

  int currentPage = 0;

  void nextPage() {
    if (currentPage < 4) {
      setState(() => currentPage++);
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      setState(() => currentPage--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top small handle
            Container(
              width: 80,
              height: 6,
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(6),
              ),
            ),

            // Title
            Text(
              _pageTitle(currentPage),
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 18,
                letterSpacing: 0.04,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),

            // Page content
            _pageContent(currentPage),

            const SizedBox(height: 22),

            // Buttons row
            if (currentPage == 0)
              // First page → full width Next
              ElevatedButton(
                onPressed: nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: textPink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 60),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              )
            else
              Row(
                children: [
                  // Previous (blue)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: previousPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: textBlue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Previous',
                        style: TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Next / Done (pink)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (currentPage == 4) {
                          Navigator.of(context).pop(); // Done
                        } else {
                          nextPage();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: textPink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        currentPage == 4 ? 'Done' : 'Next',
                        style: const TextStyle(
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 14),

            // Page indicator dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final bool active = index == currentPage;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: active ? textPink : Colors.grey.shade300,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ---- Page content builder ----
  Widget _pageContent(int page) {
    switch (page) {
      case 0: // A, B and C
        return Column(
          children: [
            _gridContainer([
              [
                _cell('+', textPink),
                _cell('B', textGreen),
                _cell('', textBlue)
              ],
              [
                _cell('+', textGreen),
                _cell('C', Colors.white, border: true),
                _cell('', Colors.white, border: true)
              ],
              [
                _cell('+', textGreen),
                _cell('A', Colors.white, border: true),
                _cell('', Colors.white, border: true)
              ],
            ]),
            const SizedBox(height: 18),
            const Text(
              "In the grid, locate point C by drawing a vertical line down from number B and a horizontal line to the right from number A. The intersection of these lines creates point C, forming an inverted 'L' shape connecting A, B, and C.",
              textAlign: TextAlign.center,
              style: _instructionStyle,
            ),
          ],
        );

      case 1: // A, B = C
        return Column(
          children: [
            _gridContainer([
              [
                _cell('+', textPink),
                _cell('', textGreen),
                _cell('4', textBlue)
              ],
              [
                _cell('6', textGreen),
                _cell('', Colors.white, border: true),
                _cell('10', Colors.white, border: true)
              ],
              [
                _cell('', textGreen),
                _cell('', Colors.white, border: true),
                _cell('', Colors.white, border: true)
              ],
            ]),
            const SizedBox(height: 18),
            const Text(
              "If you have A = 6 and B = 4, simply add A and B to find the value of C. In this case, C = 6 + 4, which equals 10.",
              textAlign: TextAlign.center,
              style: _instructionStyle,
            ),
          ],
        );

      case 2: // A, B = B
        return Column(
          children: [
            _gridContainer([
              [
                _cell('+', textPink),
                _cell('?', textGreen),
                _cell('', textBlue)
              ],
              [
                _cell('6', textGreen),
                _cell('', Colors.white, border: true),
                _cell('', Colors.white, border: true)
              ],
              [
                _cell('5', textGreen),
                _cell('7', Colors.white, border: true),
                _cell('', Colors.white, border: true)
              ],
            ]),
            const SizedBox(height: 18),
            const Text(
              "If you have A = 5 and C = 7, simply add A and C to find the value of B. In the case, B = 5 + 7, which equals 12.",
              textAlign: TextAlign.center,
              style: _instructionStyle,
            ),
          ],
        );

      case 3: // Jol Puzzle
        return Column(
          children: [
            _gridContainerWithLabels(),
            const SizedBox(height: 18),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                    "1.  To find A2, add B2 and C: A2 = B2 + C. For example, if B2 = 3 and C = 4, then A2 = 3+4 = 7.",
                    style: _instructionStyle),
                SizedBox(height: 8),
                Text(
                    "2.  With A2 and C, find B1 by adding them: B1 = A2 + C. For example, if A2 = 7 and C = 8, then B1 = 7 + 8 = 15.",
                    style: _instructionStyle),
                SizedBox(height: 8),
                Text("3.  This pattern continues as you progress in the game_screen.",
                    style: _instructionStyle),
              ],
            ),
          ],
        );

      case 4: // Point System
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: const [
                  _scoreRow("Remaining Time:", "120 Sec"),
                  _scoreRow("Points:", "150"),
                  _scoreRow("Total Score:", "150"),
                ],
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: textBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              ),
              child: const Text(
                "Check & submit score",
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "After completing the board, click 'Check & Submit Score' to review. Correct answers yield 100 points each, with an extra point awarded for every remaining second.",
              textAlign: TextAlign.center,
              style: _instructionStyle,
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  String _pageTitle(int page) {
    switch (page) {
      case 0:
        return "A, B and C";
      case 1:
        return "A, B = C";
      case 2:
        return "A, B = B";
      case 3:
        return "Jol Puzzle";
      case 4:
        return "Point System";
      default:
        return "";
    }
  }

  // ---- Grid builders ----
  Widget _gridContainer(List<List<Widget>> rows) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.2),
      ),
      child: SizedBox(
        width: 220,
        height: 220,
        child: GridView.builder(
          itemCount: 9,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final row = index ~/ 3;
            final col = index % 3;
            return rows[row][col];
          },
        ),
      ),
    );
  }

  Widget _gridContainerWithLabels() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1.2),
      ),
      child: SizedBox(
        width: 220,
        height: 220,
        child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _gridBoxWithLabel('+', textPink, ""),
            _gridBoxWithLabel('15', Colors.white, "7+8="),
            _gridBoxWithLabel('3', textGreen, ""),
            _gridBoxWithLabel('17', Colors.white, "15÷2="),
            _gridBoxWithLabel('2', textGreen, ""),
            _gridBoxWithLabel('', Colors.white, ""),
            _gridBoxWithLabel('7', Colors.white, "3+4="),
            _gridBoxWithLabel('8', textBlue, ""),
            _gridBoxWithLabel('4', textPink, ""),
          ],
        ),
      ),
    );
  }

  static Widget _cell(String text, Color color, {bool border = false}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
        border:
            border ? Border.all(color: Colors.black.withOpacity(0.2)) : null,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.w700,
          fontSize: 22,
          letterSpacing: 0.04,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _gridBoxWithLabel(String text, Color color, String label) {
    return Stack(
      children: [
        _cell(text, color, border: color == Colors.white),
        if (label.isNotEmpty)
          Positioned(
            left: 2,
            top: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                color: Colors.purple,
              ),
            ),
          ),
      ],
    );
  }
}

// ---- Helpers ----
class _scoreRow extends StatelessWidget {
  final String label;
  final String value;
  const _scoreRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.black,
              )),
          Text(value,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.red,
              )),
        ],
      ),
    );
  }
}

const TextStyle _instructionStyle = TextStyle(
  fontFamily: 'Nunito',
  fontWeight: FontWeight.w700,
  fontSize: 14,
  height: 1.2,
  color: Colors.black,
);
