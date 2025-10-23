import 'package:client/bdui/actions/bdui_action_service.dart';
import 'package:client/bdui/utils/bdui_parsing_utils.dart';
import 'package:flutter/material.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';

class ButtonRenderer {
  static Widget render(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    try {
      final style = model.style;
      final action = model.actions?.isNotEmpty == true ? model.actions!.first.action : null;
      
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => BDUIActionService.handleAction(action, context, onDataUpdated),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BDUIParsingUtils.parseColor(style?.color),
                    foregroundColor: BDUIParsingUtils.parseColor(style?.color), // Используем color для текста
                    padding: _parseButtonPadding(model),
                  ),
                  child: Text(model.value ?? 'Кнопка'),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга кнопки: $e');
    }
  }

  static EdgeInsets _parseButtonPadding(BDUIElementModel model) {
    // Для кнопки используем дефолтные отступы или из decoration
    if (model.decoration?.padding != null) {
      final padding = model.decoration!.padding!;
      if (padding.all != null) {
        return EdgeInsets.all(padding.all!);
      }
      return EdgeInsets.only(
        left: padding.left ?? 16,
        top: padding.top ?? 12,
        right: padding.right ?? 16,
        bottom: padding.bottom ?? 12,
      );
    }
    
    // Дефолтные отступы для кнопки
    return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
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