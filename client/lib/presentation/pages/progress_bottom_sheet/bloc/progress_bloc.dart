import 'package:client/domain/use_cases/track_progress_usecase.dart';
import 'package:client/presentation/pages/progress_bottom_sheet/bloc/progress_events.dart';
import 'package:client/presentation/pages/progress_bottom_sheet/bloc/progress_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressBottomSheetBloc
    extends Bloc<ProgressBottomSheetEvent, ProgressBottomSheetState> {
  final TrackProgressUseCase trackProgressUseCase;

  ProgressBottomSheetBloc(this.trackProgressUseCase)
      : super(ProgressBottomSheetInitial()) {
    on<SubmitProgressEvent>(_onSubmitProgress);
    on<CloseProgressBottomSheetEvent>(_onCloseProgressBottomSheet);
  }

  Future<void> _onSubmitProgress(
    SubmitProgressEvent event,
    Emitter<ProgressBottomSheetState> emit,
  ) async {
    emit(ProgressBottomSheetLoading());
    try {
      await trackProgressUseCase.execute(
        progress: event.progress,
        id: event.challengeId,
      );
      emit(ProgressBottomSheetSuccess());
    } catch (e) {
      emit(ProgressBottomSheetError('Ошибка сохранения: $e'));
    }
  }

  void _onCloseProgressBottomSheet(
    CloseProgressBottomSheetEvent event,
    Emitter<ProgressBottomSheetState> emit,
  ) {
    emit(ProgressBottomSheetInitial());
  }
}
