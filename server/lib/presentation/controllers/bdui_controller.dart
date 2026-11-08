import 'dart:convert';

import 'package:bdui_server/domain/exceptions/template_unavailable_exception.dart';
import 'package:bdui_server/domain/use_cases/get_challenge_by_id_use_case.dart';
import 'package:bdui_server/domain/use_cases/get_home_screen_summary_use_case.dart';
import 'package:bdui_server/domain/use_cases/render_template_use_case.dart';
import 'package:bdui_server/presentation/presenters/challenge_card_presenter.dart';
import 'package:bdui_server/utils/json_utils.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class BDUIController {
  final GetHomeScreenSummaryUseCase getHomeScreenSummaryUseCase;
  final GetChallengeByIdUseCase getChallengeByIdUseCase;
  final RenderTemplateUseCase renderTemplateUseCase;
  final ChallengeCardPresenter cardPresenter;

  BDUIController({
    required this.getHomeScreenSummaryUseCase,
    required this.getChallengeByIdUseCase,
    required this.renderTemplateUseCase,
    this.cardPresenter = const ChallengeCardPresenter(),
  });

  Future<Response> getHomeScreen(Request request) async {
    try {
      final summary = await getHomeScreenSummaryUseCase.execute();

      final ui = await renderTemplateUseCase.execute('home_screen', {
        'challenges': summary.challenges
            .map((c) => cardPresenter.present(c).toJson())
            .toList(),
        'completedChallenges': summary.completedCount,
        'inProgressChallenges': summary.inProgressCount,
        'averageProgress': summary.averageProgressPercent.toStringAsFixed(1),
      });

      return _jsonOk(ui);
    } on TemplateUnavailableException catch (e) {
      return JsonUtils.jsonError(e.toString(), statusCode: 502);
    } catch (e) {
      return JsonUtils.jsonError('Failed to generate BDUI home screen: $e');
    }
  }

  Future<Response> getChallengeDetail(Request request, String id) async {
    try {
      final challenge = await getChallengeByIdUseCase.execute(id);

      final ui = await renderTemplateUseCase.execute('challenge_detail', {
        'id': challenge.id,
        'title': challenge.title,
        'category': challenge.category,
        'description': challenge.description,
        'progressCurrent': challenge.progressCurrent,
        'progressTotal': challenge.progressTotal,
        'progressPercentage':
            (challenge.progressPercentage * 100).toStringAsFixed(1),
      });

      return _jsonOk(ui);
    } on ChallengeNotFoundException catch (e) {
      return JsonUtils.jsonError(e.toString(), statusCode: 404);
    } on TemplateUnavailableException catch (e) {
      return JsonUtils.jsonError(e.toString(), statusCode: 502);
    } catch (e) {
      return JsonUtils.jsonError(
          'Failed to generate BDUI challenge screen: $e');
    }
  }

  Response _jsonOk(Map<String, dynamic> body) => Response.ok(
        jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );
}
