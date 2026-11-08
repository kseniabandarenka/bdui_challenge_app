import 'package:bdui_server/domain/use_cases/get_challenges_use_case.dart';
import 'package:bdui_server/domain/use_cases/track_progress_use_case.dart';
import 'package:bdui_server/utils/json_utils.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class ChallengeController {
  final GetChallengesUseCase getChallengesUseCase;
  final TrackProgressUseCase trackProgressUseCase;

  ChallengeController(this.getChallengesUseCase, this.trackProgressUseCase);

  Future<Response> getChallenges(Request request) async {
    try {
      final challenges = await getChallengesUseCase.execute();
      return JsonUtils.jsonResponse(challenges.map(_toChallengeJson).toList());
    } catch (e) {
      return JsonUtils.jsonError('Ошибка загрузки челленджей: $e');
    }
  }

  Future<Response> trackProgress(Request request, String id) async {
    try {
      final body = await request.readAsString();
      final data = JsonUtils.parseJson(body);
      JsonUtils.validateRequiredFields(data, ['progress']);
      final progress = JsonUtils.getValue<double>(data, 'progress');

      final updatedChallenge = await trackProgressUseCase.execute(id, progress);

      return JsonUtils.jsonSuccess(
        message: 'Прогресс успешно обновлен',
        data: _toChallengeJson(updatedChallenge),
      );
    } on FormatException catch (e) {
      return JsonUtils.jsonError('Неверный JSON формат: ${e.message}',
          statusCode: 400);
    } on ChallengeNotFoundException catch (e) {
      return JsonUtils.jsonError(e.toString(), statusCode: 404);
    } on ArgumentError catch (e) {
      return JsonUtils.jsonError(e.message, statusCode: 400);
    } catch (e) {
      return JsonUtils.jsonError('Ошибка обновления прогресса: $e');
    }
  }

  Map<String, dynamic> _toChallengeJson(Challenge challenge) {
    return ChallengeMapper.toModel(challenge).toJson();
  }
}
