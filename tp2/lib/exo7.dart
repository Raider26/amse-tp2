import 'package:flutter/material.dart';

class Tile {
  final int number;
  String urlImage;
  Alignment alignment;
  double factor;
  Tile(this.number,
      {required this.urlImage, required this.alignment, required this.factor});
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
            ? Container(color: Colors.grey)
            : FittedBox(
                fit: BoxFit.fill,
                child: ClipRect(
                  child: Align(
                    alignment: tile.alignment,
                    widthFactor: tile.factor,
                    heightFactor: tile.factor,
                    child: Image.network(tile.urlImage),
                  ),
                ),
              ),
      ),
    );
  }
}

class Exo7 extends StatefulWidget {
  const Exo7({super.key});

  @override
  State<StatefulWidget> createState() => Exo7State();
}

class Exo7State extends State<Exo7> {
  int gridSize = 4;
  late double step;
  late List<Tile> tiles;
  int countMovement = 0;
  String image = "Aléatoire";
  List<String> dropdownMenuItems = [
    "Aléatoire",
    "Image 1",
    "Image 2",
    "Image 3",
    "Image 4",
    "Image 5",
    "Image 6",
    "Image 7",
    "Image 8",
    "Image 9",
    "Image 10"
  ];

  @override
  void initState() {
    super.initState();
    generateTiles("Aléatoire");
  }

  void generateTiles(String image) {
    double step = 2 / (gridSize - 1);
    tiles = List.generate(
            gridSize * gridSize - 1,
            (index) => Tile(index + 1,
                urlImage: getImage(image),
                alignment: Alignment(-1 + (index % gridSize) * step,
                    -1 + (index ~/ gridSize) * step),
                factor: 1 / gridSize)) +
        [
          Tile(0,
              urlImage: getImage(image),
              alignment: Alignment(-1, -1),
              factor: 1 / gridSize)
        ];
  }

  void swapTiles(int index, String image) {
    int emptyIndex = tiles.indexWhere((tile) => tile.number == 0);
    List<int> adjacentIndices = [
      emptyIndex - 1,
      emptyIndex + 1,
      emptyIndex - gridSize,
      emptyIndex + gridSize
    ];
    if (adjacentIndices.contains(index) && index >= 0 && index < tiles.length) {
      setState(() {
        tiles[emptyIndex] = tiles[index];
        tiles[index] = Tile(0,
            urlImage: getImage(image),
            alignment: Alignment(-1, -1),
            factor: 1 / gridSize);
      });
    }
  }

  String getImage(String image) {
    switch (image) {
      case "Aléatoire":
        return "https://picsum.photos/300";
      case "Image 1":
        return "assets/images/taquin1.jpg";
      default:
        return "https://picsum.photos/300";
    }
  }

  bool isResolvable(int indexEmpty, List<Tile> tiles) {
    int inversions = 0;
    List<int> tileNumbers = tiles.map((tile) => tile.number).toList();

    for (int i = 0; i < tileNumbers.length; i++) {
      for (int j = i + 1; j < tileNumbers.length; j++) {
        if (tileNumbers[i] != 0 &&
            tileNumbers[j] != 0 &&
            tileNumbers[i] > tileNumbers[j]) {
          inversions++;
        }
      }
    }
    if (gridSize % 2 == 1) {
      return inversions % 2 == 0;
    } else {
      int blankRowFromBottom = gridSize - (indexEmpty ~/ gridSize);
      if (blankRowFromBottom % 2 == 0) {
        return inversions % 2 == 1;
      } else {
        return inversions % 2 == 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Exercice 7')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nombre de coups:"),
            Text(countMovement.toString()),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                padding: EdgeInsets.all(20),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  return TileWidget(tiles[index], onTap: () {
                    swapTiles(index, getImage(image));
                    countMovement++;
                  });
                },
              ),
            ),
            DropdownButton<String>(
              value: image,
              items: dropdownMenuItems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  image = newValue!;
                  generateTiles(image);
                  countMovement = 0;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  do {
                    tiles.shuffle();
                  } while (!isResolvable(
                      tiles.indexWhere((tile) => tile.number == 0), tiles));
                  countMovement = 0;
                });
              },
              child: Text('Shuffle'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (gridSize > 1) {
                        gridSize = gridSize - 1;
                        generateTiles(image);
                        countMovement = 0;
                      }
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue)),
                  child: Text('-',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      gridSize = gridSize + 1;
                      generateTiles(image);
                      countMovement = 0;
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.blue)),
                  child: Text('+',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
