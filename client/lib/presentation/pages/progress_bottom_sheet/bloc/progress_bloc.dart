import 'package:client/domain/use_cases/track_progress_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'progress_events.dart';
import 'progress_states.dart';


class ProgressBloc extends Bloc<ProgressEvent, ProgressState> {
  final TrackProgressUseCase trackProgressUseCase;

  ProgressBloc(this.trackProgressUseCase) : super(ProgressInitial()) {
    on<SaveProgressEvent>(_onSaveProgress);
  }

  Future<void> _onSaveProgress(
    SaveProgressEvent event,
    Emitter<ProgressState> emit,
  ) async {
    emit(ProgressLoading());
    try {
      await trackProgressUseCase.call(
        progress: event.progress,
        id: event.challengeId,
      );
      emit(ProgressSuccess());
    } catch (e) {
      emit(ProgressError(e.toString()));
    }
  }
}
