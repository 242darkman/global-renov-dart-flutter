import 'package:firebase_dart/database.dart';
import 'package:global_renov_api/src/config/firebase_service.dart';
import 'package:global_renov_api/src/modules/intervention/intervention_model.dart';

class InterventionService {
  final FirebaseService _firebaseService = FirebaseService();

  /// Create a new intervention
  Future<Intervention> createIntervention(Intervention intervention) async {
    var ref =
        _firebaseService.database.reference().child('interventions').push();
    await ref.set(intervention.toJson());
    return intervention.copyWith(id: ref.key);
  }

  /// Update an existing intervention
  Future<Intervention> updateIntervention(
      String id, Map<String, dynamic> updates) async {
    var ref =
        _firebaseService.database.reference().child('interventions').child(id);
    await ref.update(updates);
    var updatedSnapshot = await ref.get();
    updatedSnapshot.addEntries(<String, dynamic>{'id': id}.entries);

    Intervention updatedIntervention =
        Intervention.fromJson(updatedSnapshot as Map<String, dynamic>);

    return updatedIntervention;
  }

  Future<void> deleteIntervention(String key) async {
    return await _firebaseService.database
        .reference()
        .child('interventions')
        .child(key)
        .remove();
  }

  /// Change the status of an existing intervention
  Future<Intervention> changeStatus(String id, String newStatus) async {
    var ref =
        _firebaseService.database.reference().child('interventions').child(id);
    await ref.update({'status': newStatus});
    var snapshot = await ref.get();
    snapshot.addEntries(<String, dynamic>{'id': id}.entries);

    Intervention interventionWithNewStatus =
        Intervention.fromJson(snapshot as Map<String, dynamic>);

    return interventionWithNewStatus;
  }

  /// Get an intervention from firebase database
  Future<Intervention> getInterventionById(String id) async {
    var snapshot = await _firebaseService.database
        .reference()
        .child('interventions')
        .child(id)
        .get();

    if (snapshot.isNotEmpty) {
      snapshot.addEntries(<String, dynamic>{'id': id}.entries);
      return Intervention.fromJson(snapshot as Map<String, dynamic>);
    } else {
      throw Exception('InterventionService: Intervention not found');
    }
  }
}
