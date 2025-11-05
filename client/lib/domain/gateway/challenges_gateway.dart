import 'package:shared/shared.dart';

abstract class ChallengesGateway {

  // Получить список всех доступных челленджей
  Future<List<ChallengeModel>> getChallenges();

  // Обновить прогресс выполнения челленджа
  Future<void> trackProgress({
    required double progress,
    required String id,
  });
}
