import 'package:json_annotation/json_annotation.dart';

part 'challenge_model.g.dart';

@JsonSerializable()
class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final double progressCurrent;
  final double progressTotal;
  final bool completed;
  final DateTime createdAt;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.progressCurrent,
    required this.progressTotal,
    required this.completed,
    required this.createdAt,
  });

  factory ChallengeModel.fromJson(Map<String, dynamic> json) =>
      _$ChallengeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeModelToJson(this);
}
