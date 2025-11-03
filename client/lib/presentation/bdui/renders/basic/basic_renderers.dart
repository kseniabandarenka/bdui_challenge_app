import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../../actions/action_handler.dart';
import '../../utils/parsers.dart';
import '../../utils/controllers_manager.dart';

class BasicRenderers {
  static Widget render({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    switch (model.type) {
      case BDUIType.text:
        return renderText(model: model);
      case BDUIType.button:
        return renderButton(
          model: model,
          context: context,
          onDataUpdated: onDataUpdated,
          actionHandler: actionHandler,
        );
      case BDUIType.progressBar:
        return renderProgressBar(model: model);
      default:
        throw Exception('Неподдерживаемый тип basic: ${model.type}');
    }
  }

  static Widget renderText({
    required BDUIElementModel model,
  }) {
    return Text(
      model.value ?? '',
      style: TextStyle(
        fontSize: model.style?.fontSize ?? 16,
        fontWeight: Parsers.parseFontWeight(model.style?.fontWeight),
        color: Parsers.parseColor(model.style?.color),
      ),
    );
  }

  static Widget renderButton({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ActionHandler actionHandler,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => actionHandler.handleActions(
                  model.actions,
                  context,
                  onDataUpdated,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Parsers.parseColor(model.decoration?.color),
                  foregroundColor: Parsers.parseColor(model.style?.color),
                  padding: Parsers.parseBDUIPadding(model.decoration?.padding),
                ),
                child: Text(model.value ?? 'Кнопка'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget renderProgressBar({
    required BDUIElementModel model,
  }) {
    final progressParts = model.value?.split('/') ?? ['0', '1'];
    final current = double.tryParse(progressParts[0]) ?? 0;
    final total = double.tryParse(progressParts[1]) ?? 1;
    final progress = current / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 1.0 ? Colors.green : Colors.blue,
          ),
        ),
        const SizedBox(height: 4),
        Text('${current.toInt()}/${total.toInt()}'),
      ],
    );
  }
}
