import 'package:shared/shared.dart';

class GetChallengesUseCase {
  final ChallengeRepository repository;

  GetChallengesUseCase(this.repository);

  Future<List<Challenge>> execute() => repository.getChallenges();
}
