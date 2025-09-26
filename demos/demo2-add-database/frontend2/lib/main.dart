import 'package:flutter/material.dart';
import 'services/api_client.dart';   // make sure path is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frontend2 – Persistent Counter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CounterPage(),
    );
  }
}

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  final api = ApiClient();
  int? _counter;       // null = not yet loaded
  String? _error;      // store error messages
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  Future<void> _loadCounter() async {
    setState(() {
      _loading = true;
      _error = null;
    });
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
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Counter API Demo")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("⚠️ Backend unavailable",
                  style: const TextStyle(fontSize: 20, color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadCounter, // retry loading
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
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
