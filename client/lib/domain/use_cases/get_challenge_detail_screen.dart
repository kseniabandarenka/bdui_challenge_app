import 'package:shared/data/models/bdui/bdui_element_model.dart';
import 'package:shared/domain/repositories/challenge_repository.dart';

class GetBDUIChallengeDetailScreenUseCase {
  final ChallengeRepository repository;

  GetBDUIChallengeDetailScreenUseCase(this.repository);

  Future<BDUIElementModel> execute() async {
    final challenges = await repository.getChallenges();
    return bduiScreen.toJson();
  }
}