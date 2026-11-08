import 'package:shared/shared.dart';
import 'package:test/test.dart';

Challenge _challenge({
  double current = 0,
  double total = 10,
  bool completed = false,
  DateTime? createdAt,
}) {
  return Challenge(
    id: '1',
    title: 'Read',
    description: 'Read 10 pages',
    category: 'Books',
    progressCurrent: current,
    progressTotal: total,
    completed: completed,
    createdAt: createdAt ?? DateTime.utc(2026, 1, 1),
  );
}

void main() {
  group('Challenge', () {
    test('progressPercentage считается от total', () {
      expect(_challenge(current: 5, total: 10).progressPercentage, 0.5);
    });

    test('progressPercentage равен 0 при нулевом total', () {
      expect(_challenge(current: 5, total: 0).progressPercentage, 0);
    });

    test('isInProgress: начат, но не завершён', () {
      expect(_challenge(current: 3).isInProgress, isTrue);
      expect(_challenge(current: 0).isInProgress, isFalse);
      expect(_challenge(current: 10, completed: true).isInProgress, isFalse);
    });

    test('updateProgress ограничивает значение сверху и завершает челлендж',
        () {
      final updated = _challenge(total: 10).updateProgress(15);

      expect(updated.progressCurrent, 10);
      expect(updated.completed, isTrue);
    });

    test('updateProgress не завершает челлендж при частичном прогрессе', () {
      final updated = _challenge(total: 10).updateProgress(4);

      expect(updated.progressCurrent, 4);
      expect(updated.completed, isFalse);
    });

    test('updateProgress не изменяет исходный объект', () {
      final original = _challenge(total: 10);
      original.updateProgress(7);

      expect(original.progressCurrent, 0);
    });

    test('isOverdue зависит только от переданного времени', () {
      final challenge = _challenge(createdAt: DateTime.utc(2026, 1, 1));

      expect(challenge.isOverdue(DateTime.utc(2026, 1, 1, 12)), isFalse);
      expect(challenge.isOverdue(DateTime.utc(2026, 1, 3)), isTrue);
    });

    test('завершённый челлендж не бывает просроченным', () {
      final challenge = _challenge(
        completed: true,
        createdAt: DateTime.utc(2026, 1, 1),
      );

      expect(challenge.isOverdue(DateTime.utc(2030, 1, 1)), isFalse);
    });
  });

  group('ChallengeMapper', () {
    test('toModel и toEntity взаимно обратимы', () {
      final original = _challenge(current: 3, total: 10);

      final restored = ChallengeMapper.toEntity(
        ChallengeMapper.toModel(original),
      );

      expect(restored.id, original.id);
      expect(restored.title, original.title);
      expect(restored.progressCurrent, original.progressCurrent);
      expect(restored.progressTotal, original.progressTotal);
      expect(restored.completed, original.completed);
      expect(restored.createdAt, original.createdAt);
    });
  });
}
