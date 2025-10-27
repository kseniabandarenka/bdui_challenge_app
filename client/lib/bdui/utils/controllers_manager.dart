import 'package:flutter/material.dart';

class ControllersManager {
  final Map<String, TextEditingController> _controllers = {};

  TextEditingController getController(String key, String initialValue) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = TextEditingController(text: initialValue);
    } else if (_controllers[key]!.text != initialValue) {
      _controllers[key]!.text = initialValue;
    }
    return _controllers[key]!;
  }

  TextEditingController? getControllerByKey(String key) {
    return _controllers[key];
  }

  void updateControllerValue(String key, String value) {
    final controller = _controllers[key];
    if (controller != null && controller.text != value) {
      controller.text = value;
    }
  }

  void disposeController(String key) {
    _controllers[key]?.dispose();
    _controllers.remove(key);
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}
