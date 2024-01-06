import 'package:redux/redux.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';

class ExploreScreenState {
  final bool isLoading;
  final bool isExplorePostListLoading;
  final bool isTrendingPostListLoading;
  final bool isNewPostListLoading;
  final bool isDiversePostListLoading;
  final List<PostFilter> explorePostList;
  final List<PostFilter> trendingPostList;
  final List<PostFilter> newPostList;
  final List<PostFilter> diversePostList;

  ExploreScreenState({
    this.isLoading = false,
    this.isExplorePostListLoading = false,
    this.isTrendingPostListLoading = false,
    this.isNewPostListLoading = false,
    this.isDiversePostListLoading = false,
    this.explorePostList = const [],
    this.trendingPostList = const [],
    this.newPostList = const [],
    this.diversePostList = const [],
  });

  ExploreScreenState copyWith({
    bool? isLoading,
    bool? isExplorePostListLoading,
    bool? isTrendingPostListLoading,
    bool? isNewPostListLoading,
    bool? isDiversePostListLoading,
    List<PostFilter>? explorePostList,
    List<PostFilter>? trendingPostList,
    List<PostFilter>? newPostList,
    List<PostFilter>? diversePostList,
  }) {
    return ExploreScreenState(
      isLoading: isLoading ?? this.isLoading,
      isExplorePostListLoading: isExplorePostListLoading ?? this.isExplorePostListLoading,
      isTrendingPostListLoading: isTrendingPostListLoading ?? this.isTrendingPostListLoading,
      isNewPostListLoading: isNewPostListLoading ?? this.isNewPostListLoading,
      isDiversePostListLoading: isDiversePostListLoading ?? this.isDiversePostListLoading,
      explorePostList: explorePostList ?? this.explorePostList,
      trendingPostList: trendingPostList ?? this.trendingPostList,
      newPostList: newPostList ?? this.newPostList,
      diversePostList: diversePostList ?? this.diversePostList,
    );
  }
}

// ========== Handle Generic Error ========== //

class HandleGenericErrorAction {}

ExploreScreenState handleGenericErrorReducer(
    ExploreScreenState state, HandleGenericErrorAction action) {
  return state.copyWith(isLoading: false);
}


// ========== Get Explore Post List Reducers ========== //

class GetExplorePostListRequestAction {
  int trending_limit;
  int new_limit;
  int diverse_limit;

  GetExplorePostListRequestAction(
    this.trending_limit,
    this.new_limit,
    this.diverse_limit,
  );
}

ExploreScreenState getExploreScreenStateReducer(ExploreScreenState state, GetExplorePostListRequestAction action) {
  return state.copyWith(
    isExplorePostListLoading: true,
  );
}

class GetExplorePostListSuccessAction {
  List<PostFilter> explorePostList;

  GetExplorePostListSuccessAction(
    this.explorePostList,
  );
}

ExploreScreenState getExplorePostListSuccessReducer(ExploreScreenState state, GetExplorePostListSuccessAction action) {
  return state.copyWith(
    isExplorePostListLoading: false,
    explorePostList: action.explorePostList,
  );
}


// ========== Get Trending Post List Reducers ========== //

class GetTrendingPostListRequestAction {
  int limit;

  GetTrendingPostListRequestAction(
    this.limit,
  );
}

ExploreScreenState getTrendingPostListRequestReducer(ExploreScreenState state, GetTrendingPostListRequestAction action) {
  return state.copyWith(
    isTrendingPostListLoading: true,
  );
}

class GetTrendingPostListSuccessAction {
  List<PostFilter> trendingPostList;

  GetTrendingPostListSuccessAction(
    this.trendingPostList,
  );
}

ExploreScreenState getTrendingPostListSuccessReducer(ExploreScreenState state, GetTrendingPostListSuccessAction action) {
  return state.copyWith(
    isTrendingPostListLoading: false,
    trendingPostList: action.trendingPostList,
  );
}


// ========== Get New Post List Reducers ========== //

class GetNewPostListRequestAction {
  int limit;

  GetNewPostListRequestAction(
    this.limit,
  );
}

ExploreScreenState getNewPostListRequestReducer(ExploreScreenState state, GetNewPostListRequestAction action) {
  return state.copyWith(
    isNewPostListLoading: true,
  );
}

class GetNewPostListSuccessAction {
  List<PostFilter> newPostList;

  GetNewPostListSuccessAction(
    this.newPostList,
  );
}

ExploreScreenState getNewPostListSuccessReducer(ExploreScreenState state, GetNewPostListSuccessAction action) {
  return state.copyWith(
    isNewPostListLoading: false,
    newPostList: action.newPostList,
  );
}


// ========== Get Diverse Post List Reducers ========== //

class GetDiversePostListRequestAction {
  int limit;

  GetDiversePostListRequestAction(
    this.limit,
  );
}

ExploreScreenState getDiversePostListRequestReducer(ExploreScreenState state, GetDiversePostListRequestAction action) {
  return state.copyWith(
    isDiversePostListLoading: true,
  );
}

class GetDiversePostListSuccessAction {
  List<PostFilter> diversePostList;

  GetDiversePostListSuccessAction(
    this.diversePostList,
  );
}

ExploreScreenState getDiversePostListSuccessReducer(ExploreScreenState state, GetDiversePostListSuccessAction action) {
  return state.copyWith(
    isDiversePostListLoading: false,
    diversePostList: action.diversePostList,
  );
}


// ========== Combine all reducers ========== //

Reducer<ExploreScreenState> exploreScreenReducer = combineReducers<ExploreScreenState>([
  TypedReducer<ExploreScreenState, HandleGenericErrorAction>(handleGenericErrorReducer),
  TypedReducer<ExploreScreenState, GetExplorePostListRequestAction>(getExploreScreenStateReducer),
  TypedReducer<ExploreScreenState, GetExplorePostListSuccessAction>(getExplorePostListSuccessReducer),
  TypedReducer<ExploreScreenState, GetTrendingPostListRequestAction>(getTrendingPostListRequestReducer),
  TypedReducer<ExploreScreenState, GetTrendingPostListSuccessAction>(getTrendingPostListSuccessReducer),
  TypedReducer<ExploreScreenState, GetNewPostListRequestAction>(getNewPostListRequestReducer),
  TypedReducer<ExploreScreenState, GetNewPostListSuccessAction>(getNewPostListSuccessReducer),
  TypedReducer<ExploreScreenState, GetDiversePostListRequestAction>(getDiversePostListRequestReducer),
  TypedReducer<ExploreScreenState, GetDiversePostListSuccessAction>(getDiversePostListSuccessReducer),
]);