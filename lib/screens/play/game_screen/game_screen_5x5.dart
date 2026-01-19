import 'package:flutter/material.dart';
import 'package:jol_app/screens/play/controller/game_controller_new.dart';
// import '../../controller/game_controller_new.dart'; // Your new controller

class GameScreen5 extends StatefulWidget {
  final int gridSize;
  final PuzzleOperation operation;

  const GameScreen5({
    super.key,
    this.gridSize = 5,
    this.operation = PuzzleOperation.addition,
  });

  @override
  State<GameScreen5> createState() => _GameScreen5State();
}

class _GameScreen5State extends State<GameScreen5> {
  late GameController controller;
  late Map<String, TextEditingController> inputControllers;
  late Map<String, FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controller = GameController(
      gridSize: widget.gridSize,
      operation: widget.operation,
    );
    _initInputs();
  }

  void _initInputs() {
    inputControllers = {};
    focusNodes = {};

    for (int r = 0; r < controller.gridSize; r++) {
      for (int c = 0; c < controller.gridSize; c++) {
        final key = '$r-$c';
        inputControllers[key] = TextEditingController(
          text: controller.grid[r][c]?.toString() ?? '',
        );
        focusNodes[key] = FocusNode();
      }
    }
  }

  @override
  void dispose() {
    for (final c in inputControllers.values) c.dispose();
    for (final f in focusNodes.values) f.dispose();
    super.dispose();
  }

  String _getKey(int r, int c) => '$r-$c';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final spacing = 8.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Puzzle ${widget.gridSize}×${widget.gridSize}'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                controller.reset();
                _initInputs();
              });
            },
          )
        ],
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final cellSize = (size.width * 0.9 - (controller.gridSize - 1) * spacing) /
                controller.gridSize;

            return SizedBox(
              width: size.width * 0.9,
              height: size.width * 0.9,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: controller.gridSize,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  childAspectRatio: 1,
                ),
                itemCount: controller.gridSize * controller.gridSize,
                itemBuilder: (context, index) {
                  final row = index ~/ controller.gridSize;
                  final col = index % controller.gridSize;
                  final key = _getKey(row, col.toInt());

                  final isFixed = controller.isFixed[row][col];
                  final isWrong = controller.isWrong[row][col];
                  final value = controller.grid[row][col];

                  Color bgColor = Colors.white;
                  if (row == 0 && col == 0) {
                    bgColor = Colors.amber.shade300; // operator
                  } else if (isFixed) {
                    bgColor = Colors.amber.shade200; // seeds
                  } else if (isWrong) {
                    bgColor = Colors.red.shade300;
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: isFixed || (row == 0 && col == 0)
                        ? Text(
                            value?.toString() ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          )
                        : TextField(
                            controller: inputControllers[key],
                            focusNode: focusNodes[key],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              counterText: '',
                              isCollapsed: true,
                            ),
                            onChanged: (text) {
                              int? val = int.tryParse(text);
                              controller.updateCell(row, col, val);
                            },
                          ),
                  );
                },
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Score: ${controller.getScore()}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () {
                controller.validateAll();
              },
              child: const Text('Validate All'),
            ),
          ],
        ),
      ),
    );
  }
}
