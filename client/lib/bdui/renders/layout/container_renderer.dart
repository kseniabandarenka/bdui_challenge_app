import 'package:client/bdui/engine/engine.dart';
import 'package:client/bdui/utils/bdui_parsing_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';
import 'package:shared/data/models/bdui/bdui_decoration_model.dart';

class ContainerRenderer {
  static Widget render(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    try {
      return Container(
        decoration: _buildDecoration(model.decoration),
        padding: _parsePadding(model.decoration?.padding),
        margin: _parsePadding(model.decoration?.margin),
        child: _buildChild(model, context, onDataUpdated),
      );
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга контейнера: $e');
    }
  }

  static BoxDecoration? _buildDecoration(BDUIDecorationModel? decoration) {
    if (decoration == null) return null;
    
    return BoxDecoration(
      color: BDUIParsingUtils.parseColor(decoration.color),
      borderRadius: _parseBorderRadius(decoration.borderRadius),
      border: _parseBorder(decoration.border),
      boxShadow: _parseBoxShadow(decoration.boxShadow),
    );
  }

  static BorderRadius? _parseBorderRadius(BDUIBorderRadius? borderRadius) {
    if (borderRadius == null) return null;
    
    if (borderRadius.all != null) {
      return BorderRadius.circular(borderRadius.all!);
    }
    
    return BorderRadius.only(
      topLeft: Radius.circular(borderRadius.topLeft ?? 0),
      topRight: Radius.circular(borderRadius.topRight ?? 0),
      bottomLeft: Radius.circular(borderRadius.bottomLeft ?? 0),
      bottomRight: Radius.circular(borderRadius.bottomRight ?? 0),
    );
  }

  static Border? _parseBorder(BDUIBorder? border) {
    if (border == null) return null;
    
    return Border.all(
      color: BDUIParsingUtils.parseColor(border.color) ?? Colors.black,
      width: border.width ?? 1.0,
    );
  }

  static List<BoxShadow>? _parseBoxShadow(List<BDUIBoxShadow>? boxShadows) {
    if (boxShadows == null) return null;
    
    return boxShadows.map((shadow) {
      return BoxShadow(
        blurRadius: shadow.blurRadius ?? 0,
        spreadRadius: shadow.spreadRadius ?? 0,
        offset: Offset(shadow.offsetX ?? 0, shadow.offsetY ?? 0),
        color: BDUIParsingUtils.parseColor(shadow.color) ?? Colors.transparent,
      );
    }).toList();
  }

  static EdgeInsets? _parsePadding(BDUIPadding? padding) {
    if (padding == null) return null;
    
    if (padding.all != null) {
      return EdgeInsets.all(padding.all!);
    }
    
    if (padding.horizontal != null || padding.vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: padding.horizontal ?? 0,
        vertical: padding.vertical ?? 0,
      );
    }
    
    return EdgeInsets.only(
      left: padding.left ?? 0,
      top: padding.top ?? 0,
      right: padding.right ?? 0,
      bottom: padding.bottom ?? 0,
    );
  }

  static Widget? _buildChild(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    if (model.child != null) {
      return BDUIEngine.renderFromModel(
        model: model.child!,
        context: context,
        onDataUpdated: onDataUpdated,
      );
    } else if (model.children != null && model.children!.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: model.children!.map((child) {
          return BDUIEngine.renderFromModel(
            model: child,
            context: context,
            onDataUpdated: onDataUpdated,
          );
        }).toList(),
      );
    }
    return null;
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