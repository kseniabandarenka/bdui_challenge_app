import 'package:bdui_server/server.dart';
import 'package:shared/shared.dart';

Challenge makeChallenge({
  String id = '1',
  double current = 0,
  double total = 10,
  bool completed = false,
}) {
  return Challenge(
    id: id,
    title: 'Challenge $id',
    description: 'Description $id',
    category: 'Category',
    progressCurrent: current,
    progressTotal: total,
    completed: completed,
    createdAt: DateTime.utc(2026, 1, 1),
  );
}

class InMemoryChallengeRepository implements ChallengeRepository {
  final Map<String, Challenge> _items;

  InMemoryChallengeRepository(List<Challenge> items)
      : _items = {for (final c in items) c.id: c};

  @override
  Future<List<Challenge>> getChallenges() async => _items.values.toList();

  @override
  Future<Challenge> getChallengeById(String id) async =>
      _items[id] ?? (throw ChallengeNotFoundException(id));

  @override
  Future<Challenge> updateChallenge(Challenge challenge) async {
    if (!_items.containsKey(challenge.id)) {
      throw ChallengeNotFoundException(challenge.id);
    }
    _items[challenge.id] = challenge;
    return challenge;
  }
}

/// Запоминает, с какими данными вызвали шаблон, и возвращает заглушку.
class FakeTemplateRepository implements TemplateRepository {
  final Map<String, dynamic> response;
  final Exception? failure;
  String? lastTemplateName;
  Map<String, dynamic>? lastData;

  FakeTemplateRepository({this.response = const {'screen_type': 'fake'}})
      : failure = null;

  FakeTemplateRepository.failing(this.failure) : response = const {};

  @override
  Future<Map<String, dynamic>> getRenderedTemplate(
    String templateName,
    Map<String, dynamic> data,
  ) async {
    if (failure != null) throw failure!;
    lastTemplateName = templateName;
    lastData = data;
    return response;
  }
}

AppRouter buildRouter(
  ChallengeRepository challenges,
  TemplateRepository templates,
) {
  return AppRouter(
    ChallengeController(
      GetChallengesUseCase(challenges),
      TrackProgressUseCase(challenges),
    ),
    BDUIController(
      getHomeScreenSummaryUseCase: GetHomeScreenSummaryUseCase(challenges),
      getChallengeByIdUseCase: GetChallengeByIdUseCase(challenges),
      renderTemplateUseCase: RenderTemplateUseCase(templates),
    ),
  );
}
