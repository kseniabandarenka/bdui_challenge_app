import 'package:client/data/source/api/challenges_api.dart';
import 'package:client/domain/gateway/challenges_gateway.dart';
import 'package:shared/shared.dart';

class ChallengesGatewayImpl implements ChallengesGateway {
  final ChallengesApi api;

  ChallengesGatewayImpl(this.api);

  @override
  Future<List<ChallengeModel>> getChallenges() => api.getChallenges();

  @override
  Future<void> trackProgress({
    required ProgressRequestModel progress,
    required String id,
  }) =>
      api.trackProgress(progress, id: id);
}
