import 'package:bdui_server/infrastructure/data/repositories/http_template_repository.dart';
import 'package:bdui_server/infrastructure/domain/use_cases/render_template_use_case.dart';
import 'package:bdui_server/server.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

void main() async {
  try {
    // 1. Создаем зависимости вручную
    final challengeRepository = ShelfChallengeRepository();
    final homeScreenGenerator = HomeScreenBDUIGenerator();
    final challengeDetailGenerator = ChallengeDetailBDUIGenerator();

    final generateHomeScreenUseCase = GenerateBDUIHomeScreenUseCase(
      challengeRepository,
      homeScreenGenerator,
    );

    final templateRepository = HttpTemplateRepository();

    final renderTemplateUseCase = RenderTemplateUseCase(
      templateRepository,
    );

    final trackProgressUseCase = TrackProgressUseCase(challengeRepository);

    final challengeController = ChallengeController(
      challengeRepository,
      trackProgressUseCase,
    );
    final bduiController = BDUIController(
      challengeRepository: challengeRepository,
      generateHomeScreenUseCase: generateHomeScreenUseCase,
      challengeDetailGenerator: challengeDetailGenerator,
      renderTemplateUseCase: renderTemplateUseCase,
    );

    // 2. Создаем роутер
    final appRouter = AppRouter(challengeController, bduiController);

    // 3. Добавляем middleware
    final handler = Pipeline()
        .addMiddleware(_corsHeaders)
        .addMiddleware(_logRequests)
        .addHandler(appRouter.router);

    // 4. Запускаем сервер
    final _ = await io.serve(handler, 'localhost', 8080);

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
Middleware get _corsHeaders {
  return (Handler handler) {
    return (Request request) async {
      final response = await handler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Origin, Content-Type',
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
