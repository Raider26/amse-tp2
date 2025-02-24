import 'package:flutter/material.dart';

class Exo5 extends StatefulWidget {
  const Exo5({super.key});

  @override
  State<Exo5> createState() => _Exo5State();
}

class _Exo5State extends State<Exo5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Exercice 5"),
        ),
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1),
              children: [
                Container(
                  color: Colors.blue,
                  child: Center(
                      child: Text(
                    "1",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
                Container(
                  color: Colors.purple,
                  child: Center(
                      child: Text(
                    "2",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
                Container(
                  color: Colors.green,
                  child: Center(
                      child: Text(
                    "3",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
                Container(
                  color: Colors.yellow,
                  child: Center(
                      child: Text(
                    "4",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
                Container(
                  color: Colors.orange,
                  child: Center(
                      child: Text(
                    "5",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
                Container(
                  color: Colors.red,
                  child: Center(
                      child: Text(
                    "6",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
                Container(
                  color: Colors.white,
                  child: Center(
                      child: Text(
                    "7",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
                Container(
                  color: Colors.grey,
                  child: Center(
                      child: Text(
                    "8",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                ),
                Container(
                  color: Colors.brown,
                  child: Center(
                      child: Text(
                    "9",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )),
                )
              ],
            ),
          ),
        ));
  }
}
