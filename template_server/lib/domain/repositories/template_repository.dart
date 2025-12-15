import '../entities/template.dart';

abstract class TemplateRepository {
  Future<Template> getTemplate(String name);
  Future<RenderedTemplate> renderTemplate(
    String name,
    Map<String, dynamic> data,
  );
}
