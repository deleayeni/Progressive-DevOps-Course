import 'package:flutter_test/flutter_test.dart';
import '../lib/services/api_client.dart';

void main() {
  group('Frontend to Backend Integration Tests', () {
    late ApiClient api;
    
    setUp(() {
      // Create API client
      api = ApiClient();
    });

    test('GET /counter returns current value from backend', () async {
      // Act: Call the API
      final value = await api.getCounter();
      
      // Assert: Should return a valid integer
      expect(value, isA<int>());
      expect(value, greaterThanOrEqualTo(0));
    });

    test('POST /counter/increment increments and returns new value', () async {
      // Arrange: Get initial value
      final initialValue = await api.getCounter();
      
      // Act: Increment
      final newValue = await api.incrementCounter();
      
      // Assert: Should be incremented
      expect(newValue, equals(initialValue + 1));
    });

    test('Multiple increments work correctly', () async {
      // Arrange: Get initial value
      final initialValue = await api.getCounter();
      
      // Act: Increment multiple times
      final value1 = await api.incrementCounter();
      final value2 = await api.incrementCounter();
      final value3 = await api.incrementCounter();
      
      // Assert: Each should increment
      expect(value1, equals(initialValue + 1));
      expect(value2, equals(initialValue + 2));
      expect(value3, equals(initialValue + 3));
    });
  });
}