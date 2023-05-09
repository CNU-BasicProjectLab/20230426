import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'favoritePage.dart';
import 'settingPage.dart';
import 'mapPage.dart';
import 'package:sqflite/sqflite.dart';

class MainPage extends StatefulWidget {
  final Future<Database> database;

  const MainPage({Key? key, required this.database}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> with SingleTickerProviderStateMixin {
  TabController? controller;
  FirebaseDatabase? _database;
  DatabaseReference? reference;

  String _databaseURL = 'https://modutour-cadf9-default-rtdb.firebaseio.com/';
  String? id;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    _database = FirebaseDatabase.instanceFor(databaseURL: _databaseURL, app: Firebase.app());
    reference = _database!.ref().child('mainPage');
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          // TabBarView에 채울 위쳇들
          MapPage(
            databaseReference: reference,
            db: widget.database,
            id : id,
          ),
          FavoritePage(
            databaseReference: reference,
            db: widget.database,
            id : id,
          ),
          SettingPage(),
        ],
      ),
      bottomNavigationBar: TabBar(
        tabs: const <Tab>[
          Tab(icon: Icon(Icons.map),),
          Tab(icon: Icon(Icons.star),),
          Tab(icon: Icon(Icons.settings),),
        ],
        labelColor: Colors.amber,
        indicatorColor: Colors.deepOrangeAccent,
        controller: controller,
      ),
    );
  }
}
