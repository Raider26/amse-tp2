import 'dart:math';
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
  final bool showTileNumbers;

  const TileWidget(this.tile,
      {super.key, this.onTap, required this.showTileNumbers});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: tile.number == 0 ? Colors.white : Colors.grey,
          border:
              tile.number == 0 ? Border.all(color: Colors.red, width: 2) : null,
        ),
        child: tile.number == 0
            ? Container(
                color: Colors.grey,
              )
            : FittedBox(
                fit: BoxFit.fill,
                child: Stack(children: [
                  ClipRect(
                    child: Align(
                      alignment: tile.alignment,
                      widthFactor: tile.factor,
                      heightFactor: tile.factor,
                      child: tile.urlImage.startsWith('assets/')
                          ? Image.asset(
                              tile.urlImage,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              tile.urlImage,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.network(
                                    "https://picsum.photos/300");
                              },
                            ),
                    ),
                  ),
                  if (showTileNumbers)
                    Positioned(
                      top: 5,
                      left: 5,
                      child: Container(
                        width: 30,
                        height: 30,
                        color: Colors.black54,
                        child: Center(
                          child: Text(
                            tile.number.toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ]),
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
  bool hoverButtonMinus = false;
  bool hoverButtonPlus = false;
  int countMovement = 0;
  int countMovementMin = 0;
  bool isWon = false;
  int posZeroBack = -1;
  int deplacements = 0;
  String image = "Aléatoire";
  bool useMelangeXCoups = false; // Variable pour suivre l'état du switch
  bool showTileNumbers = false;
  bool useResolver = false;
  bool isLoading = false;
  String mode = "Mélange aléatoire";
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

  TextEditingController deplacementsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateTiles("Aléatoire");
    deplacementsController.text =
        deplacements > 0 ? deplacements.toString() : "";
  }

  void generateTiles(String image) {
    step = 2 / (gridSize - 1);
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
    List<int> adjacentIndices = [];

    // Vérifier les indices adjacents valides
    if (emptyIndex % gridSize != 0) {
      adjacentIndices.add(emptyIndex - 1); // Gauche
    }
    if (emptyIndex % gridSize != gridSize - 1) {
      adjacentIndices.add(emptyIndex + 1); // Droite
    }
    if (emptyIndex >= gridSize) {
      adjacentIndices.add(emptyIndex - gridSize); // Haut
    }
    if (emptyIndex < gridSize * (gridSize - 1)) {
      adjacentIndices.add(emptyIndex + gridSize); // Bas
    }

    if (adjacentIndices.contains(index) && index >= 0 && index < tiles.length) {
      setState(() {
        posZeroBack = emptyIndex;
        tiles[emptyIndex] = tiles[index];
        tiles[index] = Tile(0,
            urlImage: getImage(image),
            alignment: Alignment(-1 + (index % gridSize) * step,
                -1 + (index ~/ gridSize) * step),
            factor: 1 / gridSize);
        countMovement++;
      });

      checkIfWon();
    }
  }

  void back() {
    if ((posZeroBack != -1) &&
        (posZeroBack != tiles.indexWhere((tile) => tile.number == 0))) {
      setState(() {
        int emptyIndex = tiles.indexWhere((tile) => tile.number == 0);
        Tile temp = tiles[posZeroBack];
        tiles[posZeroBack] = tiles[emptyIndex];
        tiles[emptyIndex] = temp;
        countMovement--;
        posZeroBack = -1;
      });
    }
  }

  void melangeXCoups(int deplacements) {
    int emptyIndex = tiles.indexWhere((tile) => tile.number == 0);

    for (int i = 0; i < deplacements; i++) {
      List<int> adjacentIndices = [];

      if ((emptyIndex % gridSize != 0) && (emptyIndex - 1 != posZeroBack)) {
        adjacentIndices.add(emptyIndex - 1);
      }
      if ((emptyIndex % gridSize != gridSize - 1) &&
          (emptyIndex + 1 != posZeroBack)) {
        adjacentIndices.add(emptyIndex + 1);
      }
      if ((emptyIndex >= gridSize) && (emptyIndex - gridSize != posZeroBack)) {
        adjacentIndices.add(emptyIndex - gridSize);
      }
      if ((emptyIndex < gridSize * (gridSize - 1)) &&
          (emptyIndex + gridSize != posZeroBack)) {
        adjacentIndices.add(emptyIndex + gridSize);
      }

      int caseAleatoire =
          adjacentIndices[Random().nextInt(adjacentIndices.length)];

      setState(() {
        tiles[emptyIndex] = tiles[caseAleatoire];
        tiles[caseAleatoire] = Tile(0,
            urlImage: getImage(image),
            alignment: Alignment(-1, -1),
            factor: 1 / gridSize);
        emptyIndex = caseAleatoire;
      });
      posZeroBack = emptyIndex;
    }
    posZeroBack = emptyIndex;
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
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue),
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

  void settings() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Center(
                  child: Text(
                "Paramètres",
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )),
              actions: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            mode,
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          activeColor: Colors.blue,
                          value: useMelangeXCoups,
                          onChanged: (value) {
                            setState(() {
                              useMelangeXCoups = value;
                              if (value) {
                                mode = "Mélange X coups";
                              } else {
                                mode = "Mélange aléatoire";
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Afficher les numéros des tuiles",
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          activeColor: Colors.blue,
                          value: showTileNumbers,
                          onChanged: (value) {
                            setState(() {
                              showTileNumbers = value;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "Indication du nombre minimal de coups pour 3x3 (nécessite un temps de chargment)",
                            style: TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Utiliser le solveur",
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Switch(
                          activeColor: Colors.blue,
                          value: useResolver,
                          onChanged: (value) {
                            setState(() {
                              useResolver = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text("Fermer",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue))),
                      ],
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    ).then((_) {
      setState(() {});
    });
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

    PriorityQueue<List<dynamic>> queue = PriorityQueue(
        (a, b) => (a[1] + heuristic(a[0])).compareTo(b[1] + heuristic(b[0])));

    queue.add([state, 0]);

    Set<String> visited = {};

    while (queue.isNotEmpty) {
      var current = queue.removeFirst();
      List<int> currentState = current[0];
      int moves = current[1];

      if (isGoalState(currentState)) {
        return moves;
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
    return -1;
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
      appBar: AppBar(
        title: Text('Exercice 7'),
        backgroundColor: const Color.fromARGB(255, 222, 227, 248),
        actions: [
          ElevatedButton(
              onPressed: settings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Icon(Icons.settings, color: Colors.white)),
          SizedBox(width: 20),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 222, 227, 248),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width * 0.8,
                height: 100,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Coups:",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            countMovement.toString(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      (gridSize == 3 && useResolver)
                          ? SizedBox(width: 30)
                          : SizedBox.shrink(),
                      (gridSize == 3 && useResolver)
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Coups minimum:",
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  countMovementMin.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      back();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      iconSize: 15,
                      padding: EdgeInsets.all(20),
                      backgroundColor: Colors.blue,
                    ),
                    child: Icon(Icons.undo, color: Colors.white),
                  ),
                  SizedBox(width: 40),
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 222, 227, 248),
                    ),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onHover: (bool value) => setState(() {
                            hoverButtonMinus = value;
                          }),
                          onPressed: () {
                            setState(() {
                              if (gridSize > 2) {
                                gridSize = gridSize - 1;
                                generateTiles(image);
                                countMovement = 0;
                                deplacements = 0;
                                deplacementsController.text =
                                    deplacements.toString();
                                countMovementMin = 0;
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            iconSize: 15,
                            padding: EdgeInsets.all(20),
                            backgroundColor:
                                hoverButtonMinus ? Colors.white : Colors.blue,
                          ),
                          child: Text('-',
                              style: TextStyle(
                                  color: hoverButtonMinus
                                      ? Colors.blue
                                      : Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(width: 5),
                        ElevatedButton(
                          onHover: (bool value) => setState(() {
                            hoverButtonPlus = value;
                          }),
                          onPressed: () {
                            setState(() {
                              if (gridSize < 8) {
                                gridSize = gridSize + 1;
                                generateTiles(image);
                                countMovement = 0;
                                countMovementMin = 0;
                                deplacements = 0;
                                deplacementsController.text =
                                    deplacements.toString();
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            iconSize: 15,
                            padding: EdgeInsets.all(20),
                            backgroundColor:
                                hoverButtonPlus ? Colors.white : Colors.blue,
                          ),
                          child: Text('+',
                              style: TextStyle(
                                  color: hoverButtonPlus
                                      ? Colors.blue
                                      : Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
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
                    return TileWidget(
                      tiles[index],
                      onTap: () {
                        swapTiles(index, getImage(image));
                      },
                      showTileNumbers: showTileNumbers,
                    );
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
                        : Icon(
                            Icons.remove_red_eye,
                            size: 20,
                            color: Colors.blue,
                          ),
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
              SizedBox(height: 10),
              if (useMelangeXCoups)
                Row(
                  children: [
                    SizedBox(width: 20),
                    Expanded(
                      child: TextField(
                        controller: deplacementsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Mélanges",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            deplacements = int.tryParse(value) ?? deplacements;
                            if (value == "") {
                              deplacements = 0;
                            }
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 50),
                          backgroundColor: Colors.blue),
                      onPressed: () {
                        setState(() {
                          melangeXCoups(deplacements);
                        });
                      },
                      child: Row(
                        children: [
                          Text(
                            'Mélanger',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.shuffle,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              if (!useMelangeXCoups)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(200, 50),
                    maximumSize: Size(250, 50),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      do {
                        tiles.shuffle();
                        posZeroBack =
                            tiles.indexWhere((tile) => tile.number == 0);
                      } while (!isResolvable(
                          tiles.indexWhere((tile) => tile.number == 0), tiles));
                      countMovement = 0;
                      if ((gridSize == 3) && (useResolver)) {
                        countMovementMin = aStarSolver();
                      }
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Mélanger',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.shuffle,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
