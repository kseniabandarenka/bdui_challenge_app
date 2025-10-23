import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldRenderer {
  static Widget render(Map<String, dynamic> json, BuildContext context, VoidCallback? onDataUpdated) {
    try {
      final key = json['key'] as String? ?? 'field_${DateTime.now().millisecondsSinceEpoch}';
      
      _textControllers[key] ??= TextEditingController(
        text: json['value']?.toString() ?? ''
      );
      
      return TextField(
        controller: _textControllers[key]!,
        keyboardType: json['keyboard_type'] == 'number' 
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        inputFormatters: json['keyboard_type'] == 'number' 
            ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}$'))]
            : null,
        decoration: InputDecoration(
          labelText: json['label'],
          hintText: json['placeholder'],
          border: const OutlineInputBorder(),
        ),
      );
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга текстового поля: $e');
    }
  }

  static final Map<String, TextEditingController> _textControllers = {};

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