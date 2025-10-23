import 'package:client/bdui/actions/bdui_action_service.dart';
import 'package:client/bdui/renders/basic/button_renderer.dart';
import 'package:client/bdui/renders/basic/progress_bar_renderer.dart';
import 'package:client/bdui/renders/basic/text_renderer.dart';
import 'package:client/bdui/renders/custom/challenge_card_renderer.dart';
import 'package:client/bdui/renders/custom/challenge_list_renderer.dart';
import 'package:client/bdui/renders/input/number_input_renderer.dart';
import 'package:client/bdui/renders/input/text_field_renderer.dart';
import 'package:client/bdui/renders/layout/column_renderer.dart';
import 'package:client/bdui/renders/layout/container_renderer.dart';
import 'package:flutter/material.dart';
import 'package:shared/data/models/bdui/bdui_screen_model.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';
import 'package:shared/shared.dart';

class BDUIEngine {
  static final Map<String, TextEditingController> _textControllers = {};

  // Основной метод рендеринга BDUI JSON
  static Widget renderFromJson({
    required Map<String, dynamic> json,
    required BuildContext context,
    VoidCallback? onDataUpdated,
  }) {
    final typeString = json['type'] as String?;
    
    // ОБРАБОТКА ТИПА 'screen' С LAYOUT
    if (typeString == 'screen') {
      try {
        final screenModel = BDUIScreenModel.fromJson(json);
        // Конвертируем BDUILayoutModel в BDUIElementModel
        final layoutElement = BDUIElementModel(
          type: screenModel.layout.type,
          children: screenModel.layout.children,
        );
        return renderFromModel(
          model: layoutElement,
          context: context,
          onDataUpdated: onDataUpdated,
        );
      } catch (e) {
        return _buildErrorWidget('Ошибка рендеринга экрана: $e');
      }
    }
    
    try {
      final model = BDUIElementModel.fromJson(json);
      return renderFromModel(
        model: model,
        context: context,
        onDataUpdated: onDataUpdated,
      );
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга: $e\nДанные: $json');
    }
  }

  // Основной метод рендеринга BDUI моделей
  static Widget renderFromModel({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
  }) {
    switch (model.type) {
      case BDUIType.column:
        return ColumnRenderer.render(model, context, onDataUpdated);
      case BDUIType.container:
        return ContainerRenderer.render(model, context, onDataUpdated);
      case BDUIType.row:
        return _renderRow(model, context, onDataUpdated);
      case BDUIType.text:
        return TextRenderer.render(model, context, onDataUpdated);
      case BDUIType.button:
        return ButtonRenderer.render(model, context, onDataUpdated);
      case BDUIType.progressBar:
        return ProgressBarRenderer.render(model, context, onDataUpdated);
      case BDUIType.challengeCard:
        return ChallengeCardRenderer.render(model, context, onDataUpdated);
      case BDUIType.challengeList:
        return ChallengeListRenderer.render(model, context, onDataUpdated);
      case BDUIType.textField:
        return TextFieldRenderer.render(model, context, onDataUpdated);
      case BDUIType.numberInput:
        return NumberInputRenderer.render(model, context, onDataUpdated);
      default:
        return _buildErrorWidget('Неизвестный тип виджета: ${model.type}');
    }
  }

  // МЕТОДЫ РЕНДЕРИНГА

  static Widget _renderRow(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    return Row(
      children: _renderChildren(model.children, context, onDataUpdated),
    );
  }

  static List<Widget> _renderChildren(List<BDUIElementModel>? children, BuildContext context, VoidCallback? onDataUpdated) {
    return children?.map((child) {
      return renderFromModel(
        model: child,
        context: context,
        onDataUpdated: onDataUpdated,
      );
    }).toList() ?? [];
  }

  static void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    _textControllers.clear();
    BDUIActionService.dispose();
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