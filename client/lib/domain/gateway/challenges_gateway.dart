import 'package:shared/shared.dart';

abstract class ChallengesGateway {
  Future<List<Challenge>> getChallenges();

  Future<void> trackProgress({
    required double progress,
    required String id,
  });
}
