import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class Parsers {
  static EdgeInsets? parseBDUIPadding(BDUIPadding? padding) {
    if (padding != null) {
      return EdgeInsets.only(
        left: padding.left?.toDouble() ?? 0.0,
        top: padding.top?.toDouble() ?? 0.0,
        right: padding.right?.toDouble() ?? 0.0,
        bottom: padding.bottom?.toDouble() ?? 0.0,
      );
    }
    return null;
  }

  static Color? parseColor(String? color) {
    if (color != null) {
      try {
        return Color(int.parse(color.replaceFirst('#', '0xff')));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static FontWeight parseFontWeight(BDUIFontWeight? fontWeight) {
    switch (fontWeight) {
      case BDUIFontWeight.bold:
        return FontWeight.bold;
      case BDUIFontWeight.normal:
      default:
        return FontWeight.normal;
    }
  }
}
