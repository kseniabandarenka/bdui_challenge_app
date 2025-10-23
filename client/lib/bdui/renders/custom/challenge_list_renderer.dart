import 'package:client/bdui/engine/engine.dart';
import 'package:flutter/material.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';

class ChallengeListRenderer {
  static Widget render(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    try {
      final challenges = model.challenges;

      return Column(
        children: challenges?.map((challenge) {
          return BDUIEngine.renderFromModel(
            model: challenge,
            context: context,
            onDataUpdated: onDataUpdated,
          );
        }).toList() ?? [],
      );
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга списка челленджей: $e');
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