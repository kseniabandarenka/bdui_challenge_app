import '../repositories/template_repository.dart';
import '../entities/template.dart';

class GetTemplateUseCase {
  final TemplateRepository repository;

  GetTemplateUseCase(this.repository);

  Future<Template> execute(String name) => repository.getTemplate(name);
}
