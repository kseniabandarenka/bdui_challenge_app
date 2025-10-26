import 'package:json_annotation/json_annotation.dart';
import 'package:shared/data/models/bdui/bdui_action_model.dart';
import 'package:shared/data/models/bdui/bdui_card_action_model.dart';
import 'package:shared/data/models/bdui/bdui_decoration_model.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';
import 'package:shared/data/models/bdui/bdui_text_style_model.dart';
import 'package:shared/data/models/bdui/bdui_type_model.dart';

part 'bdui_challenge_card_model.g.dart';

@JsonSerializable()
class BDUIChallengeCardModel extends BDUIElementModel {
  final String id;
  final String title;
  final String category;
  final String? description;
  final double progressCurrent;
  final double progressTotal;
  final bool completed;
  final bool isInProgress;
  final double progressPercentage;
  final BDUICardActionModel action;

  BDUIChallengeCardModel({
    required this.id,
    required BDUIType type,
    required this.title,
    required this.category,
    this.description,
    required this.progressCurrent,
    required this.progressTotal,
    required this.completed,
    required this.isInProgress,
    required this.progressPercentage,
    required this.action,
    String? value,
    BDUITextStyleModel? style,
    BDUIDecorationModel? decoration,
    BDUIElementModel? child,
    List<BDUIElementModel>? children,
    List<BDUIActionModel>? actions,
  }) : super(
          type: type,
          value: value,
          style: style,
          decoration: decoration,
          child: child,
          children: children,
          actions: actions,
        );

  factory BDUIChallengeCardModel.fromJson(Map<String, dynamic> json) =>
      _$BDUIChallengeCardModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$BDUIChallengeCardModelToJson(this);
}