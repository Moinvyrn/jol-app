// MultiplayerGameScreen.dart - UPDATED VERSION (submit button only)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'controller/multiplayer_game_controller.dart';
import 'models/room_models.dart';
import 'multiplayer_results_screen.dart';

class MultiplayerGameScreen extends StatefulWidget {
  final String roomCode;
  final String playerId;

  const MultiplayerGameScreen({
    super.key,
    required this.roomCode,
    required this.playerId,
  });

  @override
  State<MultiplayerGameScreen> createState() => _MultiplayerGameScreenState();
}

class _MultiplayerGameScreenState extends State<MultiplayerGameScreen> {
  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFF82A87);

  final Map<String, TextEditingController> _inputControllers = {};
  bool _showLeaderboard = false;

  @override
  void dispose() {
    _inputControllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }

  String _getKey(int row, int col) => '$row-$col';

  bool _isGridFilled(MultiplayerGameController controller, Room room) {
    final gridSize = room.settings.gridSize;
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (i == 0 && j == 0) continue;
        if (!room.puzzle!.isFixed[i][j] && controller.grid[i][j] == null) {
          return false;
        }
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return ChangeNotifierProvider(
      create: (_) => MultiplayerGameController(
        roomCode: widget.roomCode,
        playerId: widget.playerId,
      ),
      child: Consumer<MultiplayerGameController>(
        builder: (context, controller, _) {
          // Navigate to results when game ends
          if (controller.room?.gameState.status == 'ended' && !controller.isPlaying) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiplayerResultsScreen(
                    roomCode: widget.roomCode,
                    playerId: widget.playerId,
                  ),
                ),
              );
            });
          }

          if (controller.room == null || controller.grid.isEmpty) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final room = controller.room!;
          final gridSize = room.settings.gridSize;
          final isTimed = room.settings.mode == 'timed';

          // Initialize controllers
          for (int i = 0; i < gridSize; i++) {
            for (int j = 0; j < gridSize; j++) {
              if ((i != 0 || j != 0) && !room.puzzle!.isFixed[i][j]) {
                String key = _getKey(i, j);
                _inputControllers.putIfAbsent(key, () => TextEditingController());
              }
            }
          }

          return Scaffold(
            body: Stack(
              children: [
                Container(
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
                        /// Header
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () => _showLeaveConfirmation(controller),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: textPink,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.arrow_back_ios_new,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                              const Spacer(),
                              const Text(
                                "Private Room",
                                style: TextStyle(
                                  fontFamily: "Rubik",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () => setState(() => _showLeaderboard = !_showLeaderboard),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(
                                    color: textGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.leaderboard,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        /// Score & Timer
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: textPink,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                isTimed
                                    ? Text(
                                  "Time: ${controller.timeLeft.inMinutes.toString().padLeft(2, '0')}:${(controller.timeLeft.inSeconds % 60).toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                )
                                    : const Text(
                                  "Mode: Untimed",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Score: ${controller.localScore}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  "Hints: ${controller.hintsRemaining}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// Submit Game Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: (controller.isPlaying && !controller.isSubmitted && _isGridFilled(controller, room))
                                  ? () async {
                                await controller.submitGame();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Submitted! Score based on correct cells.')),
                                );
                              }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: textGreen,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                controller.isSubmitted ? "Submitted" : "Submit Game",
                                style: const TextStyle(
                                  fontFamily: "Rubik",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Note about double tap for hints
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Double tap a cell to use a hint (if available)",
                            style: TextStyle(
                              fontFamily: "Rubik",
                              fontSize: 12,
                              color: Colors.grey.shade700,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Grid
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: gridSize * gridSize,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridSize,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 1.0,
                              ),
                              itemBuilder: (context, index) {
                                int row = index ~/ gridSize;
                                int col = index % gridSize;
                                bool isFixedCell = room.puzzle!.isFixed[row][col];
                                final value = controller.grid[row][col];

                                Color cellColor = (row == 0 && col == 0) ? textPink : Colors.white;
                                if (isFixedCell && (row != 0 || col != 0)) {
                                  cellColor = Colors.orange;
                                }

                                return GestureDetector(
                                  onDoubleTap: () {
                                    if (!isFixedCell && controller.hintsRemaining > 0) {
                                      _showHintDialog(controller, row, col);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cellColor,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: (row == 0 && col == 0)
                                            ? Colors.transparent
                                            : Colors.grey.shade600,
                                        width: 1.6,
                                      ),
                                    ),
                                    child: Center(
                                      child: (row == 0 && col == 0)
                                          ? Text(
                                        room.settings.operation == 'addition' ? "+" : "-",
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                          : isFixedCell
                                          ? Text(
                                        value?.toString() ?? "",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      )
                                          : TextField(
                                        controller: _inputControllers[_getKey(row, col)],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "",
                                          counterText: "",
                                          isCollapsed: true,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        onChanged: (val) {
                                          if (val.isEmpty) {
                                            controller.updateCell(row, col, null);
                                            return;
                                          }
                                          int? newVal = int.tryParse(val);
                                          if (newVal != null && newVal >= 0) {
                                            controller.updateCell(row, col, newVal);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),

                /// Leaderboard Overlay
                if (_showLeaderboard)
                  _buildLeaderboardOverlay(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeaderboardOverlay(MultiplayerGameController controller) {
    final leaderboard = controller.getLeaderboard();

    return GestureDetector(
      onTap: () => setState(() => _showLeaderboard = false),
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Live Leaderboard",
                  style: TextStyle(
                    fontFamily: "Rubik",
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: textPink,
                  ),
                ),
                const SizedBox(height: 20),
                ...leaderboard.asMap().entries.map((entry) {
                  final index = entry.key;
                  final player = entry.value;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: index == 0 ? Colors.amber.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "#${index + 1}",
                          style: TextStyle(
                            fontFamily: "Rubik",
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: index == 0 ? Colors.amber.shade900 : Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            player.name,
                            style: const TextStyle(
                              fontFamily: "Rubik",
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          "${player.score}",
                          style: const TextStyle(
                            fontFamily: "Rubik",
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: textBlue,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHintDialog(MultiplayerGameController controller, int row, int col) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Use Hint?'),
        content: Text('Use a hint for this cell? (${controller.hintsRemaining} remaining)\n\nThis will deduct 5 points.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await controller.useHint(row, col);
              if (success) {
                _inputControllers[_getKey(row, col)]?.text =
                    controller.grid[row][col]?.toString() ?? '';
              }
            },
            child: const Text('Use Hint'),
          ),
        ],
      ),
    );
  }

  void _showLeaveConfirmation(MultiplayerGameController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Game?'),
        content: const Text('Are you sure you want to leave? Your progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await controller.leaveRoom();
              if (mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}