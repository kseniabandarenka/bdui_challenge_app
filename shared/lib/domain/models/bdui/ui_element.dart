import 'package:json_annotation/json_annotation.dart';

part 'ui_element.g.dart';

@JsonSerializable()
class UIElement {
  final String type;
  final String? text;
  final Map<String, dynamic>? style;
  final List<UIElement>? children;
  final Map<String, dynamic>? action;

  UIElement({
    required this.type,
    this.text,
    this.style,
    this.children,
    this.action,
  });

  factory UIElement.fromJson(Map<String, dynamic> json) =>
      _$UIElementFromJson(json);

  Map<String, dynamic> toJson() => _$UIElementToJson(this);
}