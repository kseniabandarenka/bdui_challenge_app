enum ActionType {
  navigate,
  submit,
  trackProgress,
  startChallenge,
  completeChallenge,
  showDialog,
  showBottomSheet, 
}

extension ActionTypeExtension on ActionType {
  String get value {
    switch (this) {
      case ActionType.navigate:
        return 'navigate';
      case ActionType.submit:
        return 'submit';
      case ActionType.trackProgress:
        return 'track_progress';
      case ActionType.startChallenge:
        return 'start_challenge';
      case ActionType.completeChallenge:
        return 'complete_challenge';
      case ActionType.showDialog:
        return 'show_dialog';
      case ActionType.showBottomSheet:
        return 'show_bottom_sheet';
    }
  }

  static ActionType fromString(String value) {
    switch (value) {
      case 'navigate':
        return ActionType.navigate;
      case 'submit':
        return ActionType.submit;
      case 'track_progress':
        return ActionType.trackProgress;
      case 'start_challenge':
        return ActionType.startChallenge;
      case 'complete_challenge':
        return ActionType.completeChallenge;
      case 'show_dialog':
        return ActionType.showDialog;
      case 'show_bottom_sheet': // Добавлено
        return ActionType.showBottomSheet;
      default:
        return ActionType.navigate;
    }
  }
}