import 'package:client/presentation/navigation/navigation_service.dart';
import 'package:client/presentation/pages/progress_bottom_sheet/bloc/progress_bloc.dart';
import 'package:client/presentation/pages/progress_bottom_sheet/bloc/progress_events.dart';
import 'package:client/presentation/pages/progress_bottom_sheet/progress_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared/shared.dart';
import 'package:client/presentation/bdui/utils/controllers_manager.dart';

class ActionHandler {
  final ControllersManager controllersManager;

  ActionHandler({required this.controllersManager});

  void handleAction(
    BDUIActionData? action,
    BuildContext context,
    VoidCallback? onDataUpdated,
  ) {
    if (action == null) {
      return;
    }

    try {
      switch (action.type) {
        case BDUIActionType.navigate:
          _handleNavigateAction(action, context);
          break;
        case BDUIActionType.trackProgress:
          _handleTrackProgress(action, context, onDataUpdated);
          break;
        case BDUIActionType.showBottomSheet:
          _handleShowBottomSheet(action, context, onDataUpdated);
          break;
      }
    } catch (e) {
      _showErrorSnackbar(context, 'Ошибка выполнения действия: $e');
    }
  }

  void handleActions(
    List<BDUIActionModel>? actions,
    BuildContext context,
    VoidCallback? onDataUpdated,
  ) {
    if (actions != null && actions.isNotEmpty) {
      handleAction(actions.first.action, context, onDataUpdated);
    }
  }

  void _handleNavigateAction(BDUIActionData action, BuildContext context) {
    final screen = action.screen;
    final challengeId = action.challengeId;

    if (screen == BDUIScreenType.challengeDetail && challengeId != null) {
      NavigationService.navigateToChallengeDetail(challengeId);
    }
  }

  void _handleTrackProgress(
    BDUIActionData action,
    BuildContext context,
    VoidCallback? onDataUpdated,
  ) {
    final challengeId = action.challengeId;
    double progress;

    if (action.progressKey != null) {
      final controller =
          controllersManager.getControllerByKey(action.progressKey!);
      if (controller != null && controller.text.isNotEmpty) {
        progress = double.tryParse(controller.text) ?? 0.0;
      } else {
        throw Exception('Поле прогресса пустое');
      }
    } else {
      throw Exception('Не указан источник данных для прогресса');
    }

    // Используем BLoC для сохранения прогресса
    context.read<ProgressBottomSheetBloc>().add(
          SubmitProgressEvent(challengeId ?? "", progress),
        );
  }

  void _handleShowBottomSheet(
    BDUIActionData action,
    BuildContext context,
    VoidCallback? onDataUpdated,
  ) {
    final sheetData = action.sheet;
    final challengeId = action.challengeId;
    if (sheetData != null && challengeId != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => ProgressBottomSheet(
          data: sheetData,
          challengeId: challengeId,
          onDataUpdated: onDataUpdated,
        ),
      );
    }
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
