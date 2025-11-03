import 'package:shared/shared.dart';

class ShelfChallengeRepository implements ChallengeRepository {

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