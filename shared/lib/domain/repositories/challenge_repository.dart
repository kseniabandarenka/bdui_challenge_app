import 'package:shared/domain/models/challenge.dart';

abstract class ChallengeRepository {
  Future<List<Challenge>> getChallenges();
  Future<Challenge> getChallengeById(String id);
  Future<Challenge> updateChallenge(Challenge challenge);
  Future<void> trackProgress(String challengeId, int progress);
}
