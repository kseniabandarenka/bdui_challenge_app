import 'package:client/domain/gateway/bdui_gateway.dart';
import 'package:shared/shared.dart';

/// UseCase для получения главного экрана
class GetHomeScreenUseCase {
  final BDUIGateway gateway;

  GetHomeScreenUseCase(this.gateway);

  Future<BDUIScreenModel> execute() => gateway.getHomeScreen();
}
