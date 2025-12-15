import 'package:shelf/shelf.dart';

Middleware get corsHeaders {
  return (Handler handler) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok(
          '',
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, Authorization',
          },
        );
      }

      final response = await handler(request);
      return response.change(
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Authorization',
        },
      );
    };
  };
}

Middleware get logRequests {
  return (Handler handler) {
    return (Request request) async {
      final startTime = DateTime.now();
      final response = await handler(request);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      print(
        '${request.method} ${request.requestedUri} - ${response.statusCode} (${duration.inMilliseconds}ms)',
      );
      return response;
    };
  };
}
