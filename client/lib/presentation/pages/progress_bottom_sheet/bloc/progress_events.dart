abstract class ProgressBottomSheetEvent {}

class SubmitProgressEvent extends ProgressBottomSheetEvent {
  final String challengeId;
  final double progress;

  SubmitProgressEvent(this.challengeId, this.progress);
}

class CloseProgressBottomSheetEvent extends ProgressBottomSheetEvent {}