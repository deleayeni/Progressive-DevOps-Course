import 'package:flutter/material.dart';
import 'services/api_client.dart'; // Our API client to talk to the backend.

void main() {
  runApp(
    const MaterialApp(
      home: CounterPage(), // Our single screen widget.
    ),
  );
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final api = ApiClient(); // API client to communicate with the backend.
  int _counter = 0; // Stores the current counter value.

  @override
  void initState() {
    super.initState();
    _loadCounter(); // Get the counter value from the backend when the app starts.
  }

  /// Fetches the current counter value from the backend and updates the UI.
  Future<void> _loadCounter() async {
    final value = await api.getCounter(); // GET /counter
    setState(() {
      _counter = value;
    });
  }

  /// Increments the counter using the backend and updates the UI.
  Future<void> _incrementCounter() async {
    final value = await api.incrementCounter(); // POST /counter/increment
    setState(() {
      _counter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Counter API Demo")),
      body: Center(
        child: Text("Counter: $_counter", style: const TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            _incrementCounter, // Call our function when the button is tapped.
        child: const Icon(Icons.add),
      ),
    );
  }
}
