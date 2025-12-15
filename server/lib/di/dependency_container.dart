import 'package:bdui_server/data/repositories/http_template_repository.dart';
import 'package:bdui_server/domain/use_cases/render_template_use_case.dart';
import 'package:bdui_server/server.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<ShelfChallengeRepository>(
    () => ShelfChallengeRepository(),
  );

  getIt.registerLazySingleton<HttpTemplateRepository>(
    () => HttpTemplateRepository(),
  );

  getIt.registerLazySingleton<RenderTemplateUseCase>(
    () => RenderTemplateUseCase(
      getIt.get<HttpTemplateRepository>(),
    ),
  );

  getIt.registerLazySingleton<TrackProgressUseCase>(
    () => TrackProgressUseCase(
      getIt.get<ShelfChallengeRepository>(),
    ),
  );

  getIt.registerLazySingleton<ChallengeController>(
    () => ChallengeController(
      getIt.get<ShelfChallengeRepository>(),
      getIt.get<TrackProgressUseCase>(),
    ),
  );

  getIt.registerLazySingleton<BDUIController>(
    () => BDUIController(
      challengeRepository: getIt.get<ShelfChallengeRepository>(),
      renderTemplateUseCase: getIt.get<RenderTemplateUseCase>(),
    ),
  );

  // Роутер
  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(
      getIt.get<ChallengeController>(),
      getIt.get<BDUIController>(),
    ),
  );
}
