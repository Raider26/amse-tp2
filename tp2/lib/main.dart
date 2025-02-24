import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double zValue = 0;
  double xValue = 0;
  bool? mirror = false;
  double scale = 1;
  IconData startStop = Icons.play_arrow;
  Timer? timer;

  void animate(Timer t) {
    setState(() {
      zValue >= 2 * pi ? zValue = 0 : zValue = zValue + 0.01;
      xValue >= 2 * pi ? xValue = 0 : xValue = xValue + 0.01;
      scale >= 5 ? scale = 0 : scale = scale + 0.001;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(xValue)
              ..rotateZ(zValue)
              ..rotateY(mirror == false ? 0 : pi)
              ..scale(scale),
            child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(color: Colors.white),
                child: Image(
                    image: NetworkImage("https://picsum.photos/1024/512")))),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Rotate Z: "),
            SizedBox(
              width: 300,
              child: Slider(
                  value: xValue,
                  min: 0,
                  max: 2 * pi,
                  onChanged: (value) {
                    setState(() {
                      xValue = value;
                    });
                  }),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Rotate X: "),
            SizedBox(
              width: 300,
              child: Slider(
                  value: zValue,
                  min: 0,
                  max: 2 * pi,
                  onChanged: (value) {
                    setState(() {
                      zValue = value;
                    });
                  }),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Mirror: "),
            Checkbox(
                value: mirror,
                onChanged: (bool? value) {
                  setState(() {
                    mirror = value;
                  });
                })
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Scale: "),
            SizedBox(
              width: 300,
              child: Slider(
                  value: scale,
                  min: 0,
                  divisions: 20,
                  max: 5,
                  onChanged: (value) {
                    setState(() {
                      scale = value;
                    });
                  }),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (startStop == Icons.play_arrow) {
                      startStop = Icons.pause;
                      const d = Duration(milliseconds: 50);
                      timer = Timer.periodic(d, animate);
                    } else {
                      startStop = Icons.play_arrow;
                      timer?.cancel();
                    }
                  });
                },
                child: Icon(startStop),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
