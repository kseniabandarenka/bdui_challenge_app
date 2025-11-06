import 'package:json_annotation/json_annotation.dart';
import 'package:shared/shared.dart';
part 'bdui_screen_model.g.dart';

@JsonSerializable()
class BDUIScreenModel {
  @JsonKey(name: 'screen_type')
  final BDUIScreenType screenType;
  final String? title;
  final BDUIElementModel layout;

  BDUIScreenModel({required this.screenType, this.title, required this.layout});

  factory BDUIScreenModel.fromJson(Map<String, dynamic> json) =>
      _$BDUIScreenModelFromJson(json);

  Map<String, dynamic> toJson() => _$BDUIScreenModelToJson(this);
}
