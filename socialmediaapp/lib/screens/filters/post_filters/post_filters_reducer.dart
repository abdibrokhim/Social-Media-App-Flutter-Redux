import 'package:redux/redux.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';


class PostFiltersState {
  final bool isLoading;
  final bool isAutoCompleteLoading;
  final List<PostFilter>? posts;
  final String? filterText;
  final List<PostMetaInfo>? postMetaInfo;
  final List<PostAutocomplete> autoCompleteList;

  PostFiltersState({
    this.isLoading = false,
    this.isAutoCompleteLoading = false,
    this.posts,
    this.filterText,
    this.postMetaInfo,
    this.autoCompleteList = const [],
  });

  PostFiltersState copyWith({
    bool? isLoading,
    bool? isAutoCompleteLoading,
    List<PostFilter>? posts,
    String? filterText,
    List<PostMetaInfo>? postMetaInfo,
    List<PostAutocomplete>? autoCompleteList,
  }) {
    return PostFiltersState(
      isLoading: isLoading ?? this.isLoading,
      isAutoCompleteLoading: isAutoCompleteLoading ?? this.isAutoCompleteLoading,
      posts: posts ?? this.posts,
      filterText: filterText ?? this.filterText,
      postMetaInfo: postMetaInfo ?? this.postMetaInfo,
      autoCompleteList: autoCompleteList ?? this.autoCompleteList,
    );
  }
}



// ========== Auto Complete reducers ========== //

class AutoCompletePostRequestAction {
  final String filterText;

  AutoCompletePostRequestAction(
    this.filterText,
  );

}

PostFiltersState autoCompleteRequestReducer(
  PostFiltersState state,
  AutoCompletePostRequestAction action,
) {
  return state.copyWith(
    isAutoCompleteLoading: true,
    filterText: action.filterText,
  );
}

class AutoCompletePostSuccessAction {
  final List<PostAutocomplete> posts;

  AutoCompletePostSuccessAction(
    this.posts,
  );
}


PostFiltersState autoCompleteSuccessReducer(
  PostFiltersState state,
  AutoCompletePostSuccessAction action,
) {
  return state.copyWith(
    isAutoCompleteLoading: false,
    autoCompleteList: action.posts,
  );
}


// ========== Handle Generic Error ========== //

class HandleGenericErrorAction {}

PostFiltersState handleGenericErrorReducer(
    PostFiltersState state, HandleGenericErrorAction action) {
  return state.copyWith(isLoading: false);
}


// ========== Filter Posts Reducer ========== //

class FilterPostsRequestAction {
  final String filterText;

  FilterPostsRequestAction(
    this.filterText,
  );
}

PostFiltersState filterPostsRequestReducer(
  PostFiltersState state,
  FilterPostsRequestAction action,
) {
  return state.copyWith(isLoading: true);
}

class FilterPostsSuccessAction {
  final List<PostFilter> posts;

  FilterPostsSuccessAction(
    this.posts,
  );
}

PostFiltersState filterPostsSuccessReducer(
  PostFiltersState state,
  FilterPostsSuccessAction action,
) {
  return state.copyWith(
    isLoading: false,
    posts: action.posts,
  );
}


// ========== Combine all reducers ========== //

Reducer<PostFiltersState> postFiltersReducer = combineReducers<PostFiltersState>([
  TypedReducer<PostFiltersState, HandleGenericErrorAction>(handleGenericErrorReducer),
  TypedReducer<PostFiltersState, FilterPostsRequestAction>(filterPostsRequestReducer),
  TypedReducer<PostFiltersState, FilterPostsSuccessAction>(filterPostsSuccessReducer),
  TypedReducer<PostFiltersState, AutoCompletePostRequestAction>(autoCompleteRequestReducer),
  TypedReducer<PostFiltersState, AutoCompletePostSuccessAction>(autoCompleteSuccessReducer),
]);