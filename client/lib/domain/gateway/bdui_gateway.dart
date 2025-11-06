import 'package:shared/shared.dart';

abstract class BDUIGateway {
  /// Получить главный экран с челленджами
  Future<BDUIScreenModel> getHomeScreen();

  /// Получить детальный экран челленджа
  ///
  /// [id] - идентификатор челленджа
  Future<BDUIScreenModel> getChallengeDetailScreen(String id);
}
