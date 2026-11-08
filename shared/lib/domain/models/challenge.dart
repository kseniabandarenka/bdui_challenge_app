class Challenge {
  final String id;
  final String title;
  final String description;
  final String category;
  final double progressCurrent;
  final double progressTotal;
  final bool completed;
  final DateTime createdAt;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.progressCurrent,
    required this.progressTotal,
    required this.completed,
    required this.createdAt,
  });

  double get progressPercentage =>
      progressTotal > 0 ? progressCurrent / progressTotal : 0;

  bool get isInProgress => progressCurrent > 0 && !completed;

  /// Время передаётся снаружи, чтобы сущность оставалась детерминированной.
  bool isOverdue(DateTime now) =>
      !completed && now.isAfter(createdAt.add(const Duration(days: 1)));

  Challenge updateProgress(double newProgress) {
    return Challenge(
      id: id,
      title: title,
      description: description,
      category: category,
      progressCurrent: newProgress.clamp(0, progressTotal).toDouble(),
      progressTotal: progressTotal,
      completed: newProgress >= progressTotal,
      createdAt: createdAt,
    );
  }
}
