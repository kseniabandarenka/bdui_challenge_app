abstract class ChallengeEvent {}

class LoadChallengeEvent extends ChallengeEvent {
  final String challengeId;
  LoadChallengeEvent(this.challengeId);
}

class TrackProgressEvent extends ChallengeEvent {
  final String challengeId;
  final double progress;
  TrackProgressEvent(this.challengeId, this.progress);
}
