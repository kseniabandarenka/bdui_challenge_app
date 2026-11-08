import 'dart:convert';
import 'dart:io';
import 'package:shared/shared.dart';

class JsonFileChallengeRepository implements ChallengeRepository {
  final String _dataPath;

  JsonFileChallengeRepository({String? dataPath})
      : _dataPath = dataPath ?? 'lib/data/json/challenges.json';

  Future<List<ChallengeModel>> _loadChallengesFromFile() async {
    try {
      final file = File(_dataPath);
      if (!await file.exists()) {
        // Создаем файл с начальными данными, если не существует
        await _createDefaultChallengesFile();
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);

      return jsonList.map((json) => ChallengeModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load challenges: $e');
    }
  }

  Future<void> _saveChallengesToFile(List<ChallengeModel> challenges) async {
    try {
      final file = File(_dataPath);
      final directory = file.parent;
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      final jsonList = challenges.map((model) => model.toJson()).toList();
      final jsonString = json.encode(jsonList, toEncodable: (object) {
        if (object is DateTime) {
          return object.toIso8601String();
        }
        return object;
      });

      await file.writeAsString(jsonString);
    } catch (e) {
      throw Exception('Failed to save challenges: $e');
    }
  }

  Future<void> _createDefaultChallengesFile() async {
    final defaultChallenges = [
      ChallengeModel(
        id: '1',
        title: 'Пробежать 2 км',
        description: 'Ежедневная пробежка для поддержания формы',
        category: '🏃 Фитнес',
        progressCurrent: 0,
        progressTotal: 2,
        completed: false,
        createdAt: DateTime.now(),
      ),
      ChallengeModel(
        id: '2',
        title: 'Прочитать 10 страниц',
        description: 'Развивайте привычку читать каждый день',
        category: '📚 Книги',
        progressCurrent: 3,
        progressTotal: 10,
        completed: false,
        createdAt: DateTime.now(),
      ),
      ChallengeModel(
        id: '3',
        title: 'Выпить 2 литра воды',
        description: 'Поддерживайте водный баланс',
        category: '💧 Здоровье',
        progressCurrent: 1,
        progressTotal: 2,
        completed: false,
        createdAt: DateTime.now(),
      ),
    ];

    await _saveChallengesToFile(defaultChallenges);
  }

  @override
  Future<List<Challenge>> getChallenges() async {
    final challenges = await _loadChallengesFromFile();
    return challenges.map(ChallengeMapper.toEntity).toList();
  }

  @override
  Future<Challenge> getChallengeById(String id) async {
    final challenges = await _loadChallengesFromFile();
    final model = challenges.firstWhere(
      (challenge) => challenge.id == id,
      orElse: () => throw ChallengeNotFoundException(id),
    );
    return ChallengeMapper.toEntity(model);
  }

  @override
  Future<Challenge> updateChallenge(Challenge challenge) async {
    final challenges = await _loadChallengesFromFile();
    final index = challenges.indexWhere((model) => model.id == challenge.id);

    if (index == -1) {
      throw ChallengeNotFoundException(challenge.id);
    }

    challenges[index] = ChallengeMapper.toModel(challenge);
    await _saveChallengesToFile(challenges);

    return challenge;
  }
}
