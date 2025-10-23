import 'package:shared/data/models/challenge_model.dart';

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

  double get progressPercentage => progressTotal > 0 ? progressCurrent / progressTotal : 0;
  bool get isInProgress => progressCurrent > 0 && !completed;
  bool get isOverdue => !completed && DateTime.now().isAfter(createdAt.add(Duration(days: 1)));
  
  Challenge updateProgress(double newProgress) {
    return Challenge(
      id: id,
      title: title,
      description: description,
      category: category,
      progressCurrent: newProgress.clamp(0, progressTotal),
      progressTotal: progressTotal,
      completed: newProgress >= progressTotal,
      createdAt: createdAt,
    );
  }
}

// Mapper для конвертации между слоями
class ChallengeMapper {
  static Challenge toEntity(ChallengeModel model) {
    return Challenge(
      id: model.id,
      title: model.title,
      description: model.description,
      category: model.category,
      progressCurrent: model.progressCurrent,
      progressTotal: model.progressTotal,
      completed: model.completed,
      createdAt: model.createdAt,
    );
  }
  
  static ChallengeModel toModel(Challenge entity) {
    return ChallengeModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      progressCurrent: entity.progressCurrent,
      progressTotal: entity.progressTotal,
      completed: entity.completed,
      createdAt: entity.createdAt,
    );
  }
}