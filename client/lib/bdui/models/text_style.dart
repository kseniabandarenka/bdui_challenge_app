
// Enum для стилей текста
import 'package:flutter/material.dart';

enum TextStyleProperty {
  fontSize,
  fontWeight,
  color,
  // Можно добавлять новые свойства
}

// Enum для значений fontWeight
enum FontWeightValue {
  normal,
  bold,
  w100,
  w200,
  w300,
  w400,
  w500,
  w600,
  w700,
  w800,
  w900,
}


extension TextStylePropertyExtension on TextStyleProperty {
  String get value {
    switch (this) {
      case TextStyleProperty.fontSize:
        return 'fontSize';
      case TextStyleProperty.fontWeight:
        return 'fontWeight';
      case TextStyleProperty.color:
        return 'color';
    }
  }
}



extension FontWeightValueExtension on FontWeightValue {
  FontWeight get flutterFontWeight {
    switch (this) {
      case FontWeightValue.normal:
        return FontWeight.normal;
      case FontWeightValue.bold:
        return FontWeight.bold;
      case FontWeightValue.w100:
        return FontWeight.w100;
      case FontWeightValue.w200:
        return FontWeight.w200;
      case FontWeightValue.w300:
        return FontWeight.w300;
      case FontWeightValue.w400:
        return FontWeight.w400;
      case FontWeightValue.w500:
        return FontWeight.w500;
      case FontWeightValue.w600:
        return FontWeight.w600;
      case FontWeightValue.w700:
        return FontWeight.w700;
      case FontWeightValue.w800:
        return FontWeight.w800;
      case FontWeightValue.w900:
        return FontWeight.w900;
    }
  } 
   static FontWeightValue fromString(String value) {
    switch (value) {
      case 'normal':
        return FontWeightValue.normal;
      case 'bold':
        return FontWeightValue.bold;
      case 'w100':
        return FontWeightValue.w100;
      case 'w200':
        return FontWeightValue.w200;
      case 'w300':
        return FontWeightValue.w300;
      case 'w400':
        return FontWeightValue.w400;
      case 'w500':
        return FontWeightValue.w500;
      case 'w600':
        return FontWeightValue.w600;
      case 'w700':
        return FontWeightValue.w700;
      case 'w800':
        return FontWeightValue.w800;
      case 'w900':
        return FontWeightValue.w900;
      default:
        return FontWeightValue.normal;
    }
  }
}