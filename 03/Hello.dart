import 'package:flutter/material.dart';

class Hello extends StatelessWidget {
  const Hello({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Hello'),
        ),
        body: const Center(
            child: Text(
          'Hello Flutter',
          style: TextStyle(fontSize: 20),
        )));
  }
}
