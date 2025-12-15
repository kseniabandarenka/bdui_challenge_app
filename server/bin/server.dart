import 'dart:io';
import 'package:bdui_server/server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  try {
    // 1. Настраиваем зависимости
    setupDependencies();

    // 2. Получаем роутер из DI контейнера
    final appRouter = getIt.get<AppRouter>();

    // 3. Добавляем middleware
    final handler = Pipeline()
        .addMiddleware(_corsMiddleware)
        .addMiddleware(_logRequests)
        .addHandler(appRouter.router);

    // 4. Запускаем сервер
    final _ = await io.serve(handler, InternetAddress.anyIPv4, 8080);

    print('🚀 BDUI Server running on http://localhost:8080');
    print('📋 Available endpoints:');
    print('   GET  /                         - Health check');
    print('   GET  /api/challenges           - Regular API');
    print('   GET  /api/bdui/challenges      - BDUI Home Screen');
    print('   GET  /api/bdui/challenges/<id> - BDUI Challenge Detail');
    print('   POST /api/challenges/<id>/progress - Track progress');
  } catch (e, s) {
    print('❌ Failed to start server: $e');
    print(s);
  }
}

// CORS middleware
Middleware get _corsMiddleware {
  return (Handler innerHandler) {
    return (Request request) async {
      // Обрабатываем OPTIONS
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
          'Access-Control-Max-Age': '86400',
        });
      }

      final response = await innerHandler(request);
      return response.change(headers: {
        ...response.headers,
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept',
      });
    };
  };
}

// Logging middleware
Middleware get _logRequests {
  return (Handler handler) {
    return (Request request) async {
      final startTime = DateTime.now();
      final response = await handler(request);
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);

      print(
          '${request.method} ${request.requestedUri} - ${response.statusCode} (${duration.inMilliseconds}ms)');
      return response;
    };
  };
}
