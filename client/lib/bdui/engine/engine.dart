import 'dart:convert';
import 'package:client/bdui/models/action_type.dart';
import 'package:client/navigation/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared/data/models/bdui/bdui_type_model.dart';

class BDUIEngine {
  static final Map<String, TextEditingController> _textControllers = {};

  // Основной метод рендеринга BDUI JSON
  static Widget renderFromJson({
    required Map<String, dynamic> json,
    required BuildContext context,
    VoidCallback? onDataUpdated,
  }) {
    final typeString = json['type'] as String?;
    
    // 🔥 ОБРАБОТКА ТИПА 'screen' С LAYOUT
    if (typeString == 'screen') {
      final layout = json['layout'];
      if (layout != null && layout is Map<String, dynamic>) {
        return renderFromJson(
          json: layout, 
          context: context, 
          onDataUpdated: onDataUpdated
        );
      }
    }
    
    if (typeString == null) {
      return _buildErrorWidget('Отсутствует тип виджета в данных: ${json.keys}');
    }

    try {
      final type = BDUIType.fromJson() .fromString(typeString);
      
      switch (type) {
        case BDUIType.column:
          return _renderColumn(json, context, onDataUpdated);
        case BDUIType.container:
          return _renderContainer(json, context, onDataUpdated);
        case BDUIType.row:
          return _renderRow(json, context, onDataUpdated);
        case BDUIType.text:
          return _renderText(json);
        case BDUIType.button:
          return _renderButton(json, context, onDataUpdated);
        case BDUIType.progressBar:
          return _renderProgressBar(json);
        case BDUIType.challengeCard:
          return _renderChallengeCard(json, context, onDataUpdated);
        case BDUIType.challengeList:
          return _renderChallengeList(json, context, onDataUpdated);
        case BDUIType.textField:
          return _renderTextField(json);
        case BDUIType.numberInput:
          return _renderNumberInput(json);
        }
    } catch (e) {
      return _buildErrorWidget('Ошибка рендеринга: $e\nДанные: $json');
    }
  }

  // 📦 МЕТОДЫ РЕНДЕРИНГА

  static Widget _renderColumn(Map<String, dynamic> json, BuildContext context, VoidCallback? onDataUpdated) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _renderChildren(json['children'], context, onDataUpdated),
    );
  }

  static Widget _renderContainer(Map<String, dynamic> json, BuildContext context, VoidCallback? onDataUpdated) {
    final decoration = json['decoration'] as Map<String, dynamic>?;
    final child = json['child'] as Map<String, dynamic>?;
    final children = json['children'] as List<dynamic>?;

    return Container(
      decoration: BoxDecoration(
        color: _parseColor(decoration?['color']),
        borderRadius: decoration?['borderRadius'] != null 
            ? BorderRadius.circular((decoration!['borderRadius'] as num).toDouble())
            : null,
      ),
      padding: _parseEdgeInsets(decoration?['padding']),
      margin: _parseEdgeInsets(decoration?['margin']),
      child: child != null 
          ? renderFromJson(
              json: child, 
              context: context,
              onDataUpdated: onDataUpdated,
            )
          : (children != null 
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _renderChildren(children, context, onDataUpdated),
                )
              : null),
    );
  }

  static Widget _renderRow(Map<String, dynamic> json, BuildContext context, VoidCallback? onDataUpdated) {
    return Row(
      children: _renderChildren(json['children'], context, onDataUpdated),
    );
  }

  static Widget _renderText(Map<String, dynamic> json) {
    return Text(
      json['value'] ?? '',
      style: TextStyle(
        fontSize: (json['style']?['fontSize'] as num?)?.toDouble() ?? 16,
        fontWeight: json['style']?['fontWeight'] == 'bold' 
            ? FontWeight.bold 
            : FontWeight.normal,
        color: _parseColor(json['style']?['color']),
      ),
    );
  }

  static Widget _renderButton(Map<String, dynamic> json, BuildContext context, VoidCallback? onDataUpdated) {
    final style = json['style'] as Map<String, dynamic>?;
    
    return Center(
      child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _handleAction(json['action'], context, onDataUpdated),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _parseColor(style?['backgroundColor']),
                  foregroundColor: _parseColor(style?['textColor']),
                  padding: _parseEdgeInsets(style?['padding']),
                ),
                child: Text(json['text'] ?? 'Кнопка'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _renderProgressBar(Map<String, dynamic> json) {
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
  }

  static Widget _renderTextField(Map<String, dynamic> json) {
    final key = json['key'] as String? ?? 'field_${DateTime.now().millisecondsSinceEpoch}';
    
    _textControllers[key] ??= TextEditingController(
      text: json['value']?.toString() ?? ''
    );
    
    return TextField(
  controller: _textControllers[key]!,
  keyboardType: json['keyboard_type'] == 'number' 
      ? const TextInputType.numberWithOptions(decimal: true)
      : TextInputType.text,
  inputFormatters: json['keyboard_type'] == 'number' 
      ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}$'))]
      : null,
  decoration: InputDecoration(
    labelText: json['label'],
    hintText: json['placeholder'],
    border: const OutlineInputBorder(),
  ),
);
  }

  static Widget _renderChallengeCard(Map<String, dynamic> json, BuildContext context, VoidCallback? onDataUpdated) {
    return GestureDetector(
      onTap: () {
        final action = json['action'];
        if (action != null) {
          _handleAction(action, context, onDataUpdated);
        }
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
                _renderProgressBar({
                  'current': json['progressCurrent'],
                  'total': json['progressTotal'],
                }),
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
  }

  static Widget _renderChallengeList(Map<String, dynamic> json, BuildContext context, VoidCallback? onDataUpdated) {
    final challenges = json['challenges'] as List<dynamic>?;
    
    return Column(
      children: challenges?.map((challenge) {
        return _renderChallengeCard(challenge as Map<String, dynamic>, context, onDataUpdated);
      }).toList() ?? [],
    );
  }

  // 🛠️ ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ

  static List<Widget> _renderChildren(List<dynamic>? children, BuildContext context, VoidCallback? onDataUpdated) {
    return children?.map((child) {
      return renderFromJson(
        json: child as Map<String, dynamic>, 
        context: context,
        onDataUpdated: onDataUpdated,
      );
    }).toList() ?? [];
  }

  static void _handleAction(dynamic action, BuildContext context, VoidCallback? onDataUpdated) {
    print('🔍 BDUI Action received: $action');
    
    if (action is Map<String, dynamic>) {
      final typeString = action['type'] as String?;
      
      if (typeString == null) {
        print('⚠️ Действие без типа: $action');
        return;
      }

      try {
        final actionType = ActionTypeExtension.fromString(typeString);
        
        switch (actionType) {
          case ActionType.navigate:
            _handleNavigateAction(action, context);
            break;
          case ActionType.trackProgress:
            _handleTrackProgress(action, context, onDataUpdated);
            break;
          case ActionType.showBottomSheet:
            _handleShowBottomSheet(action, context, onDataUpdated);
            break;
          default:
            print('⚠️ Необработанное действие: $actionType');
        }
      } catch (e) {
        print('❌ Ошибка обработки действия: $e');
      }
    }
  }

  static void _handleShowBottomSheet(Map<String, dynamic> action, BuildContext context, VoidCallback? onDataUpdated) {
    final sheetData = action['sheet'];
    _showCustomBottomSheet(sheetData, context, onDataUpdated);
  }

  static void _showCustomBottomSheet(Map<String, dynamic> sheetData, BuildContext context, VoidCallback? onDataUpdated) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildBottomSheetContent(sheetData, context, onDataUpdated),
    );
  }

  static Widget _buildBottomSheetContent(Map<String, dynamic> data, BuildContext context, VoidCallback? onDataUpdated) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data['title'] ?? 'Отметить прогресс',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            renderFromJson(
              json: data['child'], 
              context: context,
              onDataUpdated: onDataUpdated,
            ),
          ],
        ),
      ),
    );
  }

  static void _handleNavigateAction(Map<String, dynamic> action, BuildContext context) {
    final screen = action['screen'] as String?;
    final challengeId = action['challenge_id'] as String?;
    
    print('🧭 Навигация на: $screen, challenge: $challengeId');
    
    if (screen == 'challenge_detail' && challengeId != null) {
      // Используй свою навигацию здесь
      NavigationService.navigateToChallengeDetail(challengeId);
    }
  }

   static Widget _renderNumberInput(Map<String, dynamic> json) {
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
  }


  static void _handleTrackProgress(Map<String, dynamic> action, BuildContext context, VoidCallback? onDataUpdated) async {
    try {
      final challengeId = action['challenge_id'];
      double progress;

      if (action.containsKey('progress')) {
        progress = (action['progress'] as num).toDouble();
      } else if (action.containsKey('progress_key')) {
        final fieldKey = action['progress_key'];
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
        SnackBar(
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

      final success = await _saveProgressToAPI(challengeId, progress);
      scaffoldMessenger.hideCurrentSnackBar();

      if (success) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('✅ Прогресс успешно сохранен!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.of(context).pop();

        // 🔄 ВЫЗЫВАЕМ CALLBACK ДЛЯ ОБНОВЛЕНИЯ ДАННЫХ
        onDataUpdated?.call();

      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(
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

  static EdgeInsets? _parseEdgeInsets(dynamic padding) {
    if (padding is Map<String, dynamic>) {
      return EdgeInsets.only(
        left: (padding['left'] as num?)?.toDouble() ?? 0,
        top: (padding['top'] as num?)?.toDouble() ?? 0,
        right: (padding['right'] as num?)?.toDouble() ?? 0,
        bottom: (padding['bottom'] as num?)?.toDouble() ?? 0,
      );
    }
    return null;
  }

  static Color? _parseColor(dynamic color) {
    if (color is String) {
      try {
        return Color(int.parse(color.replaceFirst('#', '0xff')));
      } catch (e) {
        return null;
      }
    }
    return null;
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