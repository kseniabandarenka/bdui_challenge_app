import 'dart:convert';
import 'package:client/presentation/bdui/engine/engine.dart';
import 'package:client/presentation/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
      print('Действие не указано');
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
      print('❌ Ошибка обработки действия: $e');
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

  // 📍 МЕТОДЫ ОБРАБОТКИ ДЕЙСТВИЙ

  void _handleNavigateAction(BDUIActionData action, BuildContext context) {
    final screen = action.screen;
    final challengeId = action.challengeId;

    print('🧭 Навигация на: $screen, challenge: $challengeId');

    if (screen == BDUIScreenType.challengeDetail && challengeId != null) {
      NavigationService.navigateToChallengeDetail(challengeId);
    }
  }

  void _handleTrackProgress(
    BDUIActionData action,
    BuildContext context,
    VoidCallback? onDataUpdated,
  ) async {
    try {
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

      print('💾 Сохранение прогресса: $progress для челленджа $challengeId');

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(width: 12),
              Text('Сохранение прогресса...'),
            ],
          ),
          duration: Duration(seconds: 30),
        ),
      );

      final success = await _saveProgressToAPI(challengeId!, progress);
      scaffoldMessenger.hideCurrentSnackBar();

      if (success) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('✅ Прогресс успешно сохранен!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();

        // 🔄 ВЫЗЫВАЕМ CALLBACK ДЛЯ ОБНОВЛЕНИЯ ДАННЫХ
        onDataUpdated?.call();
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('❌ Ошибка сохранения прогресса'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Ошибка сохранения прогресса: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Ошибка: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleShowBottomSheet(
    BDUIActionData action,
    BuildContext context,
    VoidCallback? onDataUpdated,
  ) {
    final sheetData = action.sheet;
    if (sheetData != null) {
      _showCustomBottomSheet(sheetData, context, onDataUpdated);
    }
  }

  void _showCustomBottomSheet(
    BDUIElementModel sheetData,
    BuildContext context,
    VoidCallback? onDataUpdated,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          _buildBottomSheetContent(sheetData, context, onDataUpdated),
    );
  }

  Widget _buildBottomSheetContent(
    BDUIElementModel data,
    BuildContext context,
    VoidCallback? onDataUpdated,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (data.value != null) ...[
              Text(
                data.value!,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
            ],
            // Используем BDUIEngine для рендеринга контента bottom sheet
            BDUIEngine.renderBDUIModel(
              model: data,
              context: context,
              onDataUpdated: onDataUpdated,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _saveProgressToAPI(String challengeId, double progress) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/challenges/$challengeId/progress'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'progress': progress}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('API Error: $e');
      return false;
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
