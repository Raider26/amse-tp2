import 'package:flutter/material.dart';

class Tile {
  final int number;
  String urlImage;
  Alignment alignment;
  Tile(this.number, {required this.urlImage, required this.alignment});
}

class TileWidget extends StatelessWidget {
  final Tile tile;
  final VoidCallback? onTap;

  const TileWidget(this.tile, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: tile.number == 0 ? Colors.white : Colors.grey,
        child: tile.number == 0
            ? Container(color: Colors.white)
            : FittedBox(
                fit: BoxFit.fill,
                child: ClipRect(
                  child: Align(
                    alignment: tile.alignment,
                    widthFactor: 0.25,
                    heightFactor: 0.25,
                    child: Image.network(tile.urlImage),
                  ),
                ),
              ),
      ),
    );
  }
}

class Exo6 extends StatefulWidget {
  const Exo6({super.key});

  @override
  State<StatefulWidget> createState() => Exo6State();
}

class Exo6State extends State<Exo6> {
  int gridSize = 4;
  late double step;
  late List<Tile> tiles;

  @override
  void initState() {
    super.initState();
    step = 2 / (gridSize - 1);
    tiles = List.generate(
            15,
            (index) => Tile(index + 1,
                urlImage: 'https://picsum.photos/300',
                alignment: Alignment(-1 + (index % gridSize) * step,
                    -1 + (index ~/ gridSize) * step))) +
        [
          Tile(0,
              urlImage: 'https://picsum.photos/300',
              alignment: Alignment(-1, -1))
        ];
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
        tiles[index] = Tile(0,
            urlImage: 'https://picsum.photos/300',
            alignment: Alignment(-1, -1));
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
