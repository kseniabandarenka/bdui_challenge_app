import 'package:bdui_server/infrastructure/domain/use_cases/generate_bdui_home_screen_use_case.dart';
import 'package:bdui_server/utils/json_utils.dart';
import 'package:shared/domain/repositories/challenge_repository.dart';
import 'package:shelf/shelf.dart';
import 'package:bdui_server/infrastructure/bdui_generator/challenge_detail_generator.dart';

class BDUIController {
  final ChallengeRepository challengeRepository;
  final GenerateBDUIHomeScreenUseCase generateHomeScreenUseCase;
  final ChallengeDetailBDUIGenerator challengeDetailGenerator;

  BDUIController({
    required this.challengeRepository,
    required this.generateHomeScreenUseCase,
    required this.challengeDetailGenerator,
  });

  /// Получение BDUI для главного экрана со списком челленджей
  Future<Response> getHomeScreen(Request request) async {
    try {
      final bduiScreen = await generateHomeScreenUseCase.execute();
      return JsonUtils.jsonResponse(bduiScreen);
    } catch (e) {
      return JsonUtils.jsonError('Failed to generate BDUI home screen: $e');
    }
  }

  /// Получение BDUI для детальной страницы челленджа
  Future<Response> getChallengeDetail(Request request, String id) async {
    try {
      final challenge = await challengeRepository.getChallengeById(id);
      final bduiJson = challengeDetailGenerator.generate(challenge);
      return JsonUtils.jsonResponse(bduiJson);
    } catch (e) {
      return JsonUtils.jsonError('Challenge not found: $e', statusCode: 404);
    }
  }
}