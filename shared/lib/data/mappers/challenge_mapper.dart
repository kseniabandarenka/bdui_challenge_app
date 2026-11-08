import 'package:shared/data/models/challenge_model.dart';
import 'package:shared/domain/models/challenge.dart';

/// Преобразует DTO внешнего слоя в доменную сущность и обратно.
/// Лежит в слое данных: домен ничего не знает о ChallengeModel.
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
