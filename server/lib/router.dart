import 'package:bdui_server/presentation/controllers/bdui_controller.dart';
import 'package:bdui_server/presentation/controllers/challenge_controller.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

class AppRouter {
  final ChallengeController challengeController;
  final BDUIController bduiController;

  AppRouter(this.challengeController, this.bduiController);

  Router get router {
    final router = Router();

    // Редирект с 443 порта (если кто-то пытается по HTTPS)
    router.all('/<.*>', (Request request) {
      if (request.requestedUri.scheme == 'https' ||
          request.requestedUri.port == 443) {
        final newUrl = request.requestedUri.replace(
          scheme: 'http',
          port: 8080,
        );
        return Response.movedPermanently(newUrl.toString());
      }
      return Response.notFound('Not found');
    });

    // Health check
    router.get('/', (Request request) {
      return Response.ok('BDUI Server with Clean Architecture is Running!');
    });

    // Regular API
    router.get('/api/challenges', challengeController.getChallenges);
    router.post(
        '/api/challenges/<id>/progress', challengeController.trackProgress);

    // BDUI API
    router.get('/api/bdui/challenges', bduiController.getHomeScreen);
    router.get('/api/bdui/challenges/<id>', bduiController.getChallengeDetail);

    return router;
  }
}
