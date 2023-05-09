import 'package:fire_api/api.dart';
import 'package:fire_api/login.dart';
import 'package:fire_api/rtdb.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'signPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: '/main',
      routes: {
        '/main': (context) => MyHomePage(
              title: 'Flutter Demo Home Page',
              analytics: analytics,
            ),
        '/rtdb': (context) => const MyRTDB(),
        '/api': (context) => const MyAPI(),
        '/login': (context) => const MyLogin(),
        '/sign': (context) => const SignPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.analytics});

  final String title;
  final FirebaseAnalytics analytics;

  @override
  State<MyHomePage> createState() => _MyHomePageState(analytics);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState(this.analytics);

  final FirebaseAnalytics analytics;

  int _counter = 0;
  String _message = '';

  Future<void> _sendAnalyticsEvent() async {
    await analytics.logEvent(
      name: 'test_20230509',
      parameters: <String, dynamic>{
        'string': 'Count',
        'int': _counter,
      },
    );

    setState(() {
      _message = 'Analytics event send!';
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    _sendAnalyticsEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:\nThis is Event Page',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              _message,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/rtdb');
                },
                child: const Text("Go DB Page")),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Firebase Event',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
