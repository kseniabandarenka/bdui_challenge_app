import 'package:client/bdui/engine/engine.dart';
import 'package:client/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared/shared.dart';

class BDUIActionService {
  static final Map<String, TextEditingController> _textControllers = {};

  static void handleAction(dynamic action, BuildContext context, VoidCallback? onDataUpdated) {
    if (action is! Map<String, dynamic>) return;
    
    try {
      final actionData = BDUIActionData.fromJson(action);
      
      switch (actionData.type) {
        case BDUIActionType.navigate:
          _handleNavigateAction(actionData, context);
          break;
        case BDUIActionType.trackProgress:
          _handleTrackProgressAction(actionData, context, onDataUpdated);
          break;
        case BDUIActionType.showBottomSheet:
          _handleShowBottomSheetAction(actionData, context, onDataUpdated);
          break;
      }
    } catch (e) {
      print('Ошибка обработки действия: $e');
    }
  }

  static void _handleNavigateAction(BDUIActionData action, BuildContext context) {
    final screen = action.screen;
    final challengeId = action.challengeId;
    
    print('🧭 Навигация на: $screen, challenge: $challengeId');
    
    if (screen == 'challenge_detail' && challengeId != null) {
       NavigationService.navigateToChallengeDetail(challengeId);
    }
  }

  static void _handleTrackProgressAction(BDUIActionData action, BuildContext context, VoidCallback? onDataUpdated) async {
    try {
      final challengeId = action.challengeId;
      double progress;

      if (action.progressKey != null) {
        final fieldKey = action.progressKey!;
        final controller = _textControllers[fieldKey];
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

  static void _handleShowBottomSheetAction(BDUIActionData action, BuildContext context, VoidCallback? onDataUpdated) {
    final sheet = action.sheet;
    if (sheet != null) {
      _showCustomBottomSheet(sheet, context, onDataUpdated);
    }
  }

  static void _showCustomBottomSheet(BDUIElementModel sheet, BuildContext context, VoidCallback? onDataUpdated) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetContent(sheet, context, onDataUpdated),
    );
  }

  static Widget _buildBottomSheetContent(BDUIElementModel data, BuildContext context, VoidCallback? onDataUpdated) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Отметить прогресс',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            BDUIEngine.renderFromJson(
              json: data.toJson(), 
              context: context,
              onDataUpdated: onDataUpdated,
            ),
          ],
        ),
      ),
    );
  }

  static Future<bool> _saveProgressToAPI(String challengeId, double progress) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/challenges/$challengeId/progress'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'progress': progress}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('❌ API Error: $e');
      return false;
    }
  }

  static TextEditingController getTextController(String key, String defaultValue) {
    _textControllers[key] ??= TextEditingController(text: defaultValue);
    return _textControllers[key]!;
  }

  static void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    _textControllers.clear();
  }
}