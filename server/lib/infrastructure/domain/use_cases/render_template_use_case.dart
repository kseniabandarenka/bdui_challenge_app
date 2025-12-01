import 'package:bdui_server/infrastructure/domain/repositories/template_repository.dart';

class RenderTemplateUseCase {
  final TemplateRepository repository;

  RenderTemplateUseCase(this.repository);

  Future<Map<String, dynamic>> execute(
          String templateName, Map<String, dynamic> data) =>
      repository.getRenderedTemplate(templateName, data);
}
