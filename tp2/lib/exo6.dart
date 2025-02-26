import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: PositionedTiles()));

class Tile {
  final int number;
  Tile(this.number);
}

class TileWidget extends StatelessWidget {
  final Tile tile;
  final VoidCallback? onTap;

  TileWidget(this.tile, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: tile.number == 0 ? Colors.white : Colors.grey,
        child: Center(
          child: tile.number != 0
              ? Text("${tile.number}", style: TextStyle(fontSize: 24))
              : SizedBox.shrink(),
        ),
      ),
    );
  }
}

class PositionedTiles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PositionedTilesState();
}

class PositionedTilesState extends State<PositionedTiles> {
  int gridSize = 4;
  List<Tile> tiles = List.generate(15, (index) => Tile(index + 1)) + [Tile(0)];

  @override
  void initState() {
    super.initState();
    tiles.shuffle();
  }

  void swapTiles(int index) {
    int emptyIndex = tiles.indexWhere((tile) => tile.number == 0);
    List<int> adjacentIndices = [
      emptyIndex - 1,
      emptyIndex + 1,
      emptyIndex - gridSize,
      emptyIndex + gridSize
    ];
    if (adjacentIndices.contains(index)) {
      setState(() {
        tiles[emptyIndex] = tiles[index];
        tiles[index] = Tile(0);
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
            return TileWidget(tiles[index], onTap: () => swapTiles(index));
          },
        ),
      ),
    );
  }
}
