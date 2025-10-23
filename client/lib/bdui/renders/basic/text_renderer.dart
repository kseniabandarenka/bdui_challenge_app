import 'package:client/bdui/utils/bdui_parsing_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';
import 'package:shared/data/models/bdui/bdui_text_style_model.dart';

class TextRenderer {
  static Widget render(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    try {
      final style = model.style;
      
      return Text(
        model.value ?? '',
        style: TextStyle(
          fontSize: style?.fontSize ?? 16,
          fontWeight: _parseFontWeight(style?.fontWeight),
          color: BDUIParsingUtils.parseColor(style?.color),
        ),
      );
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга текста: $e');
    }
  }

  static FontWeight _parseFontWeight(BDUIFontWeight? fontWeight) {
    switch (fontWeight) {
      case BDUIFontWeight.bold:
        return FontWeight.bold;
      case BDUIFontWeight.w100:
        return FontWeight.w100;
      case BDUIFontWeight.w200:
        return FontWeight.w200;
      case BDUIFontWeight.w300:
        return FontWeight.w300;
      case BDUIFontWeight.w400:
        return FontWeight.w400;
      case BDUIFontWeight.w500:
        return FontWeight.w500;
      case BDUIFontWeight.w600:
        return FontWeight.w600;
      case BDUIFontWeight.w700:
        return FontWeight.w700;
      case BDUIFontWeight.w800:
        return FontWeight.w800;
      case BDUIFontWeight.w900:
        return FontWeight.w900;
      default:
        return FontWeight.normal;
    }
  }

  static Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.red[50],
      child: Text(
        message,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}