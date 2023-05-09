import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<StatefulWidget> createState() => _MyLogin();
}

class _MyLogin extends State<MyLogin> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  final String _databaseURL = "https://basicprj-5041d-default-rtdb.firebaseio.com/";

  double opacity = 0;
  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;

  @override
  void initState() {
    super.initState();

    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();

    _database = FirebaseDatabase.instanceFor(databaseURL: _databaseURL, app: Firebase.app());
    reference = _database!.ref().child('user');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  "'23 기초프로젝트랩",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _idTextController,
                    maxLines: 1,
                    decoration: const InputDecoration(labelText: '아이디',
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: _pwTextController,
                    obscureText: true,
                    maxLines: 1,
                    decoration: const InputDecoration(labelText: '비밀번호',
                        border: OutlineInputBorder()),
                  ),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/sign');
                        },
                        child: const Text('회원가입')),
                    TextButton(
                        onPressed: () {
                          if(_idTextController!.value.text.isEmpty ||
                              _pwTextController!.value.text.isEmpty) {
                            makeDialog('빈칸이 있습니다.');
                          } else {
                            reference!
                                .child(_idTextController!.value.text)
                                .onValue
                                .listen((event) {
                              if (event.snapshot.value == null) {
                                makeDialog('아이디가 없습니다.');
                              } else {
                                reference!
                                    .child(_idTextController!.value.text)
                                    .onChildAdded
                                    .listen((event) {
                                  User user = User.fromsnapshot(event.snapshot);
                                  var bytes = utf8.encode(_pwTextController!.value.text);
                                  var digest = sha1.convert(bytes);
                                  if(user.pw == digest.toString()) {
                                    //Navigator.of(context).pushReplacementNamed('/main',
                                    //    arguments: _idTextController!.value.text);
                                    makeDialog('로그인 성공');
                                  } else {
                                    makeDialog('비밀번호가 틀립니다.');
                                  }
                                });
                              }
                            });
                          }
                        },
                        child: const Text('로그인')),

                  ],
                ),
                ElevatedButton(onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/main');
                }, child: const Text("Go Main Page")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void makeDialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
          );
        });
  }
}