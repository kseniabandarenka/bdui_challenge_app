import 'package:client/data/source/api/bdui_api.dart';
import 'package:client/domain/gateway/bdui_gateway.dart';
import 'package:shared/data/models/bdui/bdui_element_model.dart';

class BDUIGatewayImpl implements BDUIGateway {
  final BDUIApi api;

  BDUIGatewayImpl(this.api);

  @override
  Future<BDUIElementModel> getHomeScreen() => api.getHomeScreen();

  @override
  Future<BDUIElementModel> getChallengeDetailScreen(String id) =>
      api.getChallengeDetailScreen(id);
}
