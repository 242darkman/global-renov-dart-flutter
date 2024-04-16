import 'dart:convert';

import 'package:global_renov/models/intervention_model.dart';
import 'package:http/http.dart' as http;

/// Get an intervention
Future<Intervention> fetchIntervention() async {
  final response = await http.get(Uri.parse('http://localhost:8000'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Intervention.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load intervention');
  }
}

/// Get several interventions
Future<List<Intervention>> fetchInterventions() async {
  final response = await http.get(Uri.parse('http://localhost:8000'));

  if (response.statusCode == 200) {
    List<dynamic> list = jsonDecode(response.body);
    return list.map((item) => Intervention.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load interventions');
  }
}
