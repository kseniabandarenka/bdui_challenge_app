import 'package:client/bdui/actions/action_handler.dart';
import 'package:client/bdui/error/error_widget.dart';
import 'package:client/bdui/renders/base_renderer.dart';
import 'package:client/bdui/utils/controllers_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class BDUIEngine {
  static final _controllersManager = ControllersManager();
  static final _actionHandler =
      ActionHandler(controllersManager: _controllersManager);

  // Основной метод рендеринга BDUI JSON
  static Widget renderFromJson({
    required Map<String, dynamic> json,
    required BuildContext context,
    VoidCallback? onDataUpdated,
  }) {
    try {
      final model = BDUIScreenModel.fromJson(json);
      return renderBDUIModel(
        model: model.layout,
        context: context,
        onDataUpdated: onDataUpdated,
      );
    } catch (e) {
      return BDUIErrorWidget(message: 'Ошибка парсинга JSON: $e');
    }
  }

  static Widget renderBDUIModel({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
  }) {
    try {
      return BaseRenderer.render(
        model: model,
        context: context,
        onDataUpdated: onDataUpdated,
        controllersManager: _controllersManager,
        actionHandler: _actionHandler,
      );
    } catch (e) {
      return BDUIErrorWidget(
        message: 'Ошибка рендеринга: $e\nТип: ${model.type}',
      );
    }
  }

  static void dispose() {
    _controllersManager.dispose();
  }
}
