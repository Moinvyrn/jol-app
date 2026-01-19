import 'dart:math';
import 'package:flutter/material.dart';

enum PuzzleOperation { addition, subtraction }

class GameController extends ChangeNotifier {
  final int gridSize;
  final PuzzleOperation operation;

  late List<List<int?>> grid;       // Player sees this (with empty cells)
  late List<List<int?>> solution;   // Full solved grid
  late List<List<bool>> isFixed;    // Seed cells
  late List<List<bool>> isWrong;    // Marks wrong entries

  GameController({this.gridSize = 5, this.operation = PuzzleOperation.addition}) {
    _initGrids();
  }

  void _initGrids() {
    grid = List.generate(gridSize, (_) => List.filled(gridSize, null));
    solution = List.generate(gridSize, (_) => List.filled(gridSize, null));
    isFixed = List.generate(gridSize, (_) => List.filled(gridSize, false));
    isWrong = List.generate(gridSize, (_) => List.filled(gridSize, false));

    // Operator cell
    grid[0][0] = (operation == PuzzleOperation.addition) ? 0 : 0;
    solution[0][0] = grid[0][0];
    isFixed[0][0] = true;

    _generateSolvedGrid();
    _removeCellsForPuzzle();
  }

  /// 1️⃣ Generate full solved grid
  void _generateSolvedGrid() {
    final random = Random();

    // Fill row headers
    for (int i = 0; i < gridSize; i++) {
      solution[i][0] = random.nextInt(20) + 1;
    }

    // Fill column headers
    for (int j = 1; j < gridSize; j++) {
      solution[0][j] = random.nextInt(20) + 1;
    }

    // Fill remaining cells
    for (int i = 1; i < gridSize; i++) {
      for (int j = 1; j < gridSize; j++) {
        solution[i][j] = (operation == PuzzleOperation.addition)
            ? solution[i][0]! + solution[0][j]!
            : (solution[i][0]! - solution[0][j]!).abs();
      }
    }

    // Copy to player grid (we will remove some later)
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        grid[i][j] = solution[i][j];
      }
    }
  }

  /// 2️⃣ Remove some cells, keep ceil(gridSize*1.5) as seeds
  void _removeCellsForPuzzle() {
    int seedCount = (gridSize * 1.5).ceil();
    List<Point<int>> allCells = [];

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (i == 0 && j == 0) continue; // skip operator cell
        allCells.add(Point(i, j));
      }
    }

    allCells.shuffle();
    
    // First `seedCount` stay as fixed
    for (int k = 0; k < seedCount; k++) {
      int r = allCells[k].x;
      int c = allCells[k].y;
      isFixed[r][c] = true;
    }

    // Remaining cells become empty
    for (int k = seedCount; k < allCells.length; k++) {
      int r = allCells[k].x;
      int c = allCells[k].y;
      grid[r][c] = null;
      isFixed[r][c] = false;
    }

    notifyListeners();
  }

  /// 3️⃣ Update player cell and validate dynamically
  void updateCell(int row, int col, int? value) {
    if (isFixed[row][col] || (row == 0 && col == 0)) return;

    grid[row][col] = value;

    // Validate immediately
    _validateCell(row, col);

    notifyListeners();
  }

  /// Compute expected value based on current headers
  int? _computeExpectedValue(int row, int col) {
    if (row == 0 && col == 0) return grid[0][0];

    int? rowHeader = grid[row][0];
    int? colHeader = grid[0][col];

    if (rowHeader == null || colHeader == null) return null;

    return (operation == PuzzleOperation.addition)
        ? rowHeader + colHeader
        : (rowHeader - colHeader).abs();
  }

  /// Validate a single cell
  void _validateCell(int row, int col) {
    if (isFixed[row][col] || (row == 0 && col == 0)) return;

    int? expected = _computeExpectedValue(row, col);
    if (expected == null) {
      isWrong[row][col] = false; // cannot check yet
    } else {
      isWrong[row][col] = grid[row][col] != expected;
    }
  }

  /// Validate all cells at once
  void validateAll() {
    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        _validateCell(i, j);
      }
    }
    notifyListeners();
  }

  /// Calculate score
  int getScore() {
    int total = 0;
    int correct = 0;

    for (int i = 0; i < gridSize; i++) {
      for (int j = 0; j < gridSize; j++) {
        if (!isFixed[i][j] && (i != 0 || j != 0)) {
          total++;
          if (!isWrong[i][j]) correct++;
        }
      }
    }

    if (total == 0) return 0;
    return ((correct / total) * 100).round();
  }

  /// Reset the game
  void reset() {
    _initGrids();
    notifyListeners();
  }
}
