// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bdui_card_action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BDUICardActionModel _$BDUICardActionModelFromJson(Map<String, dynamic> json) =>
    BDUICardActionModel(
      type: $enumDecode(_$BDUIActionTypeEnumMap, json['type']),
      screen: $enumDecode(_$BDUIScreenTypeEnumMap, json['screen']),
      challengeId: json['challenge_id'] as String,
    );

Map<String, dynamic> _$BDUICardActionModelToJson(
  BDUICardActionModel instance,
) => <String, dynamic>{
  'type': _$BDUIActionTypeEnumMap[instance.type]!,
  'screen': _$BDUIScreenTypeEnumMap[instance.screen]!,
  'challenge_id': instance.challengeId,
};

const _$BDUIActionTypeEnumMap = {
  BDUIActionType.navigate: 'navigate',
  BDUIActionType.showBottomSheet: 'show_bottom_sheet',
  BDUIActionType.trackProgress: 'track_progress',
};

const _$BDUIScreenTypeEnumMap = {
  BDUIScreenType.challengesList: 'challenges_list',
  BDUIScreenType.challengeDetail: 'challenge_detail',
  BDUIScreenType.profile: 'profile',
  BDUIScreenType.settings: 'settings',
};
