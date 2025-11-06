import 'package:client/presentation/bdui/engine/actions/action_handler.dart';
import 'package:client/presentation/bdui/utils/error_widget.dart';
import 'package:client/presentation/bdui/engine/renders/base_renderer.dart';
import 'package:client/presentation/bdui/utils/controllers_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class BDUIEngine {
  static final _controllersManager = ControllersManager();
  static final _actionHandler =
      ActionHandler(controllersManager: _controllersManager);

  // Основной метод рендеринга BDUI JSON
  static Widget renderFromScreenModel({
    required BDUIScreenModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
  }) {
    try {
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
