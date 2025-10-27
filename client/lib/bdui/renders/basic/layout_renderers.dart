import 'package:client/bdui/renders/base_renderer.dart';
import 'package:client/bdui/utils/controllers_manager.dart';
import 'package:client/bdui/actions/action_handler.dart';
import 'package:client/bdui/utils/parsers.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class LayoutRenderers {
  static Widget render({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    switch (model.type) {
      case BDUIType.column:
        return _renderColumn(
          model: model,
          context: context,
          onDataUpdated: onDataUpdated,
          controllersManager: controllersManager,
          actionHandler: actionHandler,
        );
      case BDUIType.row:
        return _renderRow(
          model: model,
          context: context,
          onDataUpdated: onDataUpdated,
          controllersManager: controllersManager,
          actionHandler: actionHandler,
        );
      case BDUIType.container:
        return _renderContainer(
          model: model,
          context: context,
          onDataUpdated: onDataUpdated,
          controllersManager: controllersManager,
          actionHandler: actionHandler,
        );
      default:
        throw Exception('Неподдерживаемый тип layout: ${model.type}');
    }
  }

  static Widget _renderColumn({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: BaseRenderer.renderChildren(
        children: model.children,
        context: context,
        onDataUpdated: onDataUpdated,
        controllersManager: controllersManager,
        actionHandler: actionHandler,
      ),
    );
  }

  static Widget _renderRow({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    return Row(
      children: BaseRenderer.renderChildren(
        children: model.children,
        context: context,
        onDataUpdated: onDataUpdated,
        controllersManager: controllersManager,
        actionHandler: actionHandler,
      ),
    );
  }

  static Widget _renderContainer({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Parsers.parseColor(model.decoration?.color),
        borderRadius: model.decoration?.borderRadius != null
            ? BorderRadius.circular(
                model.decoration!.borderRadius!.all?.toDouble() ?? 0)
            : null,
      ),
      padding: Parsers.parseBDUIPadding(model.decoration?.padding),
      margin: Parsers.parseBDUIPadding(model.decoration?.margin),
      child: model.child != null
          ? BaseRenderer.render(
              model: model.child!,
              context: context,
              onDataUpdated: onDataUpdated,
              controllersManager: controllersManager,
              actionHandler: actionHandler,
            )
          : (model.children != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: BaseRenderer.renderChildren(
                    children: model.children!,
                    context: context,
                    onDataUpdated: onDataUpdated,
                    controllersManager: controllersManager,
                    actionHandler: actionHandler,
                  ),
                )
              : null),
    );
  }
}
