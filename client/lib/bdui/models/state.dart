// Модель для состояния BDUI приложения
class BDUIState {
  final Map<String, dynamic> data;
  final Map<String, dynamic> userData;
  final String currentScreen;
  final Map<String, dynamic> navigationState;

  BDUIState({
    required this.data,
    required this.userData,
    required this.currentScreen,
    required this.navigationState,
  });

  BDUIState copyWith({
    Map<String, dynamic>? data,
    Map<String, dynamic>? userData,
    String? currentScreen,
    Map<String, dynamic>? navigationState,
  }) {
    return BDUIState(
      data: data ?? this.data,
      userData: userData ?? this.userData,
      currentScreen: currentScreen ?? this.currentScreen,
      navigationState: navigationState ?? this.navigationState,
    );
  }

  factory BDUIState.initial() {
    return BDUIState(
      data: {},
      userData: {},
      currentScreen: 'home',
      navigationState: {},
    );
  }
}

// Класс для управления состоянием BDUI
class BDUIStateManager {
  BDUIState _state = BDUIState.initial();
  final List<Function(BDUIState)> _listeners = [];

  BDUIState get state => _state;

  void updateState(BDUIState newState) {
    _state = newState;
    _notifyListeners();
  }

  void updateData(String key, dynamic value) {
    final newData = Map<String, dynamic>.from(_state.data);
    newData[key] = value;
    
    updateState(_state.copyWith(data: newData));
  }

  void updateUserData(String key, dynamic value) {
    final newUserData = Map<String, dynamic>.from(_state.userData);
    newUserData[key] = value;
    
    updateState(_state.copyWith(userData: newUserData));
  }

  void navigateTo(String screen, {Map<String, dynamic>? params}) {
    final newNavigationState = Map<String, dynamic>.from(_state.navigationState);
    newNavigationState['params'] = params ?? {};
    
    updateState(_state.copyWith(
      currentScreen: screen,
      navigationState: newNavigationState,
    ));
  }

  void addListener(Function(BDUIState) listener) {
    _listeners.add(listener);
  }

  void removeListener(Function(BDUIState) listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener(_state);
    }
  }
}