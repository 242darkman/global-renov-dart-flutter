import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:global_renov_api/src/modules/auth/auth_service.dart';

Router authController() {
  final router = Router();
  final authService = AuthService();

  router.post('/sign-up', (request) async {
    try {
      // Read and decode the request body to get a map
      String content = await request.readAsString();
      Map<String, dynamic> data = jsonDecode(content);

      // Get email and password from the map
      String email = data['email'];
      String password = data['password'];
      String firstName = data['firstName'];
      String lastName = data['lastName'];

      // Call your service layer to create a new user
      var result = await authService.createUserWithEmailAndPassword(
          email, password, firstName, lastName);

      final userResponse = {
        "id": result.user!.uid,
        "email": result.user!.email,
        "emailVerified": result.user!.emailVerified,
        "displayName": result.user!.displayName,
      };

      // Return the result
      return Response.ok(jsonEncode({
        "users": [userResponse],
        "metadata": {
          "creationTime": result.user!.metadata.creationTime.toString(),
          "lastSignInTime": result.user!.metadata.lastSignInTime.toString()
        }
      }));
    } catch (e) {
      // Handle the exception, e.g., log it or return an error response
      print('Error creating user: $e');
      return Response.internalServerError(body: 'Error creating user');
    }
  });
  return router;
}
