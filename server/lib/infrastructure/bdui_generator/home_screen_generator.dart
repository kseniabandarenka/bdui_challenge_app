import 'package:shared/shared.dart';

class HomeScreenBDUIGenerator {
  BDUIScreenModel generate(List<Challenge> challenges) {
    return BDUIScreenModel(
      screenType: BDUIScreenType.challengesList,
      title: 'Мои челленджи',
      layout: BDUIElementModel(
        type: BDUIType.column,
        children: [
          _buildHeader(challenges),
          _buildStats(challenges),
          _buildChallengeList(challenges),
        ],
      ),
    );
  }

 BDUIElementModel _buildHeader(List<Challenge> challenges) {
    final completedCount = challenges.where((c) => c.completed).length;
    final inProgressCount = challenges.where((c) => c.isInProgress).length;

    return BDUIElementModel(
      type: BDUIType.column,
      children: [
        BDUIElementModel(
          type: BDUIType.text,
          value: '🏆 Мои ежедневные челленджи',
          style: BDUITextStyleModel(
            fontSize: 24,
            fontWeight: BDUIFontWeight.bold,
            color: '#2E7D32',
          ),
        ),
        BDUIElementModel(
          type: BDUIType.text,
          value: '✅ Завершено: $completedCount | 🎯 В процессе: $inProgressCount',
          style: BDUITextStyleModel(
            fontSize: 16,
            color: '#666666',
          ),
        ),
      ],
    );
  }

 BDUIElementModel _buildStats(List<Challenge> challenges) {
    final totalProgress = challenges.fold(0.0, (sum, c) => sum + c.progressPercentage);
    final averageProgress = challenges.isNotEmpty ? totalProgress / challenges.length : 0;

    return BDUIElementModel(
      type: BDUIType.container,
      decoration: BDUIDecorationModel(
        color: '#E8F5E8',
        borderRadius: BDUIBorderRadius(all: 8),
        padding: BDUIPadding(
          left: 16,
          top: 12,
          right: 16,
          bottom: 12,
        ),
      ),
      child: BDUIElementModel(
        type: BDUIType.text,
        value: '📊 Общий прогресс: ${(averageProgress * 100).toStringAsFixed(1)}%',
        style: BDUITextStyleModel(
          fontSize: 14,
          color: '#2E7D32',
          fontWeight: BDUIFontWeight.bold,
        ),
      ),
    );
  }

  BDUIElementModel _buildChallengeList(List<Challenge> challenges) {
    return BDUIElementModel(
      type: BDUIType.challengeList,
      challenges: challenges.map(_mapChallengeToBDUI).toList(),
    );
  }

  BDUIChallengeCardModel _mapChallengeToBDUI(Challenge challenge) {
    return BDUIChallengeCardModel(
      id: challenge.id,
      type: BDUIType.challengeCard,
      title: challenge.title,
      category: challenge.category,
      description: challenge.description,
      progressCurrent: challenge.progressCurrent,
      progressTotal: challenge.progressTotal,
      completed: challenge.completed,
      isInProgress: challenge.isInProgress,
      progressPercentage: challenge.progressPercentage,
      action: BDUICardActionModel(
        type: BDUIActionType.navigate,
        screen: BDUIScreenType.challengeDetail,
        challengeId: challenge.id,
      ), actions: [],
    );
  }
}