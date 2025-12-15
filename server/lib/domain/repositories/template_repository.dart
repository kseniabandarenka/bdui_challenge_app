abstract class TemplateRepository {
  Future<Map<String, dynamic>> getRenderedTemplate(
      String templateName, Map<String, dynamic> data);
}
