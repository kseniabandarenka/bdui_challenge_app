import 'package:client/domain/use_cases/bdui/get_challenge_detail_screen.dart';
import 'package:client/domain/use_cases/track_progress_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'challenge_events.dart';
import 'challenge_states.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final GetChallengeDetailScreenUseCase getChallengeUseCase;
  final TrackProgressUseCase trackProgressUseCase;

  ChallengeBloc(this.getChallengeUseCase, this.trackProgressUseCase)
      : super(ChallengeInitialState()) {
    on<LoadChallengeEvent>(_onLoadChallenge);
    on<TrackProgressEvent>(_onTrackProgress);
  }

  Future<void> _onLoadChallenge(
    LoadChallengeEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    emit(ChallengeLoadingState());
    try {
      final bduiElement = await getChallengeUseCase.call(event.challengeId);
      emit(ChallengeLoadedState(bduiElement.toJson()));
    } catch (e) {
      emit(ChallengeErrorState(e.toString()));
    }
  }

  Future<void> _onTrackProgress(
    TrackProgressEvent event,
    Emitter<ChallengeState> emit,
  ) async {
    try {
      await trackProgressUseCase.call(
        progress: event.progress,
        id: event.challengeId,
      );
      emit(ProgressTrackedState());
    } catch (e) {
      emit(ChallengeErrorState(e.toString()));
    }
  }
}
