import 'package:flutter/material.dart';

class Tile {
  String imageURL;
  Alignment alignment;

  Tile({required this.imageURL, required this.alignment});

  Widget croppedImageTile(int gridSize) {
    double factor = 1 / gridSize;
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Align(
          alignment: alignment,
          widthFactor: factor,
          heightFactor: factor,
          child: Image.network(imageURL),
        ),
      ),
    );
  }
}

Tile tile1 =
    Tile(imageURL: 'https://picsum.photos/300', alignment: Alignment(-1, -1));

Tile tile2 =
    Tile(imageURL: 'https://picsum.photos/300', alignment: Alignment(0, -1));

List<Widget> createTile(int gridSize) {
  List<Widget> grid = [];
  double step = 2 / (gridSize - 1);

  for (int i = 0; i < gridSize * gridSize; i++) {
    double x = -1 + (i % gridSize) * step;
    double y = -1 + (i ~/ gridSize) * step;
    grid.add(Container(
        child: Tile(
                imageURL: 'https://picsum.photos/1024',
                alignment: Alignment(x, y))
            .croppedImageTile(gridSize)));
  }
  return grid;
}

class Exo5 extends StatefulWidget {
  const Exo5({super.key});

  @override
  State<Exo5> createState() => _Exo5State();
}

class _Exo5State extends State<Exo5> {
  int gridSize = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exercice 5"),
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1),
                children: createTile(gridSize),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Size: "),
              SizedBox(
                width: 300,
                child: Slider(
                    value: gridSize.toDouble(),
                    label: gridSize.toString(),
                    min: 2,
                    divisions: 9,
                    max: 10,
                    onChanged: (value) {
                      setState(() {
                        gridSize = value.toInt();
                      });
                    }),
              )
            ],
          ),
        ],
      ),
    );
  }
}
