import 'package:client/data/gateway/challenges_gateway_impl.dart';
import 'package:client/data/source/api/challenges_api.dart';
import 'package:client/domain/use_cases/track_progress_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared/shared.dart';

class _FakeChallengesApi implements ChallengesApi {
  ProgressRequestModel? sentProgress;
  String? sentId;

  @override
  Future<List<ChallengeModel>> getChallenges() async => [
        ChallengeModel(
          id: '1',
          title: 'Run',
          description: 'Run 2 km',
          category: 'Fitness',
          progressCurrent: 1,
          progressTotal: 2,
          completed: false,
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      ];

  @override
  Future<void> trackProgress(
    ProgressRequestModel progress, {
    required String id,
  }) async {
    sentProgress = progress;
    sentId = id;
  }
}

void main() {
  group('ChallengesGatewayImpl', () {
    test('getChallenges отдаёт домену сущности, а не DTO', () async {
      final gateway = ChallengesGatewayImpl(_FakeChallengesApi());

      final challenges = await gateway.getChallenges();

      expect(challenges.single, isA<Challenge>());
      expect(challenges.single.progressPercentage, 0.5);
    });

    test('trackProgress упаковывает число в транспортную модель', () async {
      final api = _FakeChallengesApi();
      final useCase = TrackProgressUseCase(ChallengesGatewayImpl(api));

      await useCase.execute(progress: 1.5, id: '7');

      expect(api.sentProgress?.progress, 1.5);
      expect(api.sentId, '7');
    });
  });
}
