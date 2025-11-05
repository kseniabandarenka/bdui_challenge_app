import 'package:shared/shared.dart';

abstract class BDUIGateway {

  /// Получить главный экран с челленджами
  Future<BDUIElementModel> getHomeScreen();

  /// Получить детальный экран челленджа
  /// 
  /// [id] - идентификатор челленджа
  Future<BDUIElementModel> getChallengeDetailScreen(String id);
}