import 'package:flutter/material.dart';
import 'package:jol_app/screens/play/services/room_service.dart';
import 'package:jol_app/screens/play/waiting_lobby_screen.dart';
import 'package:uuid/uuid.dart';
import 'controller/multiplayer_game_controller.dart' as mp; // Added prefix for multiplayer controller
import 'models/room_models.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  static const Color textBlue = Color(0xFF0734A5);
  static const Color textGreen = Color(0xFF43AC45);
  static const Color textPink = Color(0xFFF82A87);

  final TextEditingController _nameController = TextEditingController();
  final RoomService _roomService = RoomService();

  int _selectedGridSize = 4;
  String _selectedMode = 'untimed';
  String _selectedOperation = 'addition';
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createRoom() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      // Generate player ID
      final playerId = const Uuid().v4();
      final playerName = _nameController.text.trim();

      debugPrint("Creating multiplayer room...");
      debugPrint("   Grid Size: $_selectedGridSize");
      debugPrint("   Mode: $_selectedMode");
      debugPrint("   Operation: $_selectedOperation");

      // Create room settings
      final settings = RoomSettings(
        gridSize: _selectedGridSize,
        mode: _selectedMode,
        operation: _selectedOperation,
        timeLimit: _selectedMode == 'timed' ? 300 : 0,
        maxHints: 2,
        maxPlayers: 4,
      );

      // Generate puzzle using the proper multiplayer generator
      final puzzleOperation = _selectedOperation == 'addition'
          ? mp.PuzzleOperation.addition // Use prefixed enum
          : mp.PuzzleOperation.subtraction; // Use prefixed enum

      final puzzleData = mp.MultiplayerPuzzleGenerator.generatePuzzle( // Prefix the generator class too for clarity
        gridSize: _selectedGridSize,
        operation: puzzleOperation,
      );

      // Validate puzzle before creating room
      if (!_validatePuzzle(puzzleData, _selectedGridSize)) {
        throw Exception('Generated puzzle is invalid');
      }

      debugPrint("Puzzle generated and validated");

      // Create room in Firebase
      final roomCode = await _roomService.createRoom(
        hostId: playerId,
        hostName: playerName,
        settings: settings,
        puzzle: puzzleData,
      );

      debugPrint("Room created with code: $roomCode");

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WaitingLobbyScreen(
              roomCode: roomCode,
              playerId: playerId,
              playerName: playerName,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      debugPrint("Error creating room: $e");
      debugPrint("Stack trace: $stackTrace");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating room: ${e.toString().split('\n').first}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }

  /// Validates puzzle structure before saving to Firebase
  bool _validatePuzzle(PuzzleData puzzle, int expectedSize) {
    debugPrint("Validating puzzle structure...");

    try {
      // Check grid dimensions
      if (puzzle.grid.length != expectedSize) {
        debugPrint("Grid has wrong size: ${puzzle.grid.length} (expected $expectedSize)");
        return false;
      }

      for (int i = 0; i < puzzle.grid.length; i++) {
        if (puzzle.grid[i].length != expectedSize) {
          debugPrint("Grid row $i has wrong size: ${puzzle.grid[i].length} (expected $expectedSize)");
          return false;
        }
      }

      // Check solution dimensions
      if (puzzle.solution.length != expectedSize) {
        debugPrint("Solution has wrong size: ${puzzle.solution.length} (expected $expectedSize)");
        return false;
      }

      for (int i = 0; i < puzzle.solution.length; i++) {
        if (puzzle.solution[i].length != expectedSize) {
          debugPrint("Solution row $i has wrong size: ${puzzle.solution[i].length} (expected $expectedSize)");
          return false;
        }
      }

      // Check isFixed dimensions
      if (puzzle.isFixed.length != expectedSize) {
        debugPrint("isFixed has wrong size: ${puzzle.isFixed.length} (expected $expectedSize)");
        return false;
      }

      for (int i = 0; i < puzzle.isFixed.length; i++) {
        if (puzzle.isFixed[i].length != expectedSize) {
          debugPrint("isFixed row $i has wrong size: ${puzzle.isFixed[i].length} (expected $expectedSize)");
          return false;
        }
      }

      // Check reference cell [0][0]
      if (puzzle.grid[0][0] != -1 || puzzle.solution[0][0] != -1) {
        debugPrint("Reference cell [0][0] is not -1 (grid: ${puzzle.grid[0][0]}, solution: ${puzzle.solution[0][0]})");
        return false;
      }

      if (!puzzle.isFixed[0][0]) {
        debugPrint("Reference cell [0][0] is not marked as fixed");
        return false;
      }

      // Check that solution is complete (no nulls except reference cell behavior)
      int nullCount = 0;
      for (int i = 0; i < expectedSize; i++) {
        for (int j = 0; j < expectedSize; j++) {
          if (i == 0 && j == 0) continue; // Skip reference cell
          if (puzzle.solution[i][j] == null) {
            nullCount++;
            debugPrint("Solution has null at [$i][$j]");
          }
        }
      }

      if (nullCount > 0) {
        debugPrint("Solution has $nullCount null cells");
        return false;
      }

      // Count fixed cells (seed numbers)
      int fixedCount = 0;
      for (int i = 0; i < expectedSize; i++) {
        for (int j = 0; j < expectedSize; j++) {
          if (puzzle.isFixed[i][j]) fixedCount++;
        }
      }

      // Verify player grid only shows fixed cells
      int visibleCount = 0;
      for (int i = 0; i < expectedSize; i++) {
        for (int j = 0; j < expectedSize; j++) {
          if (puzzle.grid[i][j] != null) {
            visibleCount++;
            // Make sure visible cells are marked as fixed
            if (!puzzle.isFixed[i][j]) {
              debugPrint("Cell [$i][$j] is visible but not marked as fixed");
            }
          }
        }
      }

      debugPrint("Puzzle validation passed:");
      debugPrint("   Grid size: ${expectedSize}x$expectedSize");
      debugPrint("   Fixed cells: $fixedCount");
      debugPrint("   Visible cells: $visibleCount");
      debugPrint("   Player cells: ${expectedSize * expectedSize - fixedCount}");

      return true;
    } catch (e) {
      debugPrint("Validation error: $e");
      return false;
    }
  }

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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                          "Create Private Room",
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

                  const SizedBox(height: 30),

                  // Player Name Input
                  const Text(
                    "Your Name",
                    style: TextStyle(
                      fontFamily: "Rubik",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Grid Size Selection
                  const Text(
                    "Grid Size",
                    style: TextStyle(
                      fontFamily: "Rubik",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildOptionButton('4x4', 4, _selectedGridSize),
                      const SizedBox(width: 10),
                      _buildOptionButton('5x5', 5, _selectedGridSize),
                      const SizedBox(width: 10),
                      _buildOptionButton('6x6', 6, _selectedGridSize),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Game Mode Selection
                  const Text(
                    "Game Mode",
                    style: TextStyle(
                      fontFamily: "Rubik",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildModeButton('Untimed', 'untimed'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildModeButton('Timed (5 min)', 'timed'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Operation Selection
                  const Text(
                    "Operation Type",
                    style: TextStyle(
                      fontFamily: "Rubik",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOperationButton('Addition (+)', 'addition'),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildOperationButton('Subtraction (-)', 'subtraction'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Create Room Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: textPink,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isCreating ? null : _createRoom,
                      child: _isCreating
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        "Create Room",
                        style: TextStyle(
                          fontFamily: "Rubik",
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String label, int value, int selectedValue) {
    final isSelected = value == selectedValue;
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? textBlue : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? textBlue : Colors.grey.shade300,
              width: 2,
            ),
          ),
        ),
        onPressed: () => setState(() => _selectedGridSize = value),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: "Rubik",
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String label, String value) {
    final isSelected = value == _selectedMode;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? textGreen : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? textGreen : Colors.grey.shade300,
            width: 2,
          ),
        ),
      ),
      onPressed: () => setState(() => _selectedMode = value),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: "Rubik",
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildOperationButton(String label, String value) {
    final isSelected = value == _selectedOperation;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: isSelected ? Colors.orange : Colors.grey.shade300,
            width: 2,
          ),
        ),
      ),
      onPressed: () => setState(() => _selectedOperation = value),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: "Rubik",
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}