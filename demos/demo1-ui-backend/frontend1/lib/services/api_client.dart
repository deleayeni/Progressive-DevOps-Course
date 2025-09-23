import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = "http://localhost:8080";

  Future<int> getCounter() async {
    final response = await http.get(Uri.parse("$baseUrl/counter"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["value"];
    } else {
      throw Exception("Failed to load counter");
    }
  }

  Future<int> incrementCounter() async {
    final response = await http.post(Uri.parse("$baseUrl/counter/increment"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["value"];
    } else {
      throw Exception("Failed to increment counter");
    }
  }
}
