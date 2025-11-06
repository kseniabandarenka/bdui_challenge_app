import 'package:shared/shared.dart';

abstract class HomeState {}

class HomeInitialState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedState extends HomeState {
  final BDUIScreenModel homeData;
  HomeLoadedState(this.homeData);
}

class HomeErrorState extends HomeState {
  final String error;
  HomeErrorState(this.error);
}
