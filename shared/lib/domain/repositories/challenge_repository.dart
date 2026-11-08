import 'package:shared/domain/models/challenge.dart';

abstract class ChallengeRepository {
  Future<List<Challenge>> getChallenges();

  /// Бросает [ChallengeNotFoundException], если челленджа нет.
  Future<Challenge> getChallengeById(String id);

  /// Бросает [ChallengeNotFoundException], если челленджа нет.
  Future<Challenge> updateChallenge(Challenge challenge);
}
