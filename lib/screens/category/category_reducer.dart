import 'package:socialmediaapp/components/category/category_model.dart';
import 'package:redux/redux.dart';


class CategoryState {
  final bool isLoading;
  final List<Category>? categories;

  CategoryState({
    this.isLoading = false,
    this.categories,
  });

  CategoryState copyWith({
    bool? isLoading,
    List<Category>? categories,
  }) {
    return CategoryState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
    );
  }
}


// ========== Get Post List Reducers ========== //

class GetCategoryListAction {}

CategoryState getCategoryListActionReducer(CategoryState state, GetCategoryListAction action) {
  return state.copyWith(isLoading: true);
}

class GetCategoryListResponseAction {
  final List<Category> categories;

  GetCategoryListResponseAction(this.categories);
}

CategoryState getCategoryListResponseReducer(CategoryState state, GetCategoryListResponseAction action) {
  return state.copyWith(
    categories: action.categories,
    isLoading: false,
  );
}



// ========== Combine all reducers ========== //

Reducer<CategoryState> categoryReducer = combineReducers<CategoryState>([
  TypedReducer<CategoryState, GetCategoryListAction>(getCategoryListActionReducer),
  TypedReducer<CategoryState, GetCategoryListResponseAction>(getCategoryListResponseReducer),
]);