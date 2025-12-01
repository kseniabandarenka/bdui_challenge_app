import 'package:bdui_server/infrastructure/bdui_generator/home_screen_generator.dart'
    show HomeScreenBDUIGenerator;
import 'package:shared/domain/repositories/challenge_repository.dart';

class GenerateBDUIHomeScreenUseCase {
  final ChallengeRepository repository;
  final HomeScreenBDUIGenerator generator;

  GenerateBDUIHomeScreenUseCase(this.repository, this.generator);

  Future<Map<String, dynamic>> execute() async {
    final challenges = await repository.getChallenges();
    final bduiScreen = generator.generate(challenges);
    return bduiScreen.toJson();
  }
}
