abstract class ProgressState {}

class ProgressInitial extends ProgressState {}

class ProgressLoading extends ProgressState {}

class ProgressSuccess extends ProgressState {}

class ProgressError extends ProgressState {
  final String message;
  ProgressError(this.message);
}
