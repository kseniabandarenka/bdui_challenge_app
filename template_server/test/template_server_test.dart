import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:template_server/domain/entities/template.dart';
import 'package:template_server/domain/repositories/template_repository.dart';
import 'package:template_server/domain/use_cases/get_template_use_case.dart';
import 'package:template_server/domain/use_cases/render_template_use_case.dart';
import 'package:template_server/infrastructure/repositories/file_template_repository.dart';
import 'package:template_server/presentation/controllers/template_controller.dart';
import 'package:template_server/server/router.dart';
import 'package:test/test.dart';

class _InMemoryTemplateRepository implements TemplateRepository {
  final Map<String, Map<String, dynamic>> templates;

  _InMemoryTemplateRepository(this.templates);

  @override
  Future<Template> getTemplate(String name) async {
    final content = templates[name];
    if (content == null) throw Exception('Template not found: $name');
    return Template(
      name: name,
      content: content,
      lastModified: DateTime.utc(2026, 1, 1),
    );
  }

  @override
  Future<RenderedTemplate> renderTemplate(
    String name,
    Map<String, dynamic> data,
  ) async {
    final template = await getTemplate(name);
    return RenderedTemplate(name: name, content: template.content, data: data);
  }
}

Handler _buildHandler(TemplateRepository repository) {
  return AppRouter(TemplateController(
    getTemplateUseCase: GetTemplateUseCase(repository),
    renderTemplateUseCase: RenderTemplateUseCase(repository),
  )).router.call;
}

Future<Response> _send(Handler handler, String method, String path,
    {Object? body}) {
  return Future.sync(() => handler(Request(
        method,
        Uri.parse('http://localhost:8082$path'),
        body: body == null ? null : jsonEncode(body),
      )));
}

void main() {
  group('AppRouter', () {
    late Handler handler;

    setUp(() {
      handler = _buildHandler(_InMemoryTemplateRepository({
        'demo': {'title': 'Demo'},
      }));
    });

    test('health check возвращает 200 и правильный текст', () async {
      final response = await _send(handler, 'GET', '/');

      expect(response.statusCode, 200);
      expect(await response.readAsString(), contains('Template Server'));
    });

    test('неизвестный маршрут возвращает 404', () async {
      final response = await _send(handler, 'GET', '/unknown/path');

      expect(response.statusCode, 404);
    });

    test('GET /templates/<name> возвращает содержимое шаблона', () async {
      final response = await _send(handler, 'GET', '/templates/demo');

      expect(response.statusCode, 200);
      expect(jsonDecode(await response.readAsString()), {'title': 'Demo'});
    });

    test('GET /templates/<name> для неизвестного шаблона возвращает 404',
        () async {
      final response = await _send(handler, 'GET', '/templates/missing');

      expect(response.statusCode, 404);
    });

    test('POST /templates/<name>/render возвращает отрендеренный шаблон',
        () async {
      final response = await _send(
        handler,
        'POST',
        '/templates/demo/render',
        body: {'any': 'data'},
      );

      expect(response.statusCode, 200);
      expect(jsonDecode(await response.readAsString()), {'title': 'Demo'});
    });
  });

  group('FileTemplateRepository (рендеринг)', () {
    final repository = FileTemplateRepository();

    test('подставляет строки, числа и списки в реальный шаблон', () async {
      final rendered = await repository.renderTemplate('home_screen', {
        'completedChallenges': 2,
        'inProgressChallenges': 1,
        'challenges': [
          {'id': '1'},
        ],
      });

      final json = jsonEncode(rendered.content);
      expect(json, contains('Завершено: 2'));
      expect(json, contains('В процессе: 1'));
      expect(json, isNot(contains('{{')));
      final list = (rendered.content['layout']['children'] as List).last;
      expect(list['challenges'], [
        {'id': '1'}
      ]);
    });
  });
}
