// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bdui_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BDUIScreenModel _$BDUIScreenModelFromJson(Map<String, dynamic> json) =>
    BDUIScreenModel(
      screenType: $enumDecode(_$BDUIScreenTypeEnumMap, json['screen_type']),
      title: json['title'] as String?,
      layout: BDUIElementModel.fromJson(json['layout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BDUIScreenModelToJson(BDUIScreenModel instance) =>
    <String, dynamic>{
      'screen_type': _$BDUIScreenTypeEnumMap[instance.screenType]!,
      'title': instance.title,
      'layout': instance.layout,
    };

const _$BDUIScreenTypeEnumMap = {
  BDUIScreenType.challengesList: 'challenges_list',
  BDUIScreenType.challengeDetail: 'challenge_detail',
  BDUIScreenType.profile: 'profile',
  BDUIScreenType.settings: 'settings',
};
