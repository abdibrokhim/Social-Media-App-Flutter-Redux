import 'package:redux/redux.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';

class HomeScreenState {
  final bool isLoading;
  final bool isMadeForYouLoading;
  final bool isViralLoading;
  final List<PostFilter> madeForYouPostList;
  final List<PostFilter> viralPostList;

  HomeScreenState({
    this.isLoading = false,
    this.isMadeForYouLoading = false,
    this.isViralLoading = false,
    this.madeForYouPostList = const [],
    this.viralPostList = const [],
  });

  HomeScreenState copyWith({
    bool? isLoading,
    bool? isMadeForYouLoading,
    bool? isViralLoading,
    List<PostFilter>? madeForYouPostList,
    List<PostFilter>? viralPostList,
  }) {
    return HomeScreenState(
      isLoading: isLoading ?? this.isLoading,
      isMadeForYouLoading: isMadeForYouLoading ?? this.isMadeForYouLoading,
      isViralLoading: isViralLoading ?? this.isViralLoading,
      madeForYouPostList: madeForYouPostList ?? this.madeForYouPostList,
      viralPostList: viralPostList ?? this.viralPostList,
    );
  }
}


// ========== Get Viral Post List Reducers ========== //

class GetViralPostListRequestAction {
  int limit;
  int offset;

  GetViralPostListRequestAction(
    this.limit,
    this.offset,
  );
}

HomeScreenState getViralPostListRequestReducer(
  HomeScreenState state,
  GetViralPostListRequestAction action,
) {
  return state.copyWith(
    isViralLoading: true,
  );
}

class GetViralPostListSuccessAction {
  List<PostFilter> viralPostList;

  GetViralPostListSuccessAction(
    this.viralPostList,
  );
}

HomeScreenState getViralPostListSuccessReducer(
  HomeScreenState state,
  GetViralPostListSuccessAction action,
) {
  return state.copyWith(
    isViralLoading: false,
    viralPostList: action.viralPostList,
  );
}


// ========== Get Made For You Post List Reducers ========== //

class GetMadeForYouPostListRequestAction {
  int limit;
  int offset;

  GetMadeForYouPostListRequestAction(
    this.limit,
    this.offset,
  );
}

HomeScreenState getMadeForYouPostListRequestReducer(
  HomeScreenState state,
  GetMadeForYouPostListRequestAction action,
) {
  return state.copyWith(
    isMadeForYouLoading: true,
  );
}

class GetMadeForYouPostListSuccessAction {
  List<PostFilter> madeForYouPostList;

  GetMadeForYouPostListSuccessAction(
    this.madeForYouPostList,
  );
}

HomeScreenState getMadeForYouPostListSuccessReducer(
  HomeScreenState state,
  GetMadeForYouPostListSuccessAction action,
) {
  return state.copyWith(
    isMadeForYouLoading: false,
    madeForYouPostList: action.madeForYouPostList,
  );
}


// ========== Handle Generic Error ========== //

class HandleGenericErrorAction {}

HomeScreenState handleGenericErrorReducer(
    HomeScreenState state, HandleGenericErrorAction action) {
  return state.copyWith(
    isLoading: false,
  );
}


// ========== Combine all reducers ========== //

Reducer<HomeScreenState> homeScreenReducer = combineReducers<HomeScreenState>([
  TypedReducer<HomeScreenState, GetMadeForYouPostListRequestAction>(getMadeForYouPostListRequestReducer),
  TypedReducer<HomeScreenState, GetMadeForYouPostListSuccessAction>(getMadeForYouPostListSuccessReducer),
  TypedReducer<HomeScreenState, HandleGenericErrorAction>(handleGenericErrorReducer),
  TypedReducer<HomeScreenState, GetViralPostListRequestAction>(getViralPostListRequestReducer),
  TypedReducer<HomeScreenState, GetViralPostListSuccessAction>(getViralPostListSuccessReducer),
]);