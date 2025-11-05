abstract class ProgressEvent {}

class SaveProgressEvent extends ProgressEvent {
  final String challengeId;
  final double progress;

  SaveProgressEvent(this.challengeId, this.progress);
}
