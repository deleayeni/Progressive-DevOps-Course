import 'package:flutter/material.dart';
import 'services/api_client.dart';

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
  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final api = ApiClient();
  int _counter = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    try {
      final value = await api.getCounter();
      setState(() {
        _counter = value;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _incrementCounter() async {
    try {
      final value = await api.incrementCounter();
      setState(() {
        _counter = value;
      });
    } catch (e) {
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
