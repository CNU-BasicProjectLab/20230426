import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Screen'),
      ),
      body: Center(
        child: /*RaisedButton*/ ElevatedButton(
          child: const Text('Launch screen'),
          onPressed: () {
            // Named route를 사용하여 두 번째 화면으로 전환합니다.
            Navigator.pushNamed(context, '/second');
          },
        ),
      ),
    );
  }
}
