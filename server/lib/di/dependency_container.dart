import 'package:bdui_server/server.dart';
import 'package:get_it/get_it.dart';
import 'package:shared/shared.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Репозитории регистрируются по интерфейсам домена.
  getIt.registerLazySingleton<ChallengeRepository>(
    () => JsonFileChallengeRepository(),
  );
  getIt.registerLazySingleton<TemplateRepository>(
    () => HttpTemplateRepository(),
  );

  getIt.registerLazySingleton<GetChallengesUseCase>(
    () => GetChallengesUseCase(getIt<ChallengeRepository>()),
  );
  getIt.registerLazySingleton<GetChallengeByIdUseCase>(
    () => GetChallengeByIdUseCase(getIt<ChallengeRepository>()),
  );
  getIt.registerLazySingleton<GetHomeScreenSummaryUseCase>(
    () => GetHomeScreenSummaryUseCase(getIt<ChallengeRepository>()),
  );
  getIt.registerLazySingleton<TrackProgressUseCase>(
    () => TrackProgressUseCase(getIt<ChallengeRepository>()),
  );
  getIt.registerLazySingleton<RenderTemplateUseCase>(
    () => RenderTemplateUseCase(getIt<TemplateRepository>()),
  );

  getIt.registerLazySingleton<ChallengeController>(
    () => ChallengeController(
      getIt<GetChallengesUseCase>(),
      getIt<TrackProgressUseCase>(),
    ),
  );
  getIt.registerLazySingleton<BDUIController>(
    () => BDUIController(
      getHomeScreenSummaryUseCase: getIt<GetHomeScreenSummaryUseCase>(),
      getChallengeByIdUseCase: getIt<GetChallengeByIdUseCase>(),
      renderTemplateUseCase: getIt<RenderTemplateUseCase>(),
    ),
  );

  getIt.registerLazySingleton<AppRouter>(
    () => AppRouter(
      getIt<ChallengeController>(),
      getIt<BDUIController>(),
    ),
  );
}
