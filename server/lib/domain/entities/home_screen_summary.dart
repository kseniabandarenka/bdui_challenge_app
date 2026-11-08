import 'package:shared/shared.dart';

/// Данные главного экрана: список челленджей и агрегированная статистика.
class HomeScreenSummary {
  final List<Challenge> challenges;
  final int completedCount;
  final int inProgressCount;

  /// Средний прогресс по всем челленджам в процентах (0–100).
  final double averageProgressPercent;

  HomeScreenSummary({
    required this.challenges,
    required this.completedCount,
    required this.inProgressCount,
    required this.averageProgressPercent,
  });
}
