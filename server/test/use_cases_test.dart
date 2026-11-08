import 'package:bdui_server/server.dart';
import 'package:shared/shared.dart';
import 'package:test/test.dart';

import 'fakes.dart';

void main() {
  group('GetHomeScreenSummaryUseCase', () {
    test('считает статистику по челленджам', () async {
      final repository = InMemoryChallengeRepository([
        makeChallenge(id: '1', current: 5, total: 10),
        makeChallenge(id: '2', current: 10, total: 10, completed: true),
        makeChallenge(id: '3', current: 0, total: 10),
      ]);

      final summary = await GetHomeScreenSummaryUseCase(repository).execute();

      expect(summary.completedCount, 1);
      expect(summary.inProgressCount, 1);
      expect(summary.averageProgressPercent, closeTo(50, 0.001));
      expect(summary.challenges, hasLength(3));
    });

    test('без челленджей средний прогресс равен нулю', () async {
      final summary = await GetHomeScreenSummaryUseCase(
        InMemoryChallengeRepository([]),
      ).execute();

      expect(summary.averageProgressPercent, 0);
      expect(summary.completedCount, 0);
    });
  });

  group('TrackProgressUseCase', () {
    late InMemoryChallengeRepository repository;
    late TrackProgressUseCase useCase;

    setUp(() {
      repository = InMemoryChallengeRepository([
        makeChallenge(id: '1', current: 0, total: 10),
      ]);
      useCase = TrackProgressUseCase(repository);
    });

    test('сохраняет новый прогресс', () async {
      final updated = await useCase.execute('1', 4);

      expect(updated.progressCurrent, 4);
      expect((await repository.getChallengeById('1')).progressCurrent, 4);
    });

    test('завершает челлендж при достижении цели', () async {
      final updated = await useCase.execute('1', 10);

      expect(updated.completed, isTrue);
    });

    test('прогресс выше цели ограничивается значением total', () async {
      final updated = await useCase.execute('1', 99);

      expect(updated.progressCurrent, 10);
    });

    test('отрицательный прогресс отклоняется', () {
      expect(() => useCase.execute('1', -1), throwsArgumentError);
    });

    test('NaN отклоняется', () {
      expect(() => useCase.execute('1', double.nan), throwsArgumentError);
    });

    test('неизвестный id бросает ChallengeNotFoundException', () {
      expect(
        () => useCase.execute('404', 1),
        throwsA(isA<ChallengeNotFoundException>()),
      );
    });
  });

  group('ChallengeCardPresenter', () {
    test('переносит поля сущности и добавляет действие навигации', () {
      final card = const ChallengeCardPresenter()
          .present(makeChallenge(id: '7', current: 5, total: 10));

      expect(card.id, '7');
      expect(card.progressPercentage, 0.5);
      expect(card.isInProgress, isTrue);
      expect(card.action.challengeId, '7');
    });
  });
}
