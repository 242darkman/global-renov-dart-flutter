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


  /// Asynchronously changes the status of an intervention with the given [status] and [idIntervention].
  ///
  /// Sends a PATCH request to the API endpoint `${Environment.apiUrl}/interventions/change-status/$idIntervention`
  /// with the provided [status]. The request includes the necessary headers, including the authorization token obtained
  /// from `PreferenceService.getToken()`.
  ///
  /// If the request is successful (status code 200), the function returns the decoded response body as a `Map<String, dynamic>`.
  /// If an error occurs during the request, the function prints the error and returns `null`.
  ///
  /// Parameters:
  /// - `status`: The new status of the intervention.
  /// - `idIntervention`: The ID of the intervention to be updated.
  ///
  /// Returns a `Future<Map<String, dynamic>?>` representing the result of the API call.
  Future<Map<String, dynamic>?> changeStatusIntervention(
      String status, String idIntervention) async {
    try {
      final response = await http.patch(
        Uri.parse(
            '${Environment.apiUrl}/interventions/change-status/$idIntervention'),
        body: jsonEncode({'status': status}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      log.severe('Error changing status intervention: $e');
      return null;
    }

    return null;
  }

  /// Asynchronously deletes an intervention with the given [idIntervention].
  ///
  /// Sends a DELETE request to the API endpoint `${Environment.apiUrl}/interventions/delete/$idIntervention`
  /// with the necessary headers, including the authorization token obtained from `PreferenceService.getToken()`.
  ///
  /// If the request is successful (status code 200), the function returns the decoded response body as a `Map<String, dynamic>`.
  /// If an error occurs during the request, the function prints the error and returns `null`.
  ///
  /// Parameters:
  /// - `idIntervention`: The ID of the intervention to be deleted.
  ///
  /// Returns a `Future<Map<String, dynamic>?>` representing the result of the API call.
  Future<Map<String, dynamic>?> deleteAnIntervention(
      String idIntervention) async {
    try {
      final response = await http.delete(
        Uri.parse('${Environment.apiUrl}/interventions/delete/$idIntervention'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      print('Error deleting intervention: $e');
      log.severe('Error deleting intervention: $e');
      return null;
    }
  }

  /// Asynchronously retrieves a single intervention by [idIntervention].
  ///
  /// Sends a GET request to the API endpoint `${Environment.apiUrl}/interventions/$idIntervention`
  /// with the necessary headers, including the authorization token obtained from `PreferenceService.getToken()`.
  ///
  /// If the request is successful (status code 200), the function returns the decoded response body as a `Map<String, dynamic>`.
  /// If an error occurs during the request, the function prints the error and returns `null`.
  ///
  /// Parameters:
  /// - `idIntervention`: The ID of the intervention to retrieve.
  ///
  /// Returns a `Future<Map<String, dynamic>?>` representing the result of the API call.
  Future<Map<String, dynamic>?> fetchSingleIntervention(
      String idIntervention) async {
    try {
      String? authToken = PreferenceService.getToken();
      final response = await http.get(
        Uri.parse('${Environment.apiUrl}/interventions/$idIntervention'),
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
