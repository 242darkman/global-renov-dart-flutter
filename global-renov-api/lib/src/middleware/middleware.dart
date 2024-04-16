import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shelf/shelf.dart';

bool isTokenExpired(String token) {
  try {
    final isTokenExpired = JwtDecoder.isExpired(token);

    return isTokenExpired;
  } catch (e) {
    print('Error verifying token: $e');
    return true;
  }
}

Middleware authMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final authHeader = request.headers['Authorization'] ?? '';

      if (authHeader.isEmpty) {
        return Response.unauthorized(jsonEncode({
          'error': '401 Unauthorized',
          'code_status': 401,
          'message': 'Token header missing'
        }));
      }

      final String authToken = authHeader.split(' ').last;

      if (authToken == 'Bearer' ||
          authToken == 'undefined' ||
          authToken.isEmpty) {
        return Response.unauthorized(jsonEncode({
          'error': '401 Unauthorized',
          'code_status': 401,
          'message': 'Token header missing'
        }));
      }

      final bool isCurrentTokenExpired = isTokenExpired(authToken);

      if (isCurrentTokenExpired) {
        return Response.unauthorized(jsonEncode({
          'error': '401 Unauthorized',
          'code_status': 401,
          'message': 'Invalid token'
        }));
      }

      return await innerHandler(request);
    };
  };
}
