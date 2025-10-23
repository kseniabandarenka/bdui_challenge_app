import 'package:json_annotation/json_annotation.dart';

part 'bdui_decoration_model.g.dart';

@JsonSerializable()
class BDUIBorderRadius {
  final double? topLeft;
  final double? topRight;
  final double? bottomLeft;
  final double? bottomRight;
  final double? all;

  BDUIBorderRadius({
    this.topLeft,
    this.topRight,
    this.bottomLeft,
    this.bottomRight,
    this.all,
  });

  factory BDUIBorderRadius.fromJson(Map<String, dynamic> json) =>
      _$BDUIBorderRadiusFromJson(json);

  Map<String, dynamic> toJson() => _$BDUIBorderRadiusToJson(this);
}

@JsonSerializable()
class BDUIPadding {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? horizontal;
  final double? vertical;
  final double? all;

  BDUIPadding({
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.horizontal,
    this.vertical,
    this.all,
  });

  factory BDUIPadding.fromJson(Map<String, dynamic> json) =>
      _$BDUIPaddingFromJson(json);

  Map<String, dynamic> toJson() => _$BDUIPaddingToJson(this);
}

@JsonSerializable()
class BDUIBorder {
  final double? width;
  final String? color;
  final BDUIBorderStyle? style;

  BDUIBorder({
    this.width,
    this.color,
    this.style,
  });

  factory BDUIBorder.fromJson(Map<String, dynamic> json) =>
      _$BDUIBorderFromJson(json);

  Map<String, dynamic> toJson() => _$BDUIBorderToJson(this);
}

@JsonEnum()
enum BDUIBorderStyle {
  @JsonValue('solid')
  solid,
  
  @JsonValue('dashed')
  dashed,
  
  @JsonValue('dotted')
  dotted,
}

@JsonSerializable()
class BDUIDecorationModel {
  final String? color;
  final String? gradient;
  final BDUIBorderRadius? borderRadius;
  final BDUIBorder? border;
  final BDUIPadding? padding;
  final BDUIPadding? margin;
  final List<BDUIBoxShadow>? boxShadow;

  BDUIDecorationModel({
    this.color,
    this.gradient,
    this.borderRadius,
    this.border,
    this.padding,
    this.margin,
    this.boxShadow,
  });

  factory BDUIDecorationModel.fromJson(Map<String, dynamic> json) =>
      _$BDUIDecorationModelFromJson(json);

  Map<String, dynamic> toJson() => _$BDUIDecorationModelToJson(this);
}

@JsonSerializable()
class BDUIBoxShadow {
  final double? blurRadius;
  final double? spreadRadius;
  final double? offsetX;
  final double? offsetY;
  final String? color;

  BDUIBoxShadow({
    this.blurRadius,
    this.spreadRadius,
    this.offsetX,
    this.offsetY,
    this.color,
  });

  factory BDUIBoxShadow.fromJson(Map<String, dynamic> json) =>
      _$BDUIBoxShadowFromJson(json);

  Map<String, dynamic> toJson() => _$BDUIBoxShadowToJson(this);
}