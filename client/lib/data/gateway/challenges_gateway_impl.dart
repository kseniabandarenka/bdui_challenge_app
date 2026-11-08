import 'package:client/data/source/api/challenges_api.dart';
import 'package:client/domain/gateway/challenges_gateway.dart';
import 'package:shared/shared.dart';

class ChallengesGatewayImpl implements ChallengesGateway {
  final ChallengesApi api;

  ChallengesGatewayImpl(this.api);

  @override
  Future<List<Challenge>> getChallenges() async {
    final models = await api.getChallenges();
    return models.map(ChallengeMapper.toEntity).toList();
  }

  @override
  Future<void> trackProgress({
    required double progress,
    required String id,
  }) =>
      api.trackProgress(ProgressRequestModel(progress: progress), id: id);
}
