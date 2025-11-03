import 'package:client/presentation/bdui/renders/custom/challenge_renderers.dart';
import 'package:client/presentation/bdui/utils/controllers_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import 'basic/layout_renderers.dart';
import 'basic/basic_renderers.dart';
import 'basic/input_renderers.dart';
import '../actions/action_handler.dart';

class BaseRenderer {
  static Widget render({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    final type = model.type;

    switch (type) {
      case BDUIType.column:
      case BDUIType.row:
      case BDUIType.container:
        return LayoutRenderers.render(
          model: model,
          context: context,
          onDataUpdated: onDataUpdated,
          controllersManager: controllersManager,
          actionHandler: actionHandler,
        );

      case BDUIType.text:
      case BDUIType.button:
      case BDUIType.progressBar:
        return BasicRenderers.render(
          model: model,
          context: context,
          onDataUpdated: onDataUpdated,
          controllersManager: controllersManager,
          actionHandler: actionHandler,
        );

      case BDUIType.textField:
      case BDUIType.numberInput:
        return InputRenderers.render(
          model: model,
          context: context,
          onDataUpdated: onDataUpdated,
          controllersManager: controllersManager,
          actionHandler: actionHandler,
        );

      case BDUIType.challengeCard:
      case BDUIType.challengeList:
        return ChallengeRenderers.render(
          model: model,
          context: context,
          onDataUpdated: onDataUpdated,
          controllersManager: controllersManager,
          actionHandler: actionHandler,
        );

      }
  }

  static List<Widget> renderChildren({
    required List<BDUIElementModel>? children,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    return children?.map((child) {
          return render(
            model: child,
            context: context,
            onDataUpdated: onDataUpdated,
            controllersManager: controllersManager,
            actionHandler: actionHandler,
          );
        }).toList() ??
        [];
  }
}
