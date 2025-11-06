import 'package:shared/domain/models/challenge.dart';

class HomeScreenData {
  final List<Challenge> challenges;
  final int completedCount;
  final int totalCount;

  HomeScreenData({
    required this.challenges,
    required this.completedCount,
    required this.totalCount,
  });
}
