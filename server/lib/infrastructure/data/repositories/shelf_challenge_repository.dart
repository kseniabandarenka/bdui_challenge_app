import 'package:shared/shared.dart';

class ShelfChallengeRepository implements ChallengeRepository {
  final List<ChallengeModel> _challenges = [
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

  @override
  Future<List<Challenge>> getChallenges() async {
    return _challenges.map(ChallengeMapper.toEntity).toList();
  }

  @override
  Future<Challenge> getChallengeById(String id) async {
    final model = _challenges.firstWhere(
      (challenge) => challenge.id == id,
      orElse: () => throw Exception('Challenge not found: $id'),
    );
    return ChallengeMapper.toEntity(model);
  }

  @override
  Future<Challenge> updateChallenge(Challenge challenge) async {
    final index = _challenges.indexWhere((model) => model.id == challenge.id);
    if (index == -1) {
      throw Exception('Challenge not found: ${challenge.id}');
    }

    final updatedModel = ChallengeMapper.toModel(challenge);
    _challenges[index] = updatedModel;

    return challenge;
  }

  @override
  Future<void> trackProgress(String challengeId, int progress) async {
    final challenge = await getChallengeById(challengeId);
    final updatedChallenge = challenge.updateProgress(progress.toDouble());
    await updateChallenge(updatedChallenge);
  }
}
