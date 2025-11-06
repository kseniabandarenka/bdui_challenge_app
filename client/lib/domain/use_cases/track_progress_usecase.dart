import 'package:client/domain/gateway/challenges_gateway.dart';
import 'package:shared/shared.dart';

/// UseCase для обновления прогресса челленджа
class TrackProgressUseCase {
  final ChallengesGateway gateway;

  TrackProgressUseCase(this.gateway);

  Future<void> execute({
    required double progress,
    required String id,
  }) =>
      gateway.trackProgress(
          progress: ProgressRequestModel(progress: progress), id: id);
}
