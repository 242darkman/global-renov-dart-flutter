import 'package:shelf_router/shelf_router.dart';
import 'package:global_renov_api/src/modules/auth/auth_controller.dart';
import 'package:global_renov_api/src/modules/intervention/intervention_controller.dart';

Router buildRouter() {
  final router = Router();

  // Attach auth-related routes
  router.mount('/auth/', authController().call);
  // Attach intervention-related routes
  router.mount('/interventions', interventionController().call);

  return router;
}
