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
                    child: Image.network(
                      tile.urlImage,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.network("https://picsum.photos/300");
                      },
                    ),
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
  bool showSmallImage = true;
  int countMovement = 0;
  bool isWon = false;
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
        countMovement++;
      });
      checkIfWon();
    }
  }

  void checkIfWon() {
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i].number != i + 1) {
        return;
      }
    }
    setState(() {
      isWon = true;
    });
    if (isWon) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Félicitations!"),
            content: Text("Vous avez gagné en $countMovement mouvements."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  setState(() {
                    countMovement = 0;
                    isWon = false;
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        },
      );
    }
  }

  String getImage(String image) {
    switch (image) {
      case "Aléatoire":
        return "https://picsum.photos/300";
      case "Image 1":
        return "assets/images/taquin1.jpg";
      case "Image 2":
        return "assets/images/taquin2.jpg";
      case "Image 3":
        return "assets/images/taquin3.jpg";
      case "Image 4":
        return "assets/images/taquin4.jpg";
      case "Image 5":
        return "assets/images/taquin5.jpg";
      case "Image 6":
        return "assets/images/taquin6.jpg";
      case "Image 7":
        return "assets/images/taquin7.jpg";
      case "Image 8":
        return "assets/images/taquin8.jpg";
      case "Image 9":
        return "assets/images/taquin9.jpg";
      case "Image 10":
        return "assets/images/taquin10.jpg";
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Nombre de coups:",
                style: TextStyle(fontSize: 20),
              ),
              Text(
                countMovement.toString(),
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 350,
                  maxHeight: 350,
                ),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  padding: EdgeInsets.all(20),
                  itemCount: gridSize * gridSize,
                  itemBuilder: (context, index) {
                    return TileWidget(tiles[index], onTap: () {
                      swapTiles(index, getImage(image));
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        showSmallImage = !showSmallImage;
                      });
                    },
                    icon: showSmallImage
                        ? Icon(Icons.remove_red_eye_outlined, size: 20)
                        : Icon(Icons.remove_red_eye, size: 20),
                  ),
                  showSmallImage
                      ? image == "Aléatoire"
                          ? Image.network(
                              getImage(image),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              getImage(image),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                      : SizedBox.shrink(),
                ],
              ),
              showSmallImage
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      SizedBox(width: 20),
                      Text(
                        "Modèle",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ])
                  : SizedBox.shrink(),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Choisissez une image: ",
                    style: TextStyle(fontSize: 18),
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
                ],
              ),
              SizedBox(height: 20),
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
                child: Text(
                  'Mélanger',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (gridSize > 2) {
                          gridSize = gridSize - 1;
                          generateTiles(image);
                          countMovement = 0;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('-',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        gridSize < 8
                            ? gridSize = gridSize + 1
                            : gridSize = gridSize;
                        generateTiles(image);
                        countMovement = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.blue,
                    ),
                    child: Text('+',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
