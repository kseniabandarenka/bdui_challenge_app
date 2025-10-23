import 'package:flutter/material.dart';

class BDUIParsingUtils {
  static EdgeInsets? parseEdgeInsets(dynamic padding) {
    if (padding is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: (padding['left'] as num?)?.toDouble() ?? 0,
        top: (padding['top'] as num?)?.toDouble() ?? 0,
        right: (padding['right'] as num?)?.toDouble() ?? 0,
        bottom: (padding['bottom'] as num?)?.toDouble() ?? 0,
      );
    }
    return null;
  }

  static Color? parseColor(dynamic color) {
    if (color is String) {
      try {
        return Color(int.parse(color.replaceFirst('#', '0xff')));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static FontWeight parseFontWeight(dynamic fontWeight) {
    if (fontWeight == 'bold') return FontWeight.bold;
    return FontWeight.normal;
  }
}