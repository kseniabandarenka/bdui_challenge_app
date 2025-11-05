import 'package:client/domain/gateway/challenges_gateway.dart';
import 'package:shared/shared.dart';

/// UseCase для получения списка челленджей
class GetChallengesUseCase {
  final ChallengesGateway gateway;

  GetChallengesUseCase(this.gateway);

  Future<List<ChallengeModel>> call() => gateway.getChallenges();
}
