import 'package:flutter/material.dart';
import 'services/api_client.dart'; // Import the API client to communicate with the backend


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frontend1 Demo',
      home: CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final api = ApiClient(); // Instance of the API client

  int _counter = 0;
  bool _loading = true;  // Whether the app is still loading data
  String? _error;        // Holds error message if API call fails

  @override
  void initState() {
    super.initState();
    _loadCounter();    // Fetch the counter value when the widget is first built
  }

  // Load the current counter value from the backend
  Future<void> _loadCounter() async {
    try {
      final value = await api.getCounter(); // Call GET /counter
      setState(() {
        _counter = value;
        _loading = false;
      });
    } catch (e) {
      // Handle error during GET request
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  // Increment the counter value using the backend
  Future<void> _incrementCounter() async {
    try {
      final value = await api.incrementCounter(); // Call POST /counter/increment
      setState(() {
        _counter = value;
      });
    } catch (e) {
      // Handle error during POST request
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());

    if (_error != null) {
      return Scaffold(
        body: Center(child: Text("Error: $_error")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Counter API Demo")),
      body: Center(
        child: Text("Counter: $_counter",
            style: const TextStyle(fontSize: 24)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
