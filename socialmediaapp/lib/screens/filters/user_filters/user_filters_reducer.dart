import 'package:redux/redux.dart';
import 'package:socialmediaapp/screens/post/components/likes_model.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';


class UserFiltersState {
  final bool isLoading;
  final bool isAutoCompleteLoading;
  final List<PostLikedUser>? users;
  final String? filterText;
  final List<UserAutoComplete> autoCompleteList;

  UserFiltersState({
    this.isLoading = false,
    this.isAutoCompleteLoading = false,
    this.users,
    this.filterText,
    this.autoCompleteList = const [],
  });

  UserFiltersState copyWith({
    bool? isLoading,
    bool? isAutoCompleteLoading,
    List<PostLikedUser>? users,
    String? filterText,
    List<UserAutoComplete>? autoCompleteList,
  }) {
    return UserFiltersState(
      isLoading: isLoading ?? this.isLoading,
      isAutoCompleteLoading: isAutoCompleteLoading ?? this.isAutoCompleteLoading,
      users: users ?? this.users,
      filterText: filterText ?? this.filterText,
      autoCompleteList: autoCompleteList ?? this.autoCompleteList,
    );
  }
}


// ========== Auto Complete reducers ========== //

class AutoCompleteUserRequestAction {
  final String filterText;

  AutoCompleteUserRequestAction(
    this.filterText,
  );

}

UserFiltersState autoCompleteRequestReducer(
  UserFiltersState state,
  AutoCompleteUserRequestAction action,
) {
  return state.copyWith(
    isAutoCompleteLoading: true,
    filterText: action.filterText,
  );
}

class AutoCompleteUserSuccessAction {
  final List<UserAutoComplete> users;

  AutoCompleteUserSuccessAction(
    this.users,
  );
}


UserFiltersState autoCompleteSuccessReducer(
  UserFiltersState state,
  AutoCompleteUserSuccessAction action,
) {
  return state.copyWith(
    isAutoCompleteLoading: false,
    autoCompleteList: action.users,
  );
}



// ========== Handle Generic Error ========== //

class HandleGenericErrorAction {}

UserFiltersState handleGenericErrorReducer(
    UserFiltersState state, HandleGenericErrorAction action) {
  return state.copyWith(isLoading: false);
}


// ========== Filter Users Reducer ========== //

class FilterUsersRequestAction {
  final String filterText;

  FilterUsersRequestAction(
    this.filterText,
  );
}

UserFiltersState filterUsersRequestReducer(
  UserFiltersState state,
  FilterUsersRequestAction action,
) {
  return state.copyWith(isLoading: true);
}

class FilterUsersSuccessAction {
  final List<PostLikedUser> users;

  FilterUsersSuccessAction(
    this.users,
  );
}

UserFiltersState filterUsersSuccessReducer(
  UserFiltersState state,
  FilterUsersSuccessAction action,
) {
  return state.copyWith(
    isLoading: false,
    users: action.users,
  );
}


// ========== Combine all reducers ========== //

Reducer<UserFiltersState> userFiltersReducer = combineReducers<UserFiltersState>([
  TypedReducer<UserFiltersState, HandleGenericErrorAction>(handleGenericErrorReducer),
  TypedReducer<UserFiltersState, FilterUsersRequestAction>(filterUsersRequestReducer),
  TypedReducer<UserFiltersState, FilterUsersSuccessAction>(filterUsersSuccessReducer),
  TypedReducer<UserFiltersState, AutoCompleteUserRequestAction>(autoCompleteRequestReducer),
  TypedReducer<UserFiltersState, AutoCompleteUserSuccessAction>(autoCompleteSuccessReducer),
]);