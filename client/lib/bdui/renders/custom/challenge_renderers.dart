import 'package:client/bdui/actions/action_handler.dart';
import 'package:client/bdui/renders/basic/basic_renderers.dart';
import 'package:client/bdui/utils/controllers_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ChallengeRenderers {
  static Widget render({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    switch (model.type) {
      case BDUIType.challengeCard:
        return _renderChallengeCard(
          model: model as BDUIChallengeCardModel,
          context: context,
          onDataUpdated: onDataUpdated,
          controllersManager: controllersManager,
          actionHandler: actionHandler,
        );
      case BDUIType.challengeList:
        return _renderChallengeList(
          model: model,
          context: context,
          onDataUpdated: onDataUpdated,
          controllersManager: controllersManager,
          actionHandler: actionHandler,
        );
      default:
        throw Exception('Неподдерживаемый тип challenge: ${model.type}');
    }
  }

  static Widget _renderChallengeCard({
    required BDUIChallengeCardModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    return GestureDetector(
      onTap: () {
        actionHandler.handleAction(model.action, context, onDataUpdated);
      },
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
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (model.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  model.description!,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
              ...[
                const SizedBox(height: 12),
                BasicRenderers.renderProgressBar(
                  model: BDUIElementModel(
                    type: BDUIType.progressBar,
                    value: "${model.progressCurrent}/${model.progressTotal}",
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Widget _renderChallengeList({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
    required ControllersManager controllersManager,
    required ActionHandler actionHandler,
  }) {
    return Column(
      children: model.challenges?.map((challenge) {
            return _renderChallengeCard(
              model: challenge,
              context: context,
              onDataUpdated: onDataUpdated,
              controllersManager: controllersManager,
              actionHandler: actionHandler,
            );
          }).toList() ??
          [],
    );
  }
}
