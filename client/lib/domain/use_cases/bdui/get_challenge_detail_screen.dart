import 'package:client/domain/gateway/bdui_gateway.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';

/// UseCase для получения детального экрана челленджа
class GetChallengeDetailScreenUseCase {
  final BDUIGateway gateway;

  GetChallengeDetailScreenUseCase(this.gateway);

  Future<BDUIElementModel> call(String id) =>
      gateway.getChallengeDetailScreen(id);
}
