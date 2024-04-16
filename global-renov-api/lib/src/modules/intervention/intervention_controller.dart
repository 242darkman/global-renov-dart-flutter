import 'dart:convert';
import 'package:global_renov_api/src/utils/exception/invalid_status_exception.dart';
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
      if (e is InvalidStatusException) {
        return Response.badRequest(body: e.toString());
      }

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

  // delete an intervention
  router.delete('/delete/<id>', (Request request, String id) async {
    try {
      await interventionService.deleteIntervention(id);
      return Response.ok(
          jsonEncode({'message': 'Intervention $id deleted successfully'}));
    } catch (e) {
      return Response.internalServerError(
          body: 'interventionController: Error deleting intervention: $e');
    }
  });

  // get an intervention by ID
  router.get('/<id>', (Request request, String id) async {
    try {
      Intervention intervention =
          await interventionService.getInterventionById(id);

      return Response.ok(jsonEncode({
        'interventions': [intervention.toJson()],
        'metadata': {}
      }));
    } catch (e) {
      return Response.internalServerError(
          body: 'interventionController: Error fetching intervention: $e');
    }
  });

  // get all interventions
  router.get('/', (Request request) async {
    try {
      var interventions = await interventionService.getAllInterventions();
      return Response.ok(jsonEncode({
        'interventions': interventions.map((i) => i.toJson()).toList(),
        'metadata': {
          'total': interventions.map((i) => i.toJson()).toList().length
        }
      }));
    } catch (e) {
      return Response.internalServerError(
          body: 'interventionController: Error fetching interventions: $e');
    }
  });

  return router;
}
