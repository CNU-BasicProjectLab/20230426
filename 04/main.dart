import 'package:flutter/material.dart';
import 'FirstScreen.dart';
import 'SecondScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // !!! 경고: initialRoute를 사용한다면, home프로퍼티를 정의하지 마세요
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/',
      routes: {
        // "/" Route로 이동하면, FirstScreen 위젯을 생성합니다.
        '/': (context) => const FirstScreen(),
        // "/second" route로 이동하면, SecondScreen 위젯을 생성합니다.
        '/second': (context) => const SecondScreen(),
      },
    );
  }
}
