import 'package:json_annotation/json_annotation.dart';

enum BDUIScreenType {
  @JsonValue('challenges_list')
  challengesList,

  @JsonValue('challenge_detail')
  challengeDetail,

  @JsonValue('profile')
  profile,

  @JsonValue('settings')
  settings,
}
