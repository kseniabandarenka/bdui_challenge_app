import 'package:client/domain/gateway/bdui_gateway.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';

/// UseCase для получения главного экрана
class GetHomeScreenUseCase {
  final BDUIGateway gateway;

  GetHomeScreenUseCase(this.gateway);

  Future<BDUIElementModel> call() => gateway.getHomeScreen();
}
