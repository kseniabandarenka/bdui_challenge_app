import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:template_server/template_server.dart';

void main() async {
  try {
    // 💡 Инициализация DI контейнера
    final diContainer = DependencyContainer();

    // Middleware pipeline
    final handler = shelf.Pipeline()
        .addMiddleware(corsHeaders)
        .addMiddleware(logRequests)
        .addHandler(diContainer.appRouter.router);

    // Запуск сервера
    final server = await io.serve(handler, 'localhost', 8082);

    print('🚀 Template Server with DI running on http://localhost:8082');
    print('📋 Endpoints:');
    print('   GET  /templates/<name>              - Get raw template');
    print('   POST /templates/<name>/render       - Render template with data');
    print('   GET  /                             - Health check');
  } catch (e, s) {
    print('❌ Failed to start server: $e');
    print(s);
  }
}
