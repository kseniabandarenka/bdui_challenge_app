import 'package:shared/domain/models/challenge.dart';
import 'package:shared/domain/repositories/challenge_repository.dart';

class GetChallengesUseCase {
  final ChallengeRepository repository;

  GetChallengesUseCase(this.repository);

  Future<List<Challenge>> execute() async {
    final challenges = await repository.getChallenges();
    return challenges.where((challenge) => !challenge.completed).toList();
  }
}