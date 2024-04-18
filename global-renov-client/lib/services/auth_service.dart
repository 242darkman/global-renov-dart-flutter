import 'package:global_renov/utils/env.dart';
import 'package:global_renov/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<Map<String, dynamic>?> signIn(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${Environment.apiUrl}/auth/sign-in'),
        body: jsonEncode({'email': email.toLowerCase(), 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log.severe('Error signing in: $e');
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> createAccount(
      String email, String password, String firstName, String lastName) async {
    try {
      final response = await http.post(
        Uri.parse('${Environment.apiUrl}/auth/sign-up'),
        body: jsonEncode({
          'email': email.toLowerCase(),
          'password': password,
          'firstName': firstName,
          'lastName': lastName
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log.severe('Error signing in: $e');
      return null;
    }
    return null;
  }

  Future<Map<String, dynamic>?> logout() async {
    try {
      final response = await http.post(
        Uri.parse('${Environment.apiUrl}/auth/sign-up'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log.severe('Error signing in: $e');
      return null;
    }
    return null;
  }
}
