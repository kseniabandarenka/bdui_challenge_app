import '../../domain/repositories/template_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpTemplateRepository implements TemplateRepository {
  final String templateServerUrl;

  HttpTemplateRepository({this.templateServerUrl = 'http://localhost:8082'});

  @override
  Future<Map<String, dynamic>> getRenderedTemplate(
      String templateName, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$templateServerUrl/templates/$templateName/render'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    return json.decode(response.body);
  }
}
