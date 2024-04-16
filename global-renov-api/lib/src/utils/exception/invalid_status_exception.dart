import 'dart:convert';

class InvalidStatusException implements Exception {
  final String message;

  InvalidStatusException(this.message);

  @override
  String toString() {
    return jsonEncode(
        {'error': 'Invalid status', 'code_status': 400, 'message': message});
  }
}
