// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ui_element.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UIElement _$UIElementFromJson(Map<String, dynamic> json) => UIElement(
  type: json['type'] as String,
  text: json['text'] as String?,
  style: json['style'] as Map<String, dynamic>?,
  children: (json['children'] as List<dynamic>?)
      ?.map((e) => UIElement.fromJson(e as Map<String, dynamic>))
      .toList(),
  action: json['action'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$UIElementToJson(UIElement instance) => <String, dynamic>{
  'type': instance.type,
  'text': instance.text,
  'style': instance.style,
  'children': instance.children,
  'action': instance.action,
};
