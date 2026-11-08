import 'package:bdui_server/domain/entities/home_screen_summary.dart';
import 'package:shared/shared.dart';

class GetHomeScreenSummaryUseCase {
  final ChallengeRepository repository;

  GetHomeScreenSummaryUseCase(this.repository);

  Future<HomeScreenSummary> execute() async {
    final challenges = await repository.getChallenges();

    final totalProgress =
        challenges.fold<double>(0, (sum, c) => sum + c.progressPercentage);
    final averageProgress =
        challenges.isEmpty ? 0.0 : totalProgress / challenges.length * 100;

    return HomeScreenSummary(
      challenges: challenges,
      completedCount: challenges.where((c) => c.completed).length,
      inProgressCount: challenges.where((c) => c.isInProgress).length,
      averageProgressPercent: averageProgress,
    );
  }
}
