import 'package:client/domain/use_cases/bdui/get_bdui_home_screen_use_case.dart';
import 'package:client/presentation/pages/home/bloc/home_events.dart';
import 'package:client/presentation/pages/home/bloc/home_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeScreenUseCase getHomeScreenUseCase;

  HomeBloc(this.getHomeScreenUseCase) : super(HomeInitialState()) {
    on<LoadHomeEvent>(_onLoadHome);
  }

  Future<void> _onLoadHome(
    LoadHomeEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoadingState());
    try {
      final bduiElement = await getHomeScreenUseCase.execute();
      emit(HomeLoadedState(bduiElement));
    } catch (e) {
      emit(HomeErrorState(e.toString()));
    }
  }
}
