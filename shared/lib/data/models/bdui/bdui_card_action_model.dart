import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';

part 'bdui_card_action_model.g.dart';

@JsonSerializable()
class BDUICardActionModel {
  final BDUIActionType type;

  final BDUIScreenType screen;

  @JsonKey(name: 'challenge_id')
  final String challengeId;

  BDUICardActionModel({
    required this.type,
    required this.screen,
    required this.challengeId,
  });

  factory BDUICardActionModel.fromJson(Map<String, dynamic> json) =>
      _$BDUICardActionModelFromJson(json);

  Map<String, dynamic> toJson() => _$BDUICardActionModelToJson(this);
}
