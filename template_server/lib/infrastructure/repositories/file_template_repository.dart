import 'dart:convert';
import 'dart:io';
import '../../domain/entities/template.dart';
import '../../domain/repositories/template_repository.dart';

class FileTemplateRepository implements TemplateRepository {
  static const String _templatesPath = 'ui_templates';

  @override
  Future<Template> getTemplate(String name) async {
    try {
      final file = File('$_templatesPath/$name.json');
      if (!file.existsSync()) {
        throw Exception('Template not found: $name');
      }

      final content = json.decode(file.readAsStringSync());
      final lastModified = file.lastModifiedSync();

      return Template(name: name, content: content, lastModified: lastModified);
    } catch (e) {
      throw Exception('Failed to load template: $e');
    }
  }

  @override
  Future<RenderedTemplate> renderTemplate(
    String name,
    Map<String, dynamic> data,
  ) async {
    final template = await getTemplate(name);
    final renderedContent = _renderTemplate(template.content, data);

    return RenderedTemplate(name: name, content: renderedContent, data: data);
  }

  Map<String, dynamic> _renderTemplate(
    Map<String, dynamic> template,
    Map<String, dynamic> data,
  ) {
    final jsonString = json.encode(template);
    String result = jsonString;

    data.forEach((key, value) {
      result = result.replaceAll('"{{$key}}"', '"$value"');
      result = result.replaceAll('{{$key}}', '$value');
    });

    return json.decode(result);
  }
}
