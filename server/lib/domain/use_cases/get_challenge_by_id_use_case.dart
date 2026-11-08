import 'package:shared/shared.dart';

class GetChallengeByIdUseCase {
  final ChallengeRepository repository;

  GetChallengeByIdUseCase(this.repository);

  /// Бросает [ChallengeNotFoundException], если челленджа нет.
  Future<Challenge> execute(String id) => repository.getChallengeById(id);
}
