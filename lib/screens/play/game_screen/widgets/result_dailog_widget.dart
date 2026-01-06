import 'package:flutter/material.dart';
import '../../../dashboard/models/game_models.dart';
import '../../controller/game_controller.dart';

class ResultDialogWidget extends StatelessWidget {
  final GameController controller;
  final Game? savedGame;
  final int? pointsEarned;
  final bool showSubmitButton;
  final VoidCallback onClose;
  final VoidCallback? onSubmit;

  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFF82A87);

  const ResultDialogWidget({
    Key? key,
    required this.controller,
    this.savedGame,
    this.pointsEarned,
    this.showSubmitButton = true,
    required this.onClose,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accuracyPercentage =
        savedGame?.accuracyPercentage ?? controller.accuracyPercentage;
    final finalScore = savedGame?.finalScore ?? controller.score;
    final completionTime = savedGame?.completionTime;

    final totalCells =
        (controller.gridSize * controller.gridSize) - 1 - controller.seedNumbers;
    int correctCount = 0;

    for (int i = 0; i < controller.gridSize; i++) {
      for (int j = 0; j < controller.gridSize; j++) {
        if (i == 0 && j == 0) continue;
        if (!controller.isFixed[i][j] &&
            controller.grid[i][j] != null &&
            controller.grid[i][j] == controller.solutionGrid[i][j]) {
          correctCount++;
        }
      }
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: textGreen.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: textGreen, width: 3),
              ),
              child: const Icon(
                Icons.emoji_events,
                color: textGreen,
                size: 40,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "GAME COMPLETE!",
              style: TextStyle(
                fontFamily: 'Digitalt',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textBlue,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            if (pointsEarned != null) ...[
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade400,
                      Colors.amber.shade600,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "POINTS EARNED",
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("🏆 ", style: TextStyle(fontSize: 32)),
                        Text(
                          "+$pointsEarned",
                          style: const TextStyle(
                            fontFamily: 'Digitalt',
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: textPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: textPink, width: 2),
              ),
              child: Column(
                children: [
                  const Text(
                    "YOUR ACCURACY",
                    style: TextStyle(
                      fontFamily: 'Digitalt',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textPink,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${accuracyPercentage.toStringAsFixed(2)}%",
                    style: const TextStyle(
                      fontFamily: 'Digitalt',
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: textPink,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            if (savedGame != null) ...[
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: textBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: textBlue, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Final Score: ",
                      style: TextStyle(
                        fontFamily: 'Digitalt',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textBlue,
                      ),
                    ),
                    Text(
                      "$finalScore",
                      style: const TextStyle(
                        fontFamily: 'Digitalt',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem("Correct", "$correctCount", textGreen),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey.shade300,
                ),
                _buildStatItem("Total", "$totalCells", textBlue),
              ],
            ),

            if (completionTime != null) ...[
              const SizedBox(height: 16),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: textGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: textGreen, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined,
                        color: textGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Time: ${_formatTime(completionTime)}",
                      style: const TextStyle(
                        fontFamily: 'Digitalt',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: textGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            if (showSubmitButton)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onClose,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: textBlue, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "CLOSE",
                        style: TextStyle(
                          fontFamily: 'Digitalt',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: textBlue,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: textGreen,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "SUBMIT",
                        style: TextStyle(
                          fontFamily: 'Digitalt',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: textBlue,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "CLOSE",
                    style: TextStyle(
                      fontFamily: 'Digitalt',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Digitalt',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color.withOpacity(0.7),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Digitalt',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}