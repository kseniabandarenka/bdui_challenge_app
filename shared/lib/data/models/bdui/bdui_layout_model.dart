import 'package:json_annotation/json_annotation.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';
import 'package:shared/data/models/bdui/bdui_type_model.dart';

part 'bdui_layout_model.g.dart';

@JsonSerializable()
class BDUILayoutModel {
  final BDUIType type;
  final List<BDUIElementModel> children;

  BDUILayoutModel({
    required this.type,
    required this.children,
  });

  factory BDUILayoutModel.fromJson(Map<String, dynamic> json) =>
      _$BDUILayoutModelFromJson(json);

  Map<String, dynamic> toJson() => _$BDUILayoutModelToJson(this);
}