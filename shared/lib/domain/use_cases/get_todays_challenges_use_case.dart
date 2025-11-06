import 'package:shared/domain/models/challenge.dart';
import 'package:shared/domain/repositories/challenge_repository.dart';

class GetTodaysChallengesUseCase {
  final ChallengeRepository repository;

  GetTodaysChallengesUseCase(this.repository);

  Future<List<Challenge>> execute() async {
    final challenges = await repository.getChallenges();
    final today = DateTime.now();

    return challenges.where((challenge) {
      final isToday =
          challenge.createdAt.year == today.year &&
          challenge.createdAt.month == today.month &&
          challenge.createdAt.day == today.day;
      return isToday || !challenge.completed;
    }).toList();
  }
}
