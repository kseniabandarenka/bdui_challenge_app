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

    // Health check
    router.get('/', (Request request) {
      return Response.ok('🚀 BDUI Server with Clean Architecture is Running!');
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
