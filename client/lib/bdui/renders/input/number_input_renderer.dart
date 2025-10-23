import 'package:flutter/material.dart';

class NumberInputRenderer {
  static Widget render(Map<String, dynamic> json, BuildContext context, VoidCallback? onDataUpdated) {
    try {
      final key = json['key'] as String? ?? 'number_${DateTime.now().millisecondsSinceEpoch}';
      
      _textControllers[key] ??= TextEditingController(
        text: json['value']?.toString() ?? ''
      );

      return TextFormField(
        controller: _textControllers[key]!,
        keyboardType: TextInputType.numberWithOptions(decimal: json['decimal'] == true),
        decoration: InputDecoration(
          labelText: json['label'],
          hintText: json['placeholder'],
          border: const OutlineInputBorder(),
          prefixText: json['prefix'] as String?,
          suffixText: json['suffix'] as String?,
          prefixIcon: const Icon(Icons.numbers),
        ),
        validator: (value) {
          if (json['required'] == true && (value == null || value.isEmpty)) {
            return 'Обязательное поле';
          }
          if (value != null && value.isNotEmpty) {
            final number = double.tryParse(value);
            if (number == null) return 'Введите число';
            if (json['min'] != null && number < (json['min'] as num).toDouble()) {
              return 'Минимум: ${json['min']}';
            }
            if (json['max'] != null && number > (json['max'] as num).toDouble()) {
              return 'Максимум: ${json['max']}';
            }
          }
          return null;
        },
      );
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга числового поля: $e');
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