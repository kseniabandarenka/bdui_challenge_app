import 'dart:convert';

import 'package:bdui_server/server.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import 'fakes.dart';

Future<Response> _send(
  Handler handler,
  String method,
  String path, {
  Object? body,
}) {
  return Future.sync(() => handler(Request(
        method,
        Uri.parse('http://localhost:8080$path'),
        body: body == null ? null : jsonEncode(body),
      )));
}

Future<dynamic> _json(Response response) async =>
    jsonDecode(await response.readAsString());

void main() {
  late InMemoryChallengeRepository challenges;
  late FakeTemplateRepository templates;
  late Handler handler;

  setUp(() {
    challenges = InMemoryChallengeRepository([
      makeChallenge(id: '1', current: 5, total: 10),
      makeChallenge(id: '2', current: 10, total: 10, completed: true),
      makeChallenge(id: '3', current: 0, total: 4),
    ]);
    templates = FakeTemplateRepository();
    handler = buildRouter(challenges, templates).router.call;
  });

  group('health check', () {
    test('GET / возвращает 200 и текст сервера', () async {
      final response = await _send(handler, 'GET', '/');

      expect(response.statusCode, 200);
      expect(await response.readAsString(), contains('BDUI Server'));
    });

    test('неизвестный маршрут возвращает 404', () async {
      final response = await _send(handler, 'GET', '/unknown/path');

      expect(response.statusCode, 404);
    });
  });

  group('GET /api/challenges', () {
    test('возвращает корректный JSON со всеми челленджами', () async {
      final response = await _send(handler, 'GET', '/api/challenges');

      expect(response.statusCode, 200);
      final body = await _json(response) as List;
      expect(body.map((c) => c['id']), ['1', '2', '3']);
      expect(body.first['progressCurrent'], 5);
    });
  });

  group('POST /api/challenges/<id>/progress', () {
    test('обновляет прогресс и возвращает челлендж', () async {
      final response = await _send(
        handler,
        'POST',
        '/api/challenges/3/progress',
        body: {'progress': 4},
      );

      expect(response.statusCode, 200);
      final body = await _json(response);
      expect(body['success'], isTrue);
      expect(body['data']['completed'], isTrue);
      expect((await challenges.getChallengeById('3')).completed, isTrue);
    });

    test('неизвестный id возвращает 404', () async {
      final response = await _send(
        handler,
        'POST',
        '/api/challenges/999/progress',
        body: {'progress': 1},
      );

      expect(response.statusCode, 404);
    });

    test('отрицательный прогресс возвращает 400', () async {
      final response = await _send(
        handler,
        'POST',
        '/api/challenges/1/progress',
        body: {'progress': -1},
      );

      expect(response.statusCode, 400);
    });

    test('тело без поля progress возвращает 400', () async {
      final response = await _send(
        handler,
        'POST',
        '/api/challenges/1/progress',
        body: {'value': 1},
      );

      expect(response.statusCode, 400);
    });
  });

  group('GET /api/bdui/challenges', () {
    test('передаёт в шаблон статистику, посчитанную в use case', () async {
      final response = await _send(handler, 'GET', '/api/bdui/challenges');

      expect(response.statusCode, 200);
      expect(await _json(response), {'screen_type': 'fake'});
      expect(templates.lastTemplateName, 'home_screen');
      expect(templates.lastData!['completedChallenges'], 1);
      expect(templates.lastData!['inProgressChallenges'], 1);
      expect(templates.lastData!['averageProgress'], '50.0');
      expect(templates.lastData!['challenges'], hasLength(3));
    });

    test('недоступный template server даёт 502, а не 404', () async {
      handler = buildRouter(
        challenges,
        FakeTemplateRepository.failing(TemplateUnavailableException('down')),
      ).router.call;

      final response = await _send(handler, 'GET', '/api/bdui/challenges');

      expect(response.statusCode, 502);
    });
  });

  group('GET /api/bdui/challenges/<id>', () {
    test('рендерит шаблон детали с данными челленджа', () async {
      final response = await _send(handler, 'GET', '/api/bdui/challenges/1');

      expect(response.statusCode, 200);
      expect(templates.lastTemplateName, 'challenge_detail');
      expect(templates.lastData!['id'], '1');
      expect(templates.lastData!['progressPercentage'], '50.0');
    });

    test('неизвестный id возвращает 404', () async {
      final response = await _send(handler, 'GET', '/api/bdui/challenges/999');

      expect(response.statusCode, 404);
    });

    test('недоступный template server даёт 502, а не 404', () async {
      handler = buildRouter(
        challenges,
        FakeTemplateRepository.failing(TemplateUnavailableException('down')),
      ).router.call;

      final response = await _send(handler, 'GET', '/api/bdui/challenges/1');

      expect(response.statusCode, 502);
    });
  });
}
