abstract class ChallengeState {}

class ChallengeInitialState extends ChallengeState {}

class ChallengeLoadingState extends ChallengeState {}

class ChallengeLoadedState extends ChallengeState {
  final Map<String, dynamic> challengeData;
  ChallengeLoadedState(this.challengeData);
}

class ChallengeErrorState extends ChallengeState {
  final String error;
  ChallengeErrorState(this.error);
}

class ProgressTrackedState extends ChallengeState {}
