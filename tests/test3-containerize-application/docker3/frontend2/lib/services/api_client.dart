import 'dart:convert'; // Provides jsonDecode() for decoding JSON responses
import 'package:http/http.dart' as http; // For making HTTP requests

// ApiClient handles HTTP communication with the backend server.
class ApiClient {
  final String baseUrl = "http://localhost:8080";

  // This method returns a Future because HTTP requests are asynchronous operations.
  // In Flutter, network calls must not block the UI thread.
  Future<int> getCounter() async {
    final response = await http.get(Uri.parse("$baseUrl/counter"));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // jsonDecode parses a JSON string into a Map<String, dynamic>, Dart’s standard format.
      final data = jsonDecode(response.body);
      return data["value"];
    } else {
      throw Exception("Failed to load counter");
    }
  }

  Future<int> incrementCounter() async {
    final response = await http.post(Uri.parse("$baseUrl/counter/increment"));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Decode the JSON response body
      final data = jsonDecode(response.body);
      return data["value"];
    } else {
      throw Exception("Failed to increment counter");
    }
  }
}
