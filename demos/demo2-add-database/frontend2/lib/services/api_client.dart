import 'dart:convert'; // for jsonDecode
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl = "http://localhost:8080";

  Future<int> getCounter() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/counter"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["value"];
      } else {
        throw Exception("Backend responded with ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Backend unavailable: $e");
    }
  }

  Future<int> incrementCounter() async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/counter/increment"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["value"];
      } else {
        throw Exception("Backend responded with ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Backend unavailable: $e");
    }
  }
}
