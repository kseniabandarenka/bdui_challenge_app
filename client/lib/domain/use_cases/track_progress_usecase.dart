import 'package:client/domain/gateway/challenges_gateway.dart';

/// UseCase для обновления прогресса челленджа
class TrackProgressUseCase {
  final ChallengesGateway gateway;

  TrackProgressUseCase(this.gateway);

  Future<void> call({
    required double progress,
    required String id,
  }) =>
      gateway.trackProgress(progress: progress, id: id);
}
