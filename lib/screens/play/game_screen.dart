import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jol_app/screens/play/submit_game_screen.dart';
import 'package:provider/provider.dart';
import 'controller/game_controller.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFF82A87);

  final Map<String, TextEditingController> _inputControllers = {};
  final Map<String, FocusNode> _focusNodes = {};
  bool _showMinus = false;
  String? _selectedCell;

  @override
  void dispose() {
    _inputControllers.values.forEach((controller) => controller.dispose());
    _focusNodes.values.forEach((node) => node.dispose());
    super.dispose();
  }

  String _getKey(int row, int col) => '$row-$col';

  void _onKeyboardTap(String value, GameController controller) {
    if (_selectedCell == null) return;

    final parts = _selectedCell!.split('-');
    final row = int.parse(parts[0]);
    final col = int.parse(parts[1]);

    if (value == 'clear') {
      final currentText = _inputControllers[_selectedCell]?.text ?? '';
      if (currentText.isNotEmpty) {
        // Remove last character
        final newText = currentText.substring(0, currentText.length - 1);
        _inputControllers[_selectedCell]?.text = newText;

        if (newText.isEmpty) {
          controller.updateCell(row, col, null);
        } else {
          final newVal = int.tryParse(newText);
          if (newVal != null && newVal >= 0) {
            controller.updateCell(row, col, newVal);
          }
        }
      }
    } else {
      final currentText = _inputControllers[_selectedCell]?.text ?? '';
      final newText = currentText + value;

      if (newText.length <= 3) {
        _inputControllers[_selectedCell]?.text = newText;
        final newVal = int.tryParse(newText);
        if (newVal != null && newVal >= 0) {
          controller.updateCell(row, col, newVal);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return ChangeNotifierProvider(
      create: (_) => GameController(gridSize: 4),
      child: Consumer<GameController>(
        builder: (context, controller, _) {
          int gridSize = controller.gridSize;
          final bool isTimed = controller.mode == GameMode.timed;

          // Initialize controllers and focus nodes
          for (int i = 0; i < gridSize; i++) {
            for (int j = 0; j < gridSize; j++) {
              if ((i != 0 || j != 0) && !controller.isFixed[i][j]) {
                String key = _getKey(i, j);
                _inputControllers.putIfAbsent(key, () => TextEditingController());
                _focusNodes.putIfAbsent(key, () {
                  final node = FocusNode();
                  node.addListener(() {
                    if (node.hasFocus) {
                      setState(() => _selectedCell = key);
                    }
                  });
                  return node;
                });
              }
            }
          }

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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate responsive sizing based on available height
                    final screenHeight = constraints.maxHeight;
                    final screenWidth = constraints.maxWidth;

                    // Responsive font and size calculations
                    final headerSize = screenHeight * 0.04;
                    final iconSize = screenHeight * 0.035;
                    final scoreFontSize = screenHeight * 0.016;
                    final buttonFontSize = screenHeight * 0.015;
                    final buttonPadding = screenHeight * 0.01;

                    // Grid calculations - reduced height to remove empty space
                    final gridPadding = screenWidth * 0.1;
                    final gridAreaHeight = screenHeight * 0.35;
                    final spacing = screenHeight * 0.01;

                    // Keyboard calculations - increased height for better spacing
                    final keyboardHeight = screenHeight * 0.30;
                    final keyHeight = keyboardHeight * 0.20;
                    final keyFontSize = screenHeight * 0.022;

                    return SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: screenHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              /// 1. Header Bar
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.008,
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        width: iconSize,
                                        height: iconSize,
                                        decoration: const BoxDecoration(
                                          color: textPink,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.arrow_back_ios_new,
                                            color: Colors.white, size: iconSize * 0.6),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Jol Puzzle",
                                      style: TextStyle(
                                        fontFamily: "Rubik",
                                        fontSize: headerSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Builder(
                                      builder: (innerContext) {
                                        return InkWell(
                                          onTap: () {
                                            showSettingsDialog(innerContext);
                                          },
                                          child: Container(
                                            width: iconSize,
                                            height: iconSize,
                                            decoration: const BoxDecoration(
                                              color: textGreen,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.settings,
                                                color: Colors.white, size: iconSize * 0.6),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.008),

                              /// 2. Score & Timer/Mode
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.04,
                                          vertical: screenHeight * 0.01,
                                        ),
                                        decoration: BoxDecoration(
                                          color: textPink,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            isTimed
                                                ? Text(
                                              "Time Left: ${controller.timeLeft.inMinutes.toString().padLeft(2, '0')}:${(controller.timeLeft.inSeconds % 60).toString().padLeft(2, '0')}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: scoreFontSize,
                                              ),
                                            )
                                                : Text(
                                              "Mode: Untimed",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: scoreFontSize,
                                              ),
                                            ),
                                            Text(
                                              "Score: ${controller.score}",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: scoreFontSize,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    InkWell(
                                      onTap: () {
                                        controller.toggleMode();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(screenHeight * 0.012),
                                        decoration: BoxDecoration(
                                          color: textGreen,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          isTimed ? Icons.timer : Icons.timer_off,
                                          color: Colors.white,
                                          size: iconSize * 0.8,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.01),

                              /// 3. Solve Puzzle & Check Buttons
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                        controller.isPlaying ? controller.solvePuzzle : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: textGreen,
                                          padding: EdgeInsets.symmetric(vertical: buttonPadding),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Solve Puzzle",
                                          style: TextStyle(
                                            fontFamily: "Rubik",
                                            fontSize: buttonFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: controller.isPlaying
                                            ? () {
                                          controller.checkGrid();
                                        }
                                            : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          padding: EdgeInsets.symmetric(vertical: buttonPadding),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Check",
                                          style: TextStyle(
                                            fontFamily: "Rubik",
                                            fontSize: buttonFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.015),

                              /// 4. Grid with Container Background
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: gridPadding),
                                child: Container(
                                  padding: EdgeInsets.all(screenHeight * 0.015),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    height: gridAreaHeight,
                                    child: LayoutBuilder(
                                      builder: (context, gridConstraints) {
                                        final gridWidth = gridConstraints.maxWidth;
                                        final cellSize = (gridWidth - (spacing * (gridSize - 1))) / gridSize;
                                        // Unified font size for both grid and keyboard
                                        final unifiedFontSize = screenHeight * 0.024;

                                        return GridView.builder(
                                          physics: const NeverScrollableScrollPhysics(),
                                          itemCount: gridSize * gridSize,
                                          gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: gridSize,
                                            mainAxisSpacing: spacing,
                                            crossAxisSpacing: spacing,
                                            childAspectRatio: 1,
                                          ),
                                          itemBuilder: (context, index) {
                                            int row = index ~/ gridSize;
                                            int col = index % gridSize;
                                            bool isFixedCell = controller.isFixed[row][col];
                                            final value = controller.grid[row][col];

                                            Color cellColor = Colors.white;

                                            // Top-left corner is now yellow too
                                            if (row == 0 && col == 0) {
                                              cellColor = const Color(0xFFFFD54F);
                                            } else if (isFixedCell) {
                                              cellColor = const Color(0xFFFFD54F); // Yellow for fixed cells
                                            }

                                            if (controller.isWrong[row][col] == true) {
                                              cellColor = Colors.red.shade300;
                                            }

                                            return Container(
                                              decoration: BoxDecoration(
                                                color: cellColor,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Center(
                                                child: (row == 0 && col == 0)
                                                    ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      _showMinus = !_showMinus;
                                                    });
                                                    controller.setOperation(
                                                        _showMinus
                                                            ? PuzzleOperation.subtraction
                                                            : PuzzleOperation.addition
                                                    );
                                                    _inputControllers.clear();
                                                    _focusNodes.clear();
                                                    setState(() => _selectedCell = null);
                                                  },
                                                  child: Text(
                                                    _showMinus ? "-" : "+",
                                                    style: TextStyle(
                                                      fontSize: unifiedFontSize * 1.3,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                )
                                                    : isFixedCell
                                                    ? Text(
                                                  value?.toString() ?? "",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: unifiedFontSize,
                                                    color: Colors.black,
                                                  ),
                                                )
                                                    : TextField(
                                                  controller:
                                                  _inputControllers[_getKey(row, col)],
                                                  focusNode: _focusNodes[_getKey(row, col)],
                                                  textAlign: TextAlign.center,
                                                  readOnly: true,
                                                  showCursor: true,
                                                  decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText: "",
                                                    counterText: "",
                                                    isCollapsed: true,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: unifiedFontSize,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.015),

                              /// 5. Custom Numeric Keyboard
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: gridPadding),
                                child: Container(
                                  height: keyboardHeight,
                                  padding: EdgeInsets.all(screenHeight * 0.015),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        offset: const Offset(0, -2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          _buildKeyButton('1', controller, keyHeight, screenHeight * 0.024),
                                          SizedBox(width: screenWidth * 0.02),
                                          _buildKeyButton('2', controller, keyHeight, screenHeight * 0.024),
                                          SizedBox(width: screenWidth * 0.02),
                                          _buildKeyButton('3', controller, keyHeight, screenHeight * 0.024),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Row(
                                        children: [
                                          _buildKeyButton('4', controller, keyHeight, screenHeight * 0.024),
                                          SizedBox(width: screenWidth * 0.02),
                                          _buildKeyButton('5', controller, keyHeight, screenHeight * 0.024),
                                          SizedBox(width: screenWidth * 0.02),
                                          _buildKeyButton('6', controller, keyHeight, screenHeight * 0.024),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Row(
                                        children: [
                                          _buildKeyButton('7', controller, keyHeight, screenHeight * 0.024),
                                          SizedBox(width: screenWidth * 0.02),
                                          _buildKeyButton('8', controller, keyHeight, screenHeight * 0.024),
                                          SizedBox(width: screenWidth * 0.02),
                                          _buildKeyButton('9', controller, keyHeight, screenHeight * 0.024),
                                        ],
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                      Row(
                                        children: [
                                          Expanded(child: Container()),
                                          SizedBox(width: screenWidth * 0.02),
                                          _buildKeyButton('0', controller, keyHeight, screenHeight * 0.024),
                                          SizedBox(width: screenWidth * 0.02),
                                          _buildClearButton(controller, keyHeight, screenHeight * 0.022),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: screenHeight * 0.015),

                              /// 6. Bottom Actions
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                  vertical: screenHeight * 0.008,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          controller.resetGame();
                                          _inputControllers.clear();
                                          _focusNodes.clear();
                                          setState(() => _selectedCell = null);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          padding: EdgeInsets.symmetric(vertical: buttonPadding),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Reset",
                                          style: TextStyle(
                                            fontFamily: "Rubik",
                                            fontSize: buttonFontSize,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          controller.validateGrid();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => SubmitGameScreen(),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: textBlue,
                                          padding: EdgeInsets.symmetric(vertical: buttonPadding),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          "Check & Submit Score",
                                          style: TextStyle(
                                            fontFamily: "Rubik",
                                            fontSize: buttonFontSize,
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
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKeyButton(String number, GameController controller, double height, double fontSize) {
    return Expanded(
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        elevation: 2,
        child: InkWell(
          onTap: () => _onKeyboardTap(number, controller),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(vertical: height * 0.15),
            alignment: Alignment.center,
            child: Text(
              number,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClearButton(GameController controller, double height, double iconSize) {
    return Expanded(
      child: Material(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(8),
        elevation: 2,
        child: InkWell(
          onTap: () => _onKeyboardTap('clear', controller),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: height,
            padding: EdgeInsets.symmetric(vertical: height * 0.15),
            alignment: Alignment.center,
            child: Icon(
              Icons.backspace_outlined,
              size: iconSize,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  void showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Settings'),
          content: const Text('Game settings will go here'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

/// =================== FinishGameDialog ===================
class FinishGameDialog extends StatelessWidget {
  const FinishGameDialog({super.key});

  static const Color textBlue = Color(0xFF0734A5);
  static const Color textPink = Color(0xFFC42AF8);

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
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
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
                const Text(
                  'Finish Game',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    fontFamily: 'Digitalt',
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                const Text(
                  'Do you wish to end your game and check score?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons Row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: textBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.of(context).pop(false), // Resume
                        child: const Text(
                          'Resume',
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: textPink,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SubmitGameScreen())),
                        child: const Text(
                          'Check Score',
                          style: TextStyle(
                            fontFamily: 'Digitalt',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Top image
          Positioned(
            top: -40,
            child: Image.asset(
              'lib/assets/images/settings_emoji.png', // your asset
              height: 80,
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsDialog extends StatefulWidget {
  final GameController controller;

  const SettingsDialog({super.key, required this.controller});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  double volume = 0.5;
  double music = 0.5;
  bool hapticEnabled = true;

  // 🎨 Color palette (keep original)
  static const Color textPink = Color(0xFFC42AF8);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textBlue = Color(0xFF0734A5);
  static const Color settingsOrange = Color(0xFFF47A62);

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final isTimed = controller.mode == GameMode.timed;
    final gridSize = controller.gridSize;

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
                // 🧩 Title
                Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: settingsOrange,
                  ),
                ),
                const SizedBox(height: 20),

                // 🔊 Volume Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.volume_up, color: textPink),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 16,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: volume,
                          onChanged: (value) =>
                              setState(() => volume = value),
                          activeColor: textPink,
                          inactiveColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 🎵 Music Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.music_note_outlined, color: textGreen),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 200,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 16,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(
                          value: music,
                          onChanged: (value) =>
                              setState(() => music = value),
                          activeColor: textGreen,
                          inactiveColor: Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // 📳 Haptic Feedback Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'HAPTIC FEEDBACK',
                      style: TextStyle(
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

                // 🔹 Timed Mode Toggle
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'TIMED MODE',
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: textBlue,
                      ),
                    ),
                    Switch(
                      value: isTimed,
                      onChanged: (value) {
                        setState(() {
                          controller.toggleMode();
                        });
                      },
                      activeColor: Colors.white,
                      activeTrackColor: textGreen,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔹 Grid Size Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'GRID SIZE',
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: textBlue,
                      ),
                    ),
                    DropdownButton<int>(
                      value: gridSize,
                      dropdownColor: Colors.white,
                      style: const TextStyle(
                        color: textBlue,
                        fontFamily: 'Digitalt',
                        fontSize: 16,
                      ),
                      items: const [
                        DropdownMenuItem(value: 3, child: Text('3 x 3')),
                        DropdownMenuItem(value: 4, child: Text('4 x 4')),
                        DropdownMenuItem(value: 5, child: Text('5 x 5')),
                      ],
                      onChanged: (value) {
                        // if (value != null) {
                        //   setState(() {
                        //     controller.setGridSize(value);
                        //   });
                        // }
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 🎯 Close Button
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

          // 🧡 Top Emoji Image
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
  final controller = Provider.of<GameController>(context, listen: false);

  showDialog(
    context: context,
    builder: (context) => SettingsDialog(controller: controller),
  );
}
