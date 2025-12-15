import 'dart:convert';

import 'package:bdui_server/domain/use_cases/render_template_use_case.dart';
import 'package:bdui_server/utils/json_utils.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class BDUIController {
  final ChallengeRepository challengeRepository;
  final RenderTemplateUseCase renderTemplateUseCase;

  BDUIController({
    required this.challengeRepository,
    required this.renderTemplateUseCase,
  });

  /// Получение BDUI для главного экрана со списком челленджей
  Future<Response> getHomeScreen(Request request) async {
    try {
      final challenges = await challengeRepository.getChallenges();

      final inProgressChallenges =
          challenges.where((c) => c.isInProgress).length;
      final totalProgress =
          challenges.fold(0.0, (sum, c) => sum + c.progressPercentage);
      final averageProgress = challenges.isNotEmpty
          ? (totalProgress / challenges.length * 100).toStringAsFixed(1)
          : "0.0";

      final challengeList = challenges.map(_mapChallengeToBDUI).toList();

      final templateData = {
        'challenges': challengeList.map((e) => e.toJson()).toList(),
        'completedChallenges': challenges.where((c) => c.completed).length,
        'inProgressChallenges': inProgressChallenges,
        'averageProgress': averageProgress,
      };

      final ui =
          await renderTemplateUseCase.execute('home_screen', templateData);

      return Response.ok(
        jsonEncode(ui),
        headers: {'Content-Type': 'application/json'},
      );
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

      final ui = await renderTemplateUseCase.execute(
          'challenge_detail', challengeData);
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

  BDUIChallengeCardModel _mapChallengeToBDUI(Challenge challenge) {
    return BDUIChallengeCardModel(
      id: challenge.id,
      type: BDUIType.challengeCard,
      title: challenge.title,
      category: challenge.category,
      description: challenge.description,
      progressCurrent: challenge.progressCurrent,
      progressTotal: challenge.progressTotal,
      completed: challenge.completed,
      isInProgress: challenge.isInProgress,
      progressPercentage: challenge.progressPercentage,
      action: BDUIActionData(
        type: BDUIActionType.navigate,
        screen: BDUIScreenType.challengeDetail,
        challengeId: challenge.id,
      ),
    );
  }
}
