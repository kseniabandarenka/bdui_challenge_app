// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bdui_action_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BDUIActionModel _$BDUIActionModelFromJson(Map<String, dynamic> json) =>
    BDUIActionModel(
      type: $enumDecode(_$BDUITypeEnumMap, json['type']),
      text: json['text'] as String?,
      action: BDUIActionData.fromJson(json['action'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BDUIActionModelToJson(BDUIActionModel instance) =>
    <String, dynamic>{
      'type': _$BDUITypeEnumMap[instance.type]!,
      'text': instance.text,
      'action': instance.action,
    };

const _$BDUITypeEnumMap = {
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

BDUIActionData _$BDUIActionDataFromJson(Map<String, dynamic> json) =>
    BDUIActionData(
      type: $enumDecode(_$BDUIActionTypeEnumMap, json['type']),
      screen: $enumDecodeNullable(_$BDUIScreenTypeEnumMap, json['screen']),
      challengeId: json['challengeId'] as String?,
      progressKey: json['progressKey'] as String?,
      url: json['url'] as String?,
      formKey: json['formKey'] as String?,
      sheet: json['sheet'] == null
          ? null
          : BDUIElementModel.fromJson(json['sheet'] as Map<String, dynamic>),
      customData: json['customData'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$BDUIActionDataToJson(BDUIActionData instance) =>
    <String, dynamic>{
      'type': _$BDUIActionTypeEnumMap[instance.type]!,
      'screen': _$BDUIScreenTypeEnumMap[instance.screen],
      'challengeId': instance.challengeId,
      'progressKey': instance.progressKey,
      'url': instance.url,
      'formKey': instance.formKey,
      'sheet': instance.sheet,
      'customData': instance.customData,
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
