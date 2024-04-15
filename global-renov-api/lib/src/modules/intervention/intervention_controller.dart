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

  // update an existing intervention
  router.put('/update/<id>', (Request request, String id) async {
    try {
      String content = await request.readAsString();
      Map<String, dynamic> updates = jsonDecode(content);
      var updatedIntervention =
          await interventionService.updateIntervention(id, updates);

      return Response.ok(jsonEncode({
        'interventions': [updatedIntervention.toJson()],
        'metadata': {}
      }));
    } catch (e) {
      return Response.internalServerError(
          body: 'interventionController: Error updating intervention: $e');
    }
  });

  // Change the status of an existing intervention
  router.patch('/change-status/<id>', (Request request, String id) async {
    try {
      String content = await request.readAsString();
      String newStatus = jsonDecode(content)['status'];
      List<String> statuses = ['scheduled', 'closed', 'canceled'];

      if (!statuses.contains(newStatus)) {
        return Response.internalServerError(
            body:
                'interventionController: Error changing intervention status: Invalid status');
      }

      var updatedIntervention =
          await interventionService.changeStatus(id, newStatus);
      return Response.ok(jsonEncode({
        'interventions': [updatedIntervention.toJson()],
        'metadata': {}
      }));
    } catch (e) {
      return Response.internalServerError(
          body:
              'interventionController: Error changing intervention status: $e');
    }
  });
  return router;
}
