import 'package:shared/data/models/challenge_model.dart';
import 'package:test/test.dart';

void main() {
  group('ChallengeModel', () {
    final sampleJson = {
      'id': '1',
      'title': 'Daily running',
      'description': 'Run 5km',
      'category': 'sport',
      'progressCurrent': 2.5,
      'progressTotal': 5.0,
      'completed': false,
      'createdAt': '2026-10-11T10:00:00.000Z',
    };

    test('fromJson создаёт модель с правильными полями', () {
      final model = ChallengeModel.fromJson(sampleJson);

      expect(model.id, equals('1'));
      expect(model.title, equals('Daily running'));
      expect(model.description, equals('Run 5km'));
      expect(model.category, equals('sport'));
      expect(model.progressCurrent, equals(2.5));
      expect(model.progressTotal, equals(5.0));
      expect(model.completed, isFalse);
      expect(model.createdAt, isA<DateTime>());
    });

    test('toJson возвращает правильную map', () {
      final model = ChallengeModel(
        id: '1',
        title: 'Daily running',
        description: 'Run 5km',
        category: 'sport',
        progressCurrent: 2.5,
        progressTotal: 5.0,
        completed: false,
        createdAt: DateTime.parse('2026-10-11T10:00:00.000Z'),
      );

      final json = model.toJson();

      expect(json['id'], equals('1'));
      expect(json['title'], equals('Daily running'));
      expect(json['progressCurrent'], equals(2.5));
      expect(json['completed'], isFalse);
    });

    test('fromJson(toJson(model)) возвращает эквивалентную модель', () {
      final original = ChallengeModel(
        id: '1',
        title: 'Daily running',
        description: 'Run 5km',
        category: 'sport',
        progressCurrent: 2.5,
        progressTotal: 5.0,
        completed: false,
        createdAt: DateTime.parse('2026-10-11T10:00:00.000Z'),
      );

      final restored = ChallengeModel.fromJson(original.toJson());

      expect(restored.id, equals(original.id));
      expect(restored.title, equals(original.title));
      expect(restored.progressCurrent, equals(original.progressCurrent));
      expect(restored.completed, equals(original.completed));
      expect(restored.createdAt, equals(original.createdAt));
    });
  });
}