import 'package:flutter/material.dart';
import 'package:redux/redux.dart';


class SettingsState {
  final bool isLoading;
  ThemeMode? theme = ThemeMode.system;

  SettingsState({
    this.isLoading = false,
    this.theme
  });

  SettingsState copyWith({
    bool? isLoading,
    ThemeMode? theme,
  }) {
    return SettingsState(
      isLoading: isLoading ?? this.isLoading,
      theme: theme ?? this.theme,
    );
  }
}


// ==========  change app theme reducers ========== //

class ChangeAppThemeAction {
  ThemeMode themeMode;

  ChangeAppThemeAction(
    this.themeMode,
  );
}

SettingsState changeAppThemeActionReducer(
  SettingsState state,
  ChangeAppThemeAction action,
) {
  return state.copyWith(
    theme: action.themeMode,
  );
}


// ========== Combine all reducers ========== //

Reducer<SettingsState> settingsReducer = combineReducers<SettingsState>([
  TypedReducer<SettingsState, ChangeAppThemeAction>(changeAppThemeActionReducer),
]);