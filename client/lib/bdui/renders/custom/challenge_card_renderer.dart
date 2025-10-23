import 'package:client/bdui/actions/bdui_action_service.dart';
import 'package:client/bdui/engine/engine.dart';
import 'package:client/bdui/renders/basic/progress_bar_renderer.dart';
import 'package:flutter/material.dart';

class ChallengeCardRenderer {
  static Widget render(Map<String, dynamic> json, BuildContext context, VoidCallback? onDataUpdated) {
    try {
      final action = json['action'];
      
      return GestureDetector(
        onTap: () => BDUIActionService.handleAction(action, context, onDataUpdated),
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
                      json['category'] ?? '🎯',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Spacer(),
                    if (json['completed'] == true)
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  json['title'] ?? 'Без названия',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                if (json['description'] != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    json['description']!,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
                if (json['progressCurrent'] != null && json['progressTotal'] != null) ...[
                  const SizedBox(height: 12),
                  ProgressBarRenderer.render({
                    'current': json['progressCurrent'],
                    'total': json['progressTotal'],
                  }, context, onDataUpdated),
                ],
                if (json['actions'] != null) ...[
                  const SizedBox(height: 12),
                  ..._renderChildren(json['actions'], context, onDataUpdated),
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

  static List<Widget> _renderChildren(List<dynamic>? children, BuildContext context, VoidCallback? onDataUpdated) {
    return children?.map((child) {
      return BDUIEngine.renderFromJson(
        json: child as Map<String, dynamic>, 
        context: context,
        onDataUpdated: onDataUpdated,
      );
    }).toList() ?? [];
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