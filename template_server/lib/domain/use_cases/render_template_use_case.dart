import '../repositories/template_repository.dart';
import '../entities/template.dart';

class RenderTemplateUseCase {
  final TemplateRepository repository;

  RenderTemplateUseCase(this.repository);

  Future<RenderedTemplate> execute(String name, Map<String, dynamic> data) =>
      repository.renderTemplate(name, data);
}
