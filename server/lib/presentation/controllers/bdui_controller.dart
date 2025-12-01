import 'dart:convert';

import 'package:bdui_server/infrastructure/domain/use_cases/generate_bdui_home_screen_use_case.dart';
import 'package:bdui_server/infrastructure/domain/use_cases/render_template_use_case.dart';
import 'package:bdui_server/utils/json_utils.dart';
import 'package:shared/domain/repositories/challenge_repository.dart';
import 'package:shelf/shelf.dart';

class BDUIController {
  final ChallengeRepository challengeRepository;
  final GenerateBDUIHomeScreenUseCase generateHomeScreenUseCase;
  final RenderTemplateUseCase renderTemplateUseCase;

  BDUIController({
    required this.challengeRepository,
    required this.generateHomeScreenUseCase,
    required this.renderTemplateUseCase,
  });

  /// Получение BDUI для главного экрана со списком челленджей
  Future<Response> getHomeScreen(Request request) async {
    try {
      final bduiScreen = await generateHomeScreenUseCase.execute();
      return JsonUtils.jsonResponse(bduiScreen);
    } catch (e) {
      return JsonUtils.jsonError('Failed to generate BDUI home screen: $e');
    }
  }

/// Получение BDUI для детальной страницы челленджа
Future<Response> getChallengeDetail(Request request, String id) async {
  try {
    final challenge = await challengeRepository.getChallengeById(id);
    final challengeData = {
      'id': challenge.id,
      'title': challenge.title,
      'category': challenge.category,
      'description': challenge.description,
      'progressCurrent': challenge.progressCurrent,
      'progressTotal': challenge.progressTotal,
      'progressPercentage':
          (challenge.progressPercentage * 100).toStringAsFixed(1),
    };

    final ui =
        await renderTemplateUseCase.execute('challenge_detail', challengeData);
    final jsonString = jsonEncode(ui);

    return Response.ok(
      jsonString,
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e, s) {
    print(e);
    print(s);
    return JsonUtils.jsonError('Challenge not found: $e', statusCode: 404);
  }
}
}

