import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import '../presentation/controllers/template_controller.dart';

class AppRouter {
  final TemplateController templateController;

  AppRouter(this.templateController);

  Router get router {
    final router = Router();

    // 📄 Получить чистый шаблон
    router.get('/templates/<name>', templateController.getTemplate);

    // 🎯 Отрендерить шаблон с данными
    router.post('/templates/<name>/render', templateController.renderTemplate);

    // Health check
    router.get('/', (Request request) {
      return Response.ok(
        'Template Server is Running!',
      );
    });

    // Options для CORS
    router.options('/templates/<name>', (Request request, String name) {
      return Response.ok('');
    });

    router.options('/templates/<name>/render', (Request request, String name) {
      return Response.ok('');
    });

    return router;
  }
}
