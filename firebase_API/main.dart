import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'signPage.dart';
import 'mainPage.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'tour_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE place(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title TEXT, tel TEXT, zipcode TEXT, address TEXT, "
              "mapx Number, mapy Number, imagepath TEXT)",
        );
      },
      version: 1,
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Future<Database> database = initDatabase();

    return MaterialApp(
      title: "'23 기초프로젝트랩",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/' : (context) {
          return FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if(snapshot.hasError) {
                return const Center(
                  child: Text('Error'),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                _getToken();
                _initFirebaseMessaging();
                return const LoginPage();
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
        '/sign' : (context) => const SignPage(),
        '/main' : (context) => MainPage(database: database),
      },
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

_initFirebaseMessaging()  {
  FirebaseMessaging.onMessage.listen((RemoteMessage event) async {

    print(event.data);
    print(event.notification!.title);
    bool? pushCheck = await _loadData();
    if(pushCheck!){
      showDialog(
          context: navigatorKey.currentContext!,
          builder: (context) {
            return AlertDialog(
              title: Text(event.notification!.title!),
              content: Text(event.notification!.body!),
              actions: [
                TextButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});
}

Future<bool?> _loadData() async {
  var key = "push";
  SharedPreferences pref = await SharedPreferences.getInstance();
  var value = pref.getBool(key);
  return value;
}

_getToken() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  print("messaging.getToken(), ${await messaging.getToken()}");
}