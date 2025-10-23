import 'package:client/bdui/engine/engine.dart';
import 'package:flutter/material.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';

class ColumnRenderer {
  static Widget render(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _renderChildren(model.children, context, onDataUpdated),
      );
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга колонки: $e');
    }
  }

  static List<Widget> _renderChildren(List<BDUIElementModel>? children, BuildContext context, VoidCallback? onDataUpdated) {
    if (children == null) return [];
    
    return children.map((child) {
      return BDUIEngine.renderFromModel(
        model: child,
        context: context,
        onDataUpdated: onDataUpdated,
      );
    }).toList();
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