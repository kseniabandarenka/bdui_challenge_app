import 'package:shared/shared.dart';

class TrackProgressUseCase {
  final ChallengeRepository repository;

  TrackProgressUseCase(this.repository);

  /// Бросает [ArgumentError] при некорректном прогрессе и
  /// [ChallengeNotFoundException], если челленджа нет.
  Future<Challenge> execute(String challengeId, double progress) async {
    if (progress.isNaN || progress < 0) {
      throw ArgumentError('Прогресс должен быть неотрицательным числом');
    }

    final challenge = await repository.getChallengeById(challengeId);
    return repository.updateChallenge(challenge.updateProgress(progress));
  }
}
