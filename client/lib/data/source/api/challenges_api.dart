import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:shared/shared.dart';

@RestApi()
abstract class ChallengesApi {
  factory ChallengesApi(Dio dio, {String baseUrl}) = _ChallengesApi;


  @GET('challenges')
  Future<List<ChallengeModel>> getChallenges();

  @POST('challenges/{id}}/progress')
  Future<void> trackProgress(
     @Body() double progress, {
    @Path('id') required String id,
  });
}