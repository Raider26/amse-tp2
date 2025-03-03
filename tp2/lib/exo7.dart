import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

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
  int countMovementMin = 0;
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
            title: Center(
                child: Text(
              "Félicitations!",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            content: Text("Vous avez gagné en $countMovement mouvements."),
            actions: [
              Center(
                  child: TextButton(
                child: Text(
                  "Rejouer",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  setState(() {
                    countMovement = 0;
                    isWon = false;
                    Navigator.of(context).pop();
                  });
                },
              )),
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

  int aStarSolver() {
    List<int> state = tiles.map((tile) => tile.number).toList();
    int emptyIndex = state.indexOf(0);

    PriorityQueue<List<dynamic>> queue = PriorityQueue(
        (a, b) => (a[1] + heuristic(a[0])).compareTo(b[1] + heuristic(b[0])));

    queue.add([state, 0]); // [État actuel, Nombre de coups]

    Set<String> visited = {};

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      List<int> currentState = current[0];
      int moves = current[1];

      if (isGoalState(currentState)) {
        return moves; // Retourne le nombre minimum de coups
      }

      String key = currentState.join(',');
      if (visited.contains(key)) continue;
      visited.add(key);

      for (var next in generateNextStates(currentState)) {
        if (!visited.contains(next.join(','))) {
          queue.add([next, moves + 1]);
        }
      }
    }
    return -1; // État impossible (ne devrait pas arriver)
  }

  bool isGoalState(List<int> state) {
    return List.generate(gridSize * gridSize, (i) => i).toList().toString() ==
        state.toString();
  }

  int heuristic(List<int> state) {
    int h = 0;
    for (int i = 0; i < state.length; i++) {
      if (state[i] != 0) {
        int correctPosition = state[i] - 1;
        h += (correctPosition % gridSize - i % gridSize).abs() +
            (correctPosition ~/ gridSize - i ~/ gridSize).abs();
      }
    }
    return h;
  }

  List<List<int>> generateNextStates(List<int> state) {
    List<List<int>> nextStates = [];
    int emptyIndex = state.indexOf(0);
    List<int> moves = [-1, 1, -gridSize, gridSize];

    for (var move in moves) {
      int newIndex = emptyIndex + move;
      if (newIndex >= 0 &&
          newIndex < state.length &&
          (move.abs() == 1 &&
                  (newIndex ~/ gridSize == emptyIndex ~/ gridSize) ||
              move.abs() == gridSize)) {
        List<int> newState = List.from(state);
        newState[emptyIndex] = newState[newIndex];
        newState[newIndex] = 0;
        nextStates.add(newState);
      }
    }
    return nextStates;
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
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width * 0.99,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Nombre de coups:",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          countMovement.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    gridSize == 3 ? SizedBox(width: 50) : SizedBox.shrink(),
                    gridSize == 3
                        ? Column(
                            children: [
                              Text(
                                "Nombre de coups minimum:",
                                style: TextStyle(fontSize: 15),
                              ),
                              Text(
                                countMovementMin.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : SizedBox.shrink(),
                  ],
                ),
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
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 50),
                ),
                onPressed: () {
                  setState(() {
                    do {
                      tiles.shuffle();
                    } while (!isResolvable(
                        tiles.indexWhere((tile) => tile.number == 0), tiles));
                    countMovement = 0;
                    if (gridSize == 3) {
                      countMovementMin =
                          aStarSolver(); // Calculer le nombre minimum de coups
                    }
                  });
                },
                child: Text(
                  'Mélanger',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.blue, width: 2),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      "Augmenter/réduire la taille du taquin",
                      style: TextStyle(fontSize: 18),
                    ),
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
