import 'dart:io';

import 'package:firebase_dart/firebase_dart.dart';
import 'package:global_renov_api/src/routers/api_router.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

void main(List<String> args) async {
  FirebaseDart.setup();

  final overrideHeaders = {
    ACCESS_CONTROL_ALLOW_HEADERS: '*',
    'Content-Type': 'application/json;charset=utf-8',
  };

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders(headers: overrideHeaders))
      .addHandler(buildRouter().call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
