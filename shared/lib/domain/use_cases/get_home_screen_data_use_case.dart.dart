import 'package:shared/domain/models/home_screen_data.dart';
import 'package:shared/domain/repositories/challenge_repository.dart';

class GetHomeScreenDataUseCase {
  final ChallengeRepository repository;

  GetHomeScreenDataUseCase(this.repository);

  Future<HomeScreenData> execute() async {
    final challenges = await repository.getChallenges();
    final activeChallenges = challenges.where((c) => !c.completed).toList();
    final completedCount = challenges.where((c) => c.completed).length;
    
    return HomeScreenData(
      challenges: activeChallenges,
      completedCount: completedCount,
      totalCount: challenges.length,
    );
  }
}