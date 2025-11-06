import 'dart:convert';
import 'package:shelf/shelf.dart';

/// Утилитный класс для стандартизированной работы с JSON
/// Обеспечивает единообразные JSON-ответы по всему приложению
class JsonUtils {
  static const _encoder = JsonEncoder.withIndent('  ');
  static const _decoder = JsonDecoder();

  /// Конвертирует данные в отформатированную JSON строку
  static String toJson(dynamic data) {
    try {
      return _encoder.convert(data);
    } catch (e) {
      throw FormatException('Failed to encode JSON: $e');
    }
  }

  /// Парсит JSON строку в Map
  static Map<String, dynamic> parseJson(String json) {
    try {
      return _decoder.convert(json) as Map<String, dynamic>;
    } catch (e) {
      throw FormatException('Invalid JSON format: $e');
    }
  }

  /// Создает стандартизированный JSON Response
  static Response jsonResponse(
    dynamic data, {
    int statusCode = 200,
    Map<String, String>? headers,
  }) {
    return Response(
      statusCode,
      body: toJson(data),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        ...?headers,
      },
    );
  }

  /// Создает Response с ошибкой в стандартном формате
  static Response jsonError(
    String message, {
    int statusCode = 500,
    String? code,
    dynamic details,
  }) {
    return jsonResponse(
      {
        'error': {
          'message': message,
          'code': code,
          'statusCode': statusCode,
          if (details != null) 'details': details,
          'timestamp': DateTime.now().toIso8601String(),
        }
      },
      statusCode: statusCode,
    );
  }

  /// Создает успешный Response в стандартном формате
  static Response jsonSuccess({
    String? message,
    dynamic data,
  }) {
    return jsonResponse({
      'success': true,
      if (message != null) 'message': message,
      if (data != null) 'data': data,
    });
  }

  /// Валидирует обязательные поля в JSON
  static void validateRequiredFields(
    Map<String, dynamic> json,
    List<String> requiredFields,
  ) {
    for (final field in requiredFields) {
      if (!json.containsKey(field) || json[field] == null) {
        throw ArgumentError('Required field "$field" is missing');
      }
    }
  }

  /// Извлекает значение из JSON с проверкой типа
  static T getValue<T>(Map<String, dynamic> json, String key,
      [T? defaultValue]) {
    if (!json.containsKey(key)) {
      if (defaultValue != null) return defaultValue;
      throw ArgumentError('Field "$key" is required');
    }

    final value = json[key];
    if (value is T) return value;

    // Попытка конвертации для числовых типов
    if (T == double && value is int) return value.toDouble() as T;
    if (T == int && value is double) return value.toInt() as T;
    if (T == String && value != null) return value.toString() as T;

    throw ArgumentError(
        'Field "$key" has invalid type. Expected $T, got ${value.runtimeType}');
  }
}
