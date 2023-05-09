import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class MyRTDB extends StatefulWidget {
  const MyRTDB({Key? key}) : super(key: key);

  @override
  State<MyRTDB> createState() => _MyRTDBState();
}

class _MyRTDBState extends State<MyRTDB> {
  final FirebaseDatabase _realtime = FirebaseDatabase.instance;

  List myList = List.empty(growable: true);
  String petName = '';
  int age = 0;

  Future<void> createDB() async {
    final ref = _realtime.ref().child("test");
    await ref.child("key1").set({
      "petName" : "몽이",
      "age" : 2,
    });
    await ref.child("key2").set({
      "petName" : "깨몽",
      "age" : 5,
    });
  }

  Future<void> readDB() async {
    DatabaseReference ref = _realtime.ref().child("test").child("key1");
    final snapshot = await ref.get();
    Map<String, dynamic> snapshotValue = Map<String, dynamic>.from(snapshot.value as Map);
    setState(() {
      petName = snapshotValue['petName'];
      age = snapshotValue['age'];
    });
  }


  Future<void> updateDB() async {
    final ref = _realtime.ref().child("test");
    await ref.child("key1").update({
      "age" : 12,
    });
  }

  Future<void> deleteDB() async {
      final ref = _realtime.ref().child("test");
      await ref.child("key1").remove();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("RTDB Page"),
            ElevatedButton(onPressed: () {
              createDB();
            }, child: const Text("DB create")),
            ElevatedButton(onPressed: () {
              readDB();
            }, child: const Text("DB read")),
            Text(petName),
            Text('$age'),
            ElevatedButton(onPressed: () {
              updateDB();
            }, child: const Text("DB update")),
            ElevatedButton(onPressed: () {
              deleteDB();
            }, child: const Text("DB delete")),
            ElevatedButton(onPressed: () {
              Navigator.of(context).pushReplacementNamed('/api');
            }, child: const Text("Go API Page")),
          ],
        ),
      ),
    );
  }
}
