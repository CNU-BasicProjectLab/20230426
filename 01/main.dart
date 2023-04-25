import 'package:flutter/material.dart';

/*
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Container(
      color: Colors.blue,
      child: const Center(
        child: Text(
          'Hello World',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    ),
  ));
}
*/
/*
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        color: Colors.blue,
        child: Center(
          child: Text(
            'Hello World',
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
*/

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Text(
            'Hello World',
            style: TextStyle(fontSize: 40, color: Colors.white),
          ),
        ),
      ),
    ),
  );
}
