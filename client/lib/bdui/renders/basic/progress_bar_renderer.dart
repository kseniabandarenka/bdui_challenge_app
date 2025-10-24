import 'package:flutter/material.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';

class ProgressBarRenderer {
  static Widget render(BDUIElementModel model, BuildContext context,
      VoidCallback? onDataUpdated) {
    try {
      // Для совместимости с JSON структурой, получаем данные из toJson()
      final json = model.toJson();
      final current = (json['current'] as num?)?.toDouble() ?? 0;
      final total = (json['total'] as num?)?.toDouble() ?? 1;
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
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга прогресс-бара: $e');
    }
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
