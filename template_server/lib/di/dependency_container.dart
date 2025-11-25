import '../domain/repositories/template_repository.dart';
import '../infrastructure/repositories/file_template_repository.dart';
import '../domain/use_cases/get_template_use_case.dart';
import '../domain/use_cases/render_template_use_case.dart';
import '../presentation/controllers/template_controller.dart';
import '../server/router.dart';

class DependencyContainer {
  late final TemplateRepository _templateRepository;
  late final GetTemplateUseCase _getTemplateUseCase;
  late final RenderTemplateUseCase _renderTemplateUseCase;
  late final TemplateController _templateController;
  late final AppRouter _appRouter;

  DependencyContainer() {
    _initialize();
  }

  void _initialize() {
    // 1. Репозитории
    _templateRepository = FileTemplateRepository();

    // 2. Use Cases
    _getTemplateUseCase = GetTemplateUseCase(_templateRepository);
    _renderTemplateUseCase = RenderTemplateUseCase(_templateRepository);

    // 3. Контроллеры
    _templateController = TemplateController(
      getTemplateUseCase: _getTemplateUseCase,
      renderTemplateUseCase: _renderTemplateUseCase,
    );

    // 4. Роутер
    _appRouter = AppRouter(_templateController);
  }

  // Getters для доступа к зависимостям
  TemplateRepository get templateRepository => _templateRepository;
  GetTemplateUseCase get getTemplateUseCase => _getTemplateUseCase;
  RenderTemplateUseCase get renderTemplateUseCase => _renderTemplateUseCase;
  TemplateController get templateController => _templateController;
  AppRouter get appRouter => _appRouter;
}
