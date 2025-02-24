import 'package:flutter/material.dart';
import 'package:tp2/exo2.dart';
import 'package:tp2/exo4.dart';

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
    {"title": "Exo 5", "page": Exo2()},
    {"title": "Exo 6", "page": Exo2()},
    {"title": "Exo 7", "page": Exo2()}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des pages")),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]['title']),
            leading: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => items[index]['page'],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
