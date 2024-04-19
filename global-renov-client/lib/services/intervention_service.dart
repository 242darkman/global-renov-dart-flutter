import 'package:global_renov/utils/env.dart';
import 'package:global_renov/utils/logger.dart';
import 'package:global_renov/utils/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InterventionService {
  late final String? authToken;

  InterventionService() {
    authToken = PreferenceService.getToken();
  }

  /// Retrieves all interventions asynchronously.
  ///
  /// Sends a GET request to the API endpoint `${Environment.apiUrl}/interventions`.
  /// The request includes the necessary headers, including the authorization token obtained from `PreferenceService.getToken()`.
  ///
  /// If the request is successful (status code 200), the function returns the decoded response body as a `Map<String, dynamic>`.
  /// If an error occurs during the request, the function prints the error and returns `null`.
  ///
  /// Returns a `Future<Map<String, dynamic>?>` representing the result of the API call.
  Future<Map<String, dynamic>?> fetchInterventions() async {
    try {
      String? authToken = PreferenceService.getToken();
      final response = await http.get(
        Uri.parse('${Environment.apiUrl}/interventions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log.severe('Error retrieving interventions : $e');
      return null;
    }

    return null;
  }
}
