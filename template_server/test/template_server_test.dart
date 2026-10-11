import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:template_server/server/router.dart';
import 'package:template_server/presentation/controllers/template_controller.dart';
import 'package:template_server/domain/use_cases/get_template_use_case.dart';
import 'package:template_server/domain/use_cases/render_template_use_case.dart';
import 'package:template_server/infrastructure/repositories/file_template_repository.dart';

void main() {
  group('AppRouter', () {
    final repository = FileTemplateRepository();
    final getTemplateUseCase = GetTemplateUseCase(repository);
    final renderTemplateUseCase = RenderTemplateUseCase(repository);
    final controller = TemplateController(
      getTemplateUseCase: getTemplateUseCase,
      renderTemplateUseCase: renderTemplateUseCase,
    );
    final router = AppRouter(controller).router;

    test('health check возвращает 200 и правильный текст', () async {
      final request = Request('GET', Uri.parse('http://localhost:8082/'));
      final response = await router.call(request);

      expect(response.statusCode, equals(200));
      final body = await response.readAsString();
      expect(body, contains('Template Server'));
    });

    test('неизвестный маршрут возвращает 404', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost:8082/unknown/path'),
      );
      final response = await router.call(request);

      expect(response.statusCode, equals(404));
    });

    test('GET /templates/<name> зарегистрирован', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost:8082/templates/test'),
      );
      final response = await router.call(request);

      expect(response.statusCode, isNot(equals(404)));
    });

    test('POST /templates/<name>/render зарегистрирован', () async {
      final request = Request(
        'POST',
        Uri.parse('http://localhost:8082/templates/test/render'),
      );
      final response = await router.call(request);

      expect(response.statusCode, isNot(equals(404)));
    });
  });
}