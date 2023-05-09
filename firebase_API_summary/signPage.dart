import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'user.dart';

class SignPage extends StatefulWidget {
  const SignPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignPage();

}

class _SignPage extends State<SignPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  final String _databaseURL = 'https://basicprj-5041d-default-rtdb.firebaseio.com/';

  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;
  TextEditingController? _pwCheckTextController;

  @override
  void initState() {
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _pwCheckTextController = TextEditingController();

    _database = FirebaseDatabase.instanceFor(databaseURL: _databaseURL, app: Firebase.app());
    reference = _database?.ref().child('user');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              child: TextField(
                controller: _idTextController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: '4자 이상 입력해주세요',
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
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
                decoration: const InputDecoration(
                  hintText: '6자 이상 입력해주세요',
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _pwCheckTextController,
                obscureText: true,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: '비밀번호 확인',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_idTextController!.value.text.length >= 4 &&
                  _pwTextController!.value.text.length >= 6) {
                    if(_pwTextController!.value.text == _pwCheckTextController!.value.text) {
                      var bytes = utf8.encode(_pwTextController!.value.text);
                      var digest = sha1.convert(bytes);
                      reference!
                      .child(_idTextController!.value.text)
                      .push()
                      .set(User(
                          id: _idTextController!.value.text,
                          pw: digest.toString(),
                          createTime: DateTime.now().toIso8601String()).toJson())
                      .then((_) {
                        Navigator.of(context).pushReplacementNamed('/login');
                      });
                    } else {
                      makeDialog('비밀번호가 틀립니다.');
                    }
                  } else {
                    makeDialog('길이가 짧습니다');
                  }
                },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                child: const Text(
                  '회원가입',
                  style: TextStyle(color: Colors.white),
                ),
            ),
            ElevatedButton(onPressed: () {
              Navigator.of(context).pushReplacementNamed('/main');
            }, child: const Text("Go Main Page")),
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