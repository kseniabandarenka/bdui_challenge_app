import 'package:json_annotation/json_annotation.dart';
import 'package:shared/data/models/bdui/bdui_type_model.dart';
import 'bdui_element_model.dart';

part 'bdui_action_model.g.dart';

@JsonSerializable()
class BDUIActionModel {
  final BDUIType type;
  final String text;
  final BDUIActionData action;

  BDUIActionModel({
    required this.type,
    required this.text,
    required this.action,
  });

  factory BDUIActionModel.fromJson(Map<String, dynamic> json) =>
      _$BDUIActionModelFromJson(json);

  Map<String, dynamic> toJson() => _$BDUIActionModelToJson(this);
}

@JsonSerializable()
class BDUIActionData {
  final BDUIActionType type;
  final String? screen;
  final String? challengeId;
  final String? progressKey;
  final String? url;
  final String? formKey;
  final BDUIElementModel? sheet;
  final Map<String, dynamic>? customData;

  BDUIActionData({
    required this.type,
    this.screen,
    this.challengeId,
    this.progressKey,
    this.url,
    this.formKey,
    this.sheet,
    this.customData,
  });

  factory BDUIActionData.fromJson(Map<String, dynamic> json) =>
      _$BDUIActionDataFromJson(json);

  Map<String, dynamic> toJson() => _$BDUIActionDataToJson(this);
}

enum BDUIActionType {
  @JsonValue('navigate')
  navigate,
  
  @JsonValue('show_bottom_sheet')
  showBottomSheet,
  
  @JsonValue('track_progress')
  trackProgress,
}