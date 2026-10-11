import 'package:test/test.dart';
import 'package:shelf/shelf.dart';
import 'package:bdui_server/server.dart';

void main() {
  group('AppRouter', () {
    late AppRouter appRouter;

    setUpAll(() {
      setupDependencies();
      appRouter = getIt.get<AppRouter>();
    });

    test('health check возвращает 200 и правильный текст', () async {
      final request = Request('GET', Uri.parse('http://localhost:8080/'));
      final response = await appRouter.router.call(request);

      expect(response.statusCode, equals(200));
      final body = await response.readAsString();
      expect(body, contains('BDUI Server'));
    });

    test('неизвестный маршрут возвращает 404', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost:8080/unknown/path'),
      );
      final response = await appRouter.router.call(request);

      expect(response.statusCode, equals(404));
    });

    test('GET /api/challenges существует', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost:8080/api/challenges'),
      );
      final response = await appRouter.router.call(request);

      expect(response.statusCode, isNot(equals(404)));
    });

    test('GET /api/bdui/challenges существует', () async {
      final request = Request(
        'GET',
        Uri.parse('http://localhost:8080/api/bdui/challenges'),
      );
      final response = await appRouter.router.call(request);

      expect(response.statusCode, isNot(equals(404)));
    });
  });
}