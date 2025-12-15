import 'package:shared/domain/models/challenge.dart';
import 'package:shared/domain/repositories/challenge_repository.dart';

class TrackProgressUseCase {
  final ChallengeRepository repository;

  TrackProgressUseCase(this.repository);

  Future<Challenge> execute(String challengeId, double progress) async {
    if (progress < 0) {
      throw ArgumentError('Прогресс не может быть отрицательным');
    }

    final challenge = await repository.getChallengeById(challengeId);
    final updatedChallenge = challenge.updateProgress(progress);

    if (updatedChallenge.completed && !challenge.completed) {
      print('🎉 Челлендж "${challenge.title}" завершен!');
    }

    return await repository.updateChallenge(updatedChallenge);
  }
}
