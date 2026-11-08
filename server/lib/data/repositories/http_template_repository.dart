import 'dart:convert';

import 'package:bdui_server/domain/exceptions/template_unavailable_exception.dart';
import 'package:http/http.dart' as http;

import '../../domain/repositories/template_repository.dart';

class HttpTemplateRepository implements TemplateRepository {
  final String templateServerUrl;

  HttpTemplateRepository({this.templateServerUrl = 'http://localhost:8082'});

  @override
  Future<Map<String, dynamic>> getRenderedTemplate(
      String templateName, Map<String, dynamic> data) async {
    final http.Response response;
    try {
      response = await http.post(
        Uri.parse('$templateServerUrl/templates/$templateName/render'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
    } catch (e) {
      throw TemplateUnavailableException('$e');
    }

    if (response.statusCode != 200) {
      throw TemplateUnavailableException(
        'status ${response.statusCode} for template "$templateName"',
      );
    }

    return json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
  }
}
