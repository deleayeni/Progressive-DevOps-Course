import 'package:flutter/material.dart';

void main() {
  // Entry point of the app. runApp starts the Flutter framework and
  // displays the given widget on the screen.
  runApp(const CounterApp());
}

// A simple app that shows a counter and a button to increment it.
class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo 0 – Counter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterPage(), // The main screen of the app.
    );
  }
}

// A screen that can update when its internal state changes.
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demo 0 – Counter')),
      body: Center(
        child: Text('Counter: $_counter', style: const TextStyle(fontSize: 32)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
