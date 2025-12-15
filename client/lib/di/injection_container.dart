import 'package:flutter/foundation.dart';
import 'package:client/data/gateway/bdui_gateway_impl.dart';
import 'package:client/data/gateway/challenges_gateway_impl.dart';
import 'package:client/data/source/api/bdui_api.dart';
import 'package:client/data/source/api/challenges_api.dart';
import 'package:client/domain/gateway/bdui_gateway.dart';
import 'package:client/domain/gateway/challenges_gateway.dart';
import 'package:client/domain/use_cases/bdui/get_bdui_home_screen_use_case.dart';
import 'package:client/domain/use_cases/bdui/get_challenge_detail_screen.dart';
import 'package:client/domain/use_cases/track_progress_usecase.dart';
import 'package:client/presentation/pages/challenge_details/bloc/challenge_bloc.dart';
import 'package:client/presentation/pages/progress_bottom_sheet/bloc/progress_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../presentation/pages/home/bloc/home_bloc.dart';

final getIt = GetIt.instance;

void setUpDependencies() {
  _setupHttpClient();
  _setupApi();
  _setupGateways();
  _setupUseCases();
  _setupBlocs();
}

void _setupHttpClient() {
  // Создаем Dio с правильными настройками для Android
  final dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    error: true,
  ));

  getIt.registerSingleton<Dio>(dio);
}

String get baseUrl {
  if (kIsWeb) {
    // Для веба
    return 'http://localhost:8080/api/'; // или 'http://localhost:8080/api'
  }

  // Для нативных платформ
  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:8080/api/';
  } else {
    return 'http://localhost:8080/api/';
  }
}

void _setupApi() {
  getIt.registerFactory<BDUIApi>(
    () => BDUIApi(getIt<Dio>(), baseUrl: baseUrl),
  );
  getIt.registerFactory<ChallengesApi>(
    () => ChallengesApi(getIt<Dio>(), baseUrl: baseUrl),
  );
}

void _setupGateways() {
  getIt.registerFactory<BDUIGateway>(
    () => BDUIGatewayImpl(getIt<BDUIApi>()),
  );
  getIt.registerFactory<ChallengesGateway>(
    () => ChallengesGatewayImpl(getIt<ChallengesApi>()),
  );
}

void _setupUseCases() {
  getIt.registerFactory<GetChallengeDetailScreenUseCase>(
    () => GetChallengeDetailScreenUseCase(getIt<BDUIGateway>()),
  );
  getIt.registerFactory<TrackProgressUseCase>(
    () => TrackProgressUseCase(getIt<ChallengesGateway>()),
  );
  getIt.registerFactory<GetHomeScreenUseCase>(
    () => GetHomeScreenUseCase(getIt<BDUIGateway>()),
  );
}

void _setupBlocs() {
  getIt.registerFactory<ChallengeBloc>(
    () => ChallengeBloc(
      getIt<GetChallengeDetailScreenUseCase>(),
      getIt<TrackProgressUseCase>(),
    ),
  );

  getIt.registerFactory<HomeBloc>(
    () => HomeBloc(getIt<GetHomeScreenUseCase>()),
  );

  getIt.registerFactory<ProgressBottomSheetBloc>(
    () => ProgressBottomSheetBloc(getIt<TrackProgressUseCase>()),
  );
}
