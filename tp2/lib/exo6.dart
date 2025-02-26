import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: TileGame()));

class TileGame extends StatefulWidget {
  @override
  _TileGameState createState() => _TileGameState();
}

class _TileGameState extends State<TileGame> {
  final int gridSize = 4;
  List<int> tiles = List.generate(15, (index) => index + 1) + [0];

  @override
  void initState() {
    super.initState();
    tiles.shuffle();
  }

  void moveTile(int index) {
    int emptyIndex = tiles.indexOf(0);
    List<int> adjacentIndices = [
      emptyIndex - 1, // Left
      emptyIndex + 1, // Right
      emptyIndex - gridSize, // Up
      emptyIndex + gridSize // Down
    ];

    if (adjacentIndices.contains(index)) {
      setState(() {
        tiles[emptyIndex] = tiles[index];
        tiles[index] = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sliding Puzzle')),
      body: Center(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridSize,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
          ),
          padding: EdgeInsets.all(20),
          itemCount: gridSize * gridSize,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => moveTile(index),
              child: Container(
                decoration: BoxDecoration(
                  color: tiles[index] == 0 ? Colors.white : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: tiles[index] != 0
                      ? Text(
                          tiles[index].toString(),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        )
                      : SizedBox.shrink(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
