import 'package:json_annotation/json_annotation.dart';

part 'progress_request_model.g.dart';

@JsonSerializable()
class ProgressRequestModel {
  @JsonKey(name: 'progress')
  final double progress;

  ProgressRequestModel({required this.progress});

  factory ProgressRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ProgressRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressRequestModelToJson(this);
}
