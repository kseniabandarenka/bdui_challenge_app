import 'package:client/data/source/api/bdui_api.dart';
import 'package:client/domain/gateway/bdui_gateway.dart';
import 'package:shared/shared.dart';

class BDUIGatewayImpl implements BDUIGateway {
  final BDUIApi api;

  BDUIGatewayImpl(this.api);

  @override
  Future<BDUIScreenModel> getHomeScreen() => api.getHomeScreen();

  @override
  Future<BDUIScreenModel> getChallengeDetailScreen(String id) =>
      api.getChallengeDetailScreen(id);
}
