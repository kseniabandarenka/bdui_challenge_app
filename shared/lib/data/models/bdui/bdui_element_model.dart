import 'package:json_annotation/json_annotation.dart';
import 'package:shared/data/models/bdui/bdui_type_model.dart';
import 'bdui_decoration_model.dart';
import 'bdui_text_style_model.dart';
import 'bdui_challenge_card_model.dart';
import 'bdui_action_model.dart';

part 'bdui_element_model.g.dart';

@JsonSerializable()
class BDUIElementModel {
  final BDUIType type;
  final String? value;
  final BDUITextStyleModel? style;
  final BDUIDecorationModel? decoration;
  final BDUIElementModel? child;
  final List<BDUIElementModel>? children;
  final List<BDUIChallengeCardModel>? challenges;
  final List<BDUIActionModel>? actions;

  BDUIElementModel({
    required this.type,
    this.value,
    this.style,
    this.decoration,
    this.child,
    this.children,
    this.challenges,
    this.actions,
  });

  factory BDUIElementModel.fromJson(Map<String, dynamic> json) =>
      _$BDUIElementModelFromJson(json);

  Map<String, dynamic> toJson() => _$BDUIElementModelToJson(this);
}