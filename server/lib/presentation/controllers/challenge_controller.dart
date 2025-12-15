import 'package:bdui_server/domain/use_cases/track_progress_use_case.dart';
import 'package:bdui_server/utils/json_utils.dart';
import 'package:shared/domain/models/challenge.dart';
import 'package:shared/domain/repositories/challenge_repository.dart';
import 'package:shelf/shelf.dart';

class ChallengeController {
  final ChallengeRepository challengeRepository;
  final TrackProgressUseCase trackProgressUseCase;

  ChallengeController(this.challengeRepository, this.trackProgressUseCase);

  Future<Response> getChallenges(Request request) async {
    try {
      final challenges = await challengeRepository.getChallenges();
      final challengesJson = challenges.map(_toChallengeJson).toList();
      return Response.ok(challengesJson);
    } catch (e) {
      return Response.internalServerError(body: 'Error: $e');
    }
  }

  Future<Response> trackProgress(Request request, String id) async {
    try {
      // Парсим JSON тело запроса
      final body = await request.readAsString();
      final data = JsonUtils.parseJson(body);

      // Валидируем обязательные поля
      JsonUtils.validateRequiredFields(data, ['progress']);

      // Извлекаем прогресс
      final progress = JsonUtils.getValue<double>(data, 'progress');

      // Вызываем use case
      final updatedChallenge = await trackProgressUseCase.execute(id, progress);

      // Возвращаем успешный ответ
      return JsonUtils.jsonSuccess(
        message: 'Прогресс успешно обновлен',
        data: _toChallengeJson(updatedChallenge),
      );
    } on FormatException catch (e) {
      return JsonUtils.jsonError('Неверный JSON формат: ${e.message}',
          statusCode: 400);
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
