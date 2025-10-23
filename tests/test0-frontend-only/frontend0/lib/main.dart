import 'package:flutter/material.dart';

void main() {
  // Entry point of the app.
  // runApp starts the Flutter framework and renders the given widget on screen.
  runApp(
    const MaterialApp(
      // MaterialApp is the root widget that provides Material Design styling and navigation.
      home: CounterPage(), // Our main screen widget.
    ),
  );
}

// A screen that can update when its internal state changes.
// We use a StatefulWidget because the counter value needs to change dynamically.
class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

// The State class holds the mutable state for CounterPage.
class _CounterPageState extends State<CounterPage> {
  int _counter = 0;

  // setState() is needed to trigger a UI rebuild.
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold provides a standard app layout: app bar, body, floating button, etc.
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        // Center positions its child in the middle of the screen.
        child: Text('$_counter', style: const TextStyle(fontSize: 32)),
      ),
      floatingActionButton: FloatingActionButton(
        // Floating button typically used for primary actions.
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add), // Flutter provides many built-in icons.
      ),
    );
  }
}
