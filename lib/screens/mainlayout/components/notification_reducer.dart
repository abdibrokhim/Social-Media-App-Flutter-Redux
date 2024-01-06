import 'package:flutter/material.dart';
import 'package:redux/redux.dart';


enum NotificationColor { red, green, blue }

// ========== return Notification color ========== //

Color getNotificationColor(NotificationColor color) {
  switch (color) {
    case NotificationColor.red:
      return Colors.red;
    case NotificationColor.green:
      return Colors.green;
    case NotificationColor.blue:
      return Colors.blue;
    default:
      return Colors.transparent;
  }
}

class AwesomeNotificationState {
  final bool isLoading;
  final String? text;
  final Color? color;
  final int? duration;

  AwesomeNotificationState({
    this.isLoading = false,
    this.text,
    this.color,
    this.duration,
});

  AwesomeNotificationState.initialState()
      : isLoading = false,
        text = '',
        color = Colors.red,
        duration = 400;
        

  AwesomeNotificationState copyWith({
    bool? isLoading,
    String? text, 
    Color? color,
    int? duration,
  }) {
    return AwesomeNotificationState(
      isLoading: isLoading ?? this.isLoading,
      text: text ?? this.text,
      color: color ?? this.color,
      duration: duration ?? this.duration,
    );
  }
}


// ========== Show Notification reducers ========== //


class ShowNotificationAction {
  final String text;
  final Color color;
  final int? duration;

  ShowNotificationAction(this.text, this.color, {this.duration});
}

AwesomeNotificationState showNotificationReducer(AwesomeNotificationState state, ShowNotificationAction action) {
  return state.copyWith(
    isLoading: true,
    text: action.text,
    color: action.color,
    duration: action.duration,
  );
}


// ========== Hide Notification reducers ========== //

class HideNotificationAction {}

AwesomeNotificationState hideNotificationReducer(AwesomeNotificationState state, HideNotificationAction action) {
  return AwesomeNotificationState.initialState();
}


// ========== Combine all reducers ========== //

Reducer<AwesomeNotificationState> awesomeNotificationReducer = combineReducers<AwesomeNotificationState>([
  TypedReducer<AwesomeNotificationState, ShowNotificationAction>(showNotificationReducer),
  TypedReducer<AwesomeNotificationState, HideNotificationAction>(hideNotificationReducer),
]);