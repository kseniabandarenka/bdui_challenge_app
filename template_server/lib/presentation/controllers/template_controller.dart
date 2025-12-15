import 'dart:convert';
import 'package:shelf/shelf.dart';
import '../../domain/use_cases/get_template_use_case.dart';
import '../../domain/use_cases/render_template_use_case.dart';

class TemplateController {
  final GetTemplateUseCase getTemplateUseCase;
  final RenderTemplateUseCase renderTemplateUseCase;

  TemplateController({
    required this.getTemplateUseCase,
    required this.renderTemplateUseCase,
  });

  Future<Response> getTemplate(Request request, String name) async {
    try {
      final template = await getTemplateUseCase.execute(name);
      return Response.ok(
        _toJson(template.content),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.notFound('Template not found: $name\nError: $e');
    }
  }

  Future<Response> renderTemplate(Request request, String name) async {
    try {
      final body = await request.readAsString();
      final data = json.decode(body) as Map<String, dynamic>;

      final renderedTemplate = await renderTemplateUseCase.execute(name, data);
      return Response.ok(
        _toJson(renderedTemplate.content),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response.notFound('Error rendering template: $e');
    }
  }

  String _toJson(dynamic data) => JsonEncoder.withIndent('  ').convert(data);
}
