import 'package:json_annotation/json_annotation.dart';

part 'bdui_text_style_model.g.dart';

@JsonEnum()
enum BDUIFontWeight {
  @JsonValue('normal')
  normal,

  @JsonValue('bold')
  bold,

  @JsonValue('w100')
  w100,

  @JsonValue('w200')
  w200,

  @JsonValue('w300')
  w300,

  @JsonValue('w400')
  w400,

  @JsonValue('w500')
  w500,

  @JsonValue('w600')
  w600,

  @JsonValue('w700')
  w700,

  @JsonValue('w800')
  w800,

  @JsonValue('w900')
  w900,
}

@JsonEnum()
enum BDUITextAlign {
  @JsonValue('left')
  left,

  @JsonValue('center')
  center,

  @JsonValue('right')
  right,

  @JsonValue('justify')
  justify,
}

@JsonSerializable()
class BDUITextStyleModel {
  final double? fontSize;
  final BDUIFontWeight? fontWeight;
  final String? color;
  final BDUITextAlign? textAlign;
  final String? fontFamily;
  final double? letterSpacing;
  final double? lineHeight;
  final bool? underline;
  final bool? italic;

  BDUITextStyleModel({
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
    this.fontFamily,
    this.letterSpacing,
    this.lineHeight,
    this.underline,
    this.italic,
  });

  factory BDUITextStyleModel.fromJson(Map<String, dynamic> json) =>
      _$BDUITextStyleModelFromJson(json);

  Map<String, dynamic> toJson() => _$BDUITextStyleModelToJson(this);
}
