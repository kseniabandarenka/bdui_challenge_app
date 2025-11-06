abstract class ProgressBottomSheetState {}

class ProgressBottomSheetInitial extends ProgressBottomSheetState {}

class ProgressBottomSheetLoading extends ProgressBottomSheetState {}

class ProgressBottomSheetSuccess extends ProgressBottomSheetState {}

class ProgressBottomSheetError extends ProgressBottomSheetState {
  final String message;
  ProgressBottomSheetError(this.message);
}
