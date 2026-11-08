import 'package:shared/shared.dart';

/// Presenter: превращает доменную сущность в ViewModel карточки для клиента.
class ChallengeCardPresenter {
  const ChallengeCardPresenter();

  BDUIChallengeCardModel present(Challenge challenge) {
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
      action: BDUIActionData(
        type: BDUIActionType.navigate,
        screen: BDUIScreenType.challengeDetail,
        challengeId: challenge.id,
      ),
    );
  }
}
