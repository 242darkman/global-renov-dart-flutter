import 'package:global_renov_api/src/utils/logger/logger.dart';
import 'package:shelf/shelf.dart';

/// Customized middleware for query logging
Middleware customLogMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final startTime = DateTime.now();
      Response response;

      try {
        response = await handler(request);
      } catch (e) {
        log.severe('Exception during request: $e');
        rethrow;
      }

      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      // Format and log request and response information
      final info = '${request.method} ${request.requestedUri} '
          '${response.statusCode} ${duration.inMilliseconds}ms';
      log.info(info, "Request from ${request.context['client']}");

      return response;
    };
  };
}
