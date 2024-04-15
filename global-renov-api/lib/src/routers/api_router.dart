import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:global_renov_api/src/modules/auth/auth_controller.dart';

Router buildRouter() {
  final router = Router();

  // Attach auth-related routes
  router.mount('/auth/', authController().call);
  return router;
}
