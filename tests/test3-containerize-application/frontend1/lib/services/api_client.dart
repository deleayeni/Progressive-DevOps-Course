import 'dart:convert'; // For decoding JSON responses
import 'package:http/http.dart' as http; // For making HTTP requests

// ApiClient handles HTTP communication with the backend server.
class ApiClient {
  // Base URL of the backend server
  final String baseUrl = "http://localhost:8080";

  // Sends a GET request to retrieve the current counter value
  Future<int> getCounter() async {
    // Build the full URL for the /counter endpoint
    final response = await http.get(Uri.parse("$baseUrl/counter"));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Decode the JSON response body
      final data = jsonDecode(response.body);
      // Extract and return the "value" field from the response
      return data["value"];
    } else {
      // Throw an error if the response was not OK
      throw Exception("Failed to load counter");
    }
  }

  // Sends a POST request to increment the counter and get the updated value
  Future<int> incrementCounter() async {
    // Build the full URL for the /counter/increment endpoint
    final response = await http.post(Uri.parse("$baseUrl/counter/increment"));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Decode the JSON response body
      final data = jsonDecode(response.body);
      // Extract and return the "value" field from the response
      return data["value"];
    } else {
      // Throw an error if the response was not OK
      throw Exception("Failed to increment counter");
    }
  }
}
