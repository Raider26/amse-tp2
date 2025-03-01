import 'package:flutter/material.dart';
import 'package:tp2/exo2.dart';
import 'package:tp2/exo4.dart';
import 'package:tp2/exo5.dart';
import 'package:tp2/exo6.dart';
import 'package:tp2/exo7.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Map<String, dynamic>> items = [
    {"title": "Exo 2", "page": Exo2()},
    {"title": "Exo 4", "page": Exo4()},
    {"title": "Exo 5", "page": Exo5()},
    {"title": "Exo 6", "page": Exo6()},
    {"title": "Exo 7", "page": Exo7()}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des pages")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              leading: Icon(Icons.arrow_forward_ios),
              hoverColor: Colors.white38,
              title: Center(
                child: Text(
                  items[index]['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              tileColor: index.isEven ? Colors.lightBlue : Colors.lightGreen,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => items[index]['page'],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
