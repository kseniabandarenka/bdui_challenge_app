import 'package:client/domain/gateway/bdui_gateway.dart';
import 'package:shared/shared.dart';

/// UseCase для получения детального экрана челленджа
class GetChallengeDetailScreenUseCase {
  final BDUIGateway gateway;

  GetChallengeDetailScreenUseCase(this.gateway);

  Future<BDUIScreenModel> execute(String id) =>
      gateway.getChallengeDetailScreen(id);
}
