import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared/shared.dart';

part 'bdui_api.g.dart';

@RestApi()
abstract class BDUIApi {
  factory BDUIApi(Dio dio, {String baseUrl}) = _BDUIApi;

  @GET('bdui/challenges')
  Future<BDUIScreenModel> getHomeScreen();

  @GET('bdui/challenges/{id}')
  Future<BDUIScreenModel> getChallengeDetailScreen(
    @Path('id') String id,
  );
}
