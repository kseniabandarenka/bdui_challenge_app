import 'package:json_annotation/json_annotation.dart';
import 'package:shared/data/models/bdui/bdui_action_model.dart';
import 'package:shared/data/models/bdui/bdui_card_action_model.dart';
import 'package:shared/data/models/bdui/bdui_type_model.dart';

part 'bdui_challenge_card_model.g.dart';

@JsonSerializable()
class BDUIChallengeCardModel {
  final String id;
  final BDUIType type;
  final String title;
  final String category;
  final String? description;
  final double progressCurrent;
  final double progressTotal;
  final bool completed;
  final bool isInProgress;
  final double progressPercentage;
  final List<BDUIActionModel> actions;
  final BDUICardActionModel action;

  BDUIChallengeCardModel({
    required this.id,
    required this.type,
    required this.title,
    required this.category,
    this.description,
    required this.progressCurrent,
    required this.progressTotal,
    required this.completed,
    required this.isInProgress,
    required this.progressPercentage,
    required this.actions,
    required this.action,
  });

  factory BDUIChallengeCardModel.fromJson(Map<String, dynamic> json) =>
      _$BDUIChallengeCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$BDUIChallengeCardModelToJson(this);
}