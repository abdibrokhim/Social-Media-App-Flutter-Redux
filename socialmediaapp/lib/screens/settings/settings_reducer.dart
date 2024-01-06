import 'package:redux/redux.dart';


class SettingsState {
  final bool isLoading;

  SettingsState({
    this.isLoading = false,
  });

  SettingsState copyWith({
    bool? isLoading,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}


// ========== Combine all reducers ========== //

Reducer<SettingsState> settingsReducer = combineReducers<SettingsState>([
  
]);