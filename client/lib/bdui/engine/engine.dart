import 'dart:convert';
import 'package:client/bdui/models/action_type.dart';
import 'package:client/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared/shared.dart';

class BDUIEngine {
  static final Map<String, TextEditingController> _textControllers = {};

  // Основной метод рендеринга BDUI JSON
  static Widget renderFromJson({
    required Map<String, dynamic> json,
    required BuildContext context,
    VoidCallback? onDataUpdated,
  }) {
    final model = BDUIScreenModel.fromJson(json);
    
    return renderBDUIModel(
      model: model.layout, 
      context: context, 
      onDataUpdated: onDataUpdated
    );
  } 

  static Widget renderBDUIModel({
    required BDUIElementModel model,
    required BuildContext context,
    VoidCallback? onDataUpdated,
  }) {
    try {
      final type = model.type;
      
      switch (type) {
        case BDUIType.column:
          return _renderColumn(model, context, onDataUpdated);
        case BDUIType.container:
          return _renderContainer(model, context, onDataUpdated);
        case BDUIType.row:
          return _renderRow(model, context, onDataUpdated);
        case BDUIType.text:
          return _renderText(model);
        case BDUIType.button:
          return _renderButton(model, context, onDataUpdated);
        case BDUIType.progressBar:
          return _renderProgressBar(model);
        case BDUIType.challengeCard:
          return _renderChallengeCard(model, context, onDataUpdated);
        case BDUIType.challengeList:
          return _renderChallengeList(model, context, onDataUpdated);
        case BDUIType.textField:
          return _renderTextField(model);
        case BDUIType.numberInput:
          return _renderNumberInput(model);
      }
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга: $e\nТип: ${model.type}');
    }
  }

  // 📦 МЕТОДЫ РЕНДЕРИНГА

  static Widget _renderColumn(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _renderChildren(model.children, context, onDataUpdated),
    );
  }

  static Widget _renderContainer(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    return Container(
      decoration: BoxDecoration(
        color: _parseColor(model.decoration?.color),
        borderRadius: model.decoration?.borderRadius != null 
            ? BorderRadius.circular(model.decoration!.borderRadius!.all?.toDouble() ?? 0)
            : null,
      ),
      padding: _parseBDUIPadding(model.decoration?.padding),
      margin: _parseBDUIPadding(model.decoration?.margin),
      child: model.child != null 
          ? renderBDUIModel(
              model: model.child!, 
              context: context,
              onDataUpdated: onDataUpdated,
            )
          : (model.children != null 
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _renderChildren(model.children!, context, onDataUpdated),
                )
              : null),
    );
  }

  static Widget _renderRow(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    return Row(
      children: _renderChildren(model.children, context, onDataUpdated),
    );
  }

  static Widget _renderText(BDUIElementModel model) {
    return Text(
      model.value ?? '',
      style: TextStyle(
        fontSize: model.style?.fontSize ?? 16,
        fontWeight: _parseFontWeight(model.style?.fontWeight),
        color: _parseColor(model.style?.color),
      ),
    );
  }

  static Widget _renderButton(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleActions(model.actions, context, onDataUpdated),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _parseColor(model.decoration?.color),
                  foregroundColor: _parseColor(model.style?.color),
                  padding: _parseBDUIPadding(model.decoration?.padding),
                ),
                child: Text(model.value ?? 'Кнопка'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _renderProgressBar(BDUIElementModel model) {
    // Парсим значение прогресса из value в формате "current/total"
    final progressParts = model.value?.split('/') ?? ['0', '1'];
    final current = double.tryParse(progressParts[0]) ?? 0;
    final total = double.tryParse(progressParts[1]) ?? 1;
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
  }

  static Widget _renderTextField(BDUIElementModel model) {
    final key = model.value ?? 'field_${DateTime.now().millisecondsSinceEpoch}';
    
    _textControllers[key] ??= TextEditingController(
      text: model.value ?? ''
    );
    
    return TextField(
      controller: _textControllers[key]!,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: model.value,
        hintText: model.value,
        border: const OutlineInputBorder(),
      ),
    );
  }

  static Widget _renderChallengeCard(BDUIChallengeCardModel model, BuildContext context, VoidCallback? onDataUpdated) {
    return GestureDetector(
      onTap: () {
        _handleActions([model.action], context, onDataUpdated);
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
                    model.value ?? '🎯',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const Spacer(),
                  if (model.challenges?.isNotEmpty == true && model.challenges!.first.completed == true)
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                model.value ?? 'Без названия',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (model.challenges?.isNotEmpty == true && model.challenges!.first.description != null) ...[
                const SizedBox(height: 8),
                Text(
                  model.challenges!.first.description!,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
              if (model.challenges?.isNotEmpty == true && 
                  model.challenges!.first.progressCurrent != null && 
                  model.challenges!.first.progressTotal != null) ...[
                const SizedBox(height: 12),
                _renderProgressBar(BDUIElementModel(
                  type: BDUIType.progressBar,
                  value: '${model.challenges!.first.progressCurrent}/${model.challenges!.first.progressTotal}',
                )),
              ],
              if (model.actions != null) ...[
                const SizedBox(height: 12),
                ..._renderActions(model.actions!, context, onDataUpdated),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static Widget _renderChallengeList(BDUIElementModel model, BuildContext context, VoidCallback? onDataUpdated) {
    return Column(
      children: model.challenges?.map((challenge) {
        return _renderChallengeCard(BDUIElementModel(
          type: BDUIType.challengeCard,
          value: challenge.title,
          challenges: [challenge],
          actions: challenge.actions,
        ), context, onDataUpdated);
      }).toList() ?? [],
    );
  }

  static Widget _renderNumberInput(BDUIElementModel model) {
    final key = model.value ?? 'number_${DateTime.now().millisecondsSinceEpoch}';
    
    _textControllers[key] ??= TextEditingController(
      text: model.value ?? ''
    );

    return TextFormField(
      controller: _textControllers[key]!,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: model.value,
        hintText: model.value,
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.numbers),
      ),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          final number = double.tryParse(value);
          if (number == null) return 'Введите число';
        }
        return null;
      },
    );
  }

  // 🛠️ ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ

  static List<Widget> _renderChildren(List<BDUIElementModel>? children, BuildContext context, VoidCallback? onDataUpdated) {
    return children?.map((child) {
      return renderBDUIModel(
        model: child, 
        context: context,
        onDataUpdated: onDataUpdated,
      );
    }).toList() ?? [];
  }

  static List<Widget> _renderActions(List<BDUIActionModel> actions, BuildContext context, VoidCallback? onDataUpdated) {
    return actions.map((action) {
      return ElevatedButton(
        onPressed: () => _handleAction(action.action, context, onDataUpdated),
        child: Text(action.text ?? 'Действие'),
      );
    }).toList();
  }

  static void _handleActions(List<BDUIActionModel>? actions, BuildContext context, VoidCallback? onDataUpdated) {
    if (actions != null && actions.isNotEmpty) {
      _handleAction(actions.first.action, context, onDataUpdated);
    }
  }

  static void _handleAction(BDUIActionData? action, BuildContext context, VoidCallback? onDataUpdated) {
    print('🔍 BDUI Action received: $action');
    
    if (action == null) {
      print('⚠️ Действие не указано');
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
        default:
          print('⚠️ Необработанное действие: ${action.type}');
      }
    } catch (e) {
      print('❌ Ошибка обработки действия: $e');
    }
  }

  static void _handleShowBottomSheet(BDUIActionData action, BuildContext context, VoidCallback? onDataUpdated) {
    final sheetData = action.sheet;
    if (sheetData != null) {
      _showCustomBottomSheet(sheetData, context, onDataUpdated);
    }
  }

  static void _showCustomBottomSheet(BDUIElementModel sheetData, BuildContext context, VoidCallback? onDataUpdated) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetContent(sheetData, context, onDataUpdated),
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
            if (data.value != null) ...[
              Text(
                data.value!,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
            ],
            renderBDUIModel(
              model: data, 
              context: context,
              onDataUpdated: onDataUpdated,
            ),
          ],
        ),
      ),
    );
  }

  static void _handleNavigateAction(BDUIActionData action, BuildContext context) {
    final screen = action.screen;
    final challengeId = action.challengeId;
    
    print('🧭 Навигация на: $screen, challenge: $challengeId');
    
    if (screen == BDUIScreenType.challengeDetail && challengeId != null) {
      NavigationService.navigateToChallengeDetail(challengeId);
    }
  }

  static void _handleTrackProgress(BDUIActionData action, BuildContext context, VoidCallback? onDataUpdated) async {
    try {
      final challengeId = action.challengeId;
      double progress;

      // if (action.progress != null) {
      //   progress = action.progress!.toDouble();
      // } else if (action.progressKey != null) {
      //   final controller = _textControllers[action.progressKey!];
      //   if (controller != null && controller.text.isNotEmpty) {
      //     progress = double.tryParse(controller.text) ?? 0.0;
      //   } else {
      //     throw Exception('Поле прогресса пустое');
      //   }
      // } else {
      //   throw Exception('Не указан источник данных для прогресса');
      // }

 //     print('💾 Сохранение прогресса: $progress для челленджа $challengeId');

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

      final success = await _saveProgressToAPI(challengeId!, 10);//progress);
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

  static void dispose() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    _textControllers.clear();
  }

  static EdgeInsets? _parseBDUIPadding(BDUIPadding? padding) {
    if (padding != null) {
      return EdgeInsets.only(
        left: padding.left?.toDouble() ?? 0.0,
        top: padding.top?.toDouble() ?? 0.0,
        right: padding.right?.toDouble() ?? 0.0,
        bottom: padding.bottom?.toDouble() ?? 0.0,
      );
    }
    return null;
  }

  static Color? _parseColor(String? color) {
    if (color != null) {
      try {
        return Color(int.parse(color.replaceFirst('#', '0xff')));
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static FontWeight _parseFontWeight(BDUIFontWeight? fontWeight) {
    switch (fontWeight) {
      case BDUIFontWeight.bold:
        return FontWeight.bold;
      case BDUIFontWeight.normal:
      default:
        return FontWeight.normal;
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