// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bdui_screen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BDUIScreenModel _$BDUIScreenModelFromJson(Map<String, dynamic> json) =>
    BDUIScreenModel(
      type: $enumDecode(_$BDUITypeEnumMap, json['type']),
      screenType: $enumDecode(_$BDUIScreenTypeEnumMap, json['screen_type']),
      title: json['title'] as String?,
      layout: BDUILayoutModel.fromJson(json['layout'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BDUIScreenModelToJson(BDUIScreenModel instance) =>
    <String, dynamic>{
      'type': _$BDUITypeEnumMap[instance.type]!,
      'screen_type': _$BDUIScreenTypeEnumMap[instance.screenType]!,
      'title': instance.title,
      'layout': instance.layout,
    };

const _$BDUITypeEnumMap = {
  BDUIType.screen: 'screen',
  BDUIType.column: 'column',
  BDUIType.container: 'container',
  BDUIType.row: 'row',
  BDUIType.text: 'text',
  BDUIType.button: 'button',
  BDUIType.progressBar: 'progress_bar',
  BDUIType.textField: 'text_field',
  BDUIType.challengeCard: 'challenge_card',
  BDUIType.challengeList: 'challenge_list',
  BDUIType.numberInput: 'number_input',
};

const _$BDUIScreenTypeEnumMap = {
  BDUIScreenType.challengesList: 'challenges_list',
  BDUIScreenType.challengeDetail: 'challenge_detail',
  BDUIScreenType.profile: 'profile',
  BDUIScreenType.settings: 'settings',
};
