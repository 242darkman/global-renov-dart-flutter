import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:global_renov_api/src/modules/intervention/intervention_service.dart';
import 'package:global_renov_api/src/modules/intervention/intervention_model.dart';

Router interventionController() {
  final router = Router();
  final interventionService = InterventionService();

  // Create a new intervention
  router.post('/create', (Request request) async {
    try {
      String content = await request.readAsString();
      Map<String, dynamic> data = jsonDecode(content);
      var intervention = Intervention.fromJson(data);
      var createdIntervention =
          await interventionService.createIntervention(intervention);

      return Response.ok(jsonEncode({
        'interventions': [createdIntervention.toJson()],
        'metadata': {}
      }));
    } catch (e) {
      print('interventionController: Error creating intervention: $e');
      return Response.internalServerError(
          body: 'interventionController: Error creating intervention: $e');
    }
  });

  return router;
}
