import 'package:client/bdui/actions/bdui_action_service.dart';
import 'package:client/bdui/engine/engine.dart';
import 'package:client/bdui/renders/basic/progress_bar_renderer.dart';
import 'package:flutter/material.dart';
import 'package:shared/data/models/bdui/bdui_action_model.dart';
import 'package:shared/data/models/bdui/bdui_challenge_card_model.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';
import 'package:shared/data/models/bdui/bdui_type_model.dart';

class ChallengeCardRenderer {
  static Widget render(BDUIChallengeCardModel model, BuildContext context,
      VoidCallback? onDataUpdated) {
    try {
      return GestureDetector(
        onTap: () => BDUIActionService.handleAction(
            model.action, context, onDataUpdated),
        child: Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      model.category ?? '🎯',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Spacer(),
                    if (model.completed == true)
                      const Icon(Icons.check_circle,
                          color: Colors.green, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  model.title ?? 'Без названия',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (model.description != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    model.description!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
                if (model.progressCurrent != null &&
                    model.progressTotal != null) ...[
                  const SizedBox(height: 12),
                  // Используем ProgressBarRenderer правильно
                  ProgressBarRenderer.render(
                    BDUIElementModel(
                      type: BDUIType.progressBar,
                      current: model.progressCurrent,
                      total: model.progressTotal,
                    ),
                    context,
                    onDataUpdated,
                  ),
                ],
                ],
            ),
          ),
        ),
      );
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга карточки челленджа: $e');
    }
  }

  static List<Widget> _renderChildren(List<BDUIActionModel>? children,
      BuildContext context, VoidCallback? onDataUpdated) {
    return children?.map((child) {
          if (child is BDUIElementModel) {
            return BDUIEngine.renderFromModel(
              model: child,
              context: context,
              onDataUpdated: onDataUpdated,
            );
          }
          return Container();
        }).toList() ??
        [];
  }


}
