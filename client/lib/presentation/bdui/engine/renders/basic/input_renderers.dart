import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

import '../../../utils/controllers_manager.dart';
import '../../actions/action_handler.dart';

class InputRenderers {
  static Widget render({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    switch (model.type) {
      case BDUIType.textField:
        return _renderTextField(
          model: model,
          controllersManager: controllersManager,
        );
      case BDUIType.numberInput:
        return _renderNumberInput(
          model: model,
          controllersManager: controllersManager,
        );
      default:
        throw Exception('Неподдерживаемый тип input: ${model.type}');
    }
  }

  static Widget _renderTextField({
    required BDUIElementModel model,
    required ControllersManager controllersManager,
  }) {
    final key = model.key ?? 'field_${DateTime.now().millisecondsSinceEpoch}';
    final controller = controllersManager.getController(key, model.value ?? '');

    return TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: model.value,
        hintText: model.value,
        border: const OutlineInputBorder(),
      ),
    );
  }

  static Widget _renderNumberInput({
    required BDUIElementModel model,
    required ControllersManager controllersManager,
  }) {
    final key = model.key ?? 'number_${DateTime.now().millisecondsSinceEpoch}';
    final controller = controllersManager.getController(key, model.value ?? '');

    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: model.value,
        hintText: model.value,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.numbers),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final number = double.tryParse(value);
          if (number == null) return 'Введите число';
        }
        return null;
      },
    );
  }
}
