import 'package:redux/redux.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';

class CreatePostState {
  final bool isLoading;
  final bool isUploading;
  final bool isPostCreated;
  final bool isProcessing;
  final bool isAIAutocompleteRequestLoading;
  final CreatePost? post;
  final List<String?> errors;
  final int? createdPostId;
  final PostAIGeneration? postInfo;
  final String title;
  final String description;

  CreatePostState({
    this.isLoading = false,
    this.isUploading = false,
    this.isPostCreated = false,
    this.isProcessing = false,
    this.isAIAutocompleteRequestLoading = false,
    this.post,
    this.errors = const [],
    this.createdPostId,
    this.postInfo,
    this.title = '',
    this.description = '',
  });

  factory CreatePostState.initial() => CreatePostState(
    isLoading: false,
    isUploading: false,
    isPostCreated: false,
    isProcessing: false,
    isAIAutocompleteRequestLoading: false,
    errors: List.empty(),
    post: CreatePost(
      title: '',
      description: '',
      image: '',
      categories: List.empty(),
    ),
    postInfo: PostAIGeneration(
      title: '',
      description: '',
    ),
    title: '',
    description: '',
  );

  CreatePostState copyWith({
    bool? isLoading,
    bool? isUploading,
    bool? isPostCreated,
    bool? isProcessing,
    bool? isAIAutocompleteRequestLoading,
    CreatePost? post,
    List<String?>? errors,
    int? createdPostId,
    PostAIGeneration? postInfo,
    String? title,
    String? description,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      isPostCreated: isPostCreated ?? this.isPostCreated,
      isProcessing: isProcessing ?? this.isProcessing,
      isAIAutocompleteRequestLoading: isAIAutocompleteRequestLoading ?? this.isAIAutocompleteRequestLoading,
      post: post ?? this.post,
      errors: errors ?? this.errors,
      createdPostId: createdPostId ?? this.createdPostId,
      postInfo: postInfo ?? this.postInfo,
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}


// ========== Create post reducers ========== //

class CreatePostRequestAction {
  CreatePost post;

  CreatePostRequestAction(
    this.post,
  );
}

CreatePostState createPostRequestReducer(
  CreatePostState state,
  CreatePostRequestAction action,
) {
  return state.copyWith(
    isLoading: true,
  );
}

class CreatePostSuccessAction {
  int postId;

  CreatePostSuccessAction(
    this.postId,
  );
}

CreatePostState createPostSuccessReducer(
  CreatePostState state,
  CreatePostSuccessAction action,
) {
  return state.copyWith(
    isLoading: false,
    isPostCreated: true,
    createdPostId: action.postId,
  );
}


// ========== Create post Error reducers ========== //

class AddErrorAction {
  final String error;

  AddErrorAction(this.error);
}

CreatePostState addErrorReducer(
  CreatePostState state, AddErrorAction action
) {
  if (!state.errors.contains(action.error)) {
    return state.copyWith(isProcessing: false, errors: [...state.errors, action.error]);
  }
  return state;
}

class RemoveErrorAction {
  final String error;

  RemoveErrorAction(this.error);
}

CreatePostState removeErrorReducer(
  CreatePostState state, RemoveErrorAction action
) {
  return state.copyWith(
    isProcessing: false,
    errors: state.errors.where((e) => e != action.error).toList()
  );
}

class RemoveAllErrorsAction {
  RemoveAllErrorsAction();
}

CreatePostState removeAllErrorsReducer(
  CreatePostState state, RemoveAllErrorsAction action
) {
  return state.copyWith(
    isProcessing: false,
    errors: List.empty()
  );
}


// ========== Gpt4AutocompleteRequestAction reducers ========== //

class Gpt4AutocompleteRequestAction {
  final String imageUrl;

  Gpt4AutocompleteRequestAction(this.imageUrl);
}

CreatePostState aIAutocompleteRequestReducer(
  CreatePostState state, Gpt4AutocompleteRequestAction action
) {
  return state.copyWith(
    isAIAutocompleteRequestLoading: true,
  );
}


// ========== Gpt4AutocompleteResponseAction reducers ========== //

class Gpt4AutocompleteResponseAction {
  final PostAIGeneration postInfo;

  Gpt4AutocompleteResponseAction(this.postInfo);
}

CreatePostState aIAutocompleteResponseReducer(
  CreatePostState state, Gpt4AutocompleteResponseAction action
) {
  return state.copyWith(
    isAIAutocompleteRequestLoading: false,
    postInfo: action.postInfo,
  );

}


// ========== GeminiAutocompleteRequestAction reducers ========== //

class GeminiAutocompleteRequestAction {
  final String imageUrl;

  GeminiAutocompleteRequestAction(this.imageUrl);
}

CreatePostState geminiAutocompleteRequestAction(
  CreatePostState state, GeminiAutocompleteRequestAction action
) {
  return state.copyWith(
    isAIAutocompleteRequestLoading: true,
  );
}


// ========== GeminiAutocompleteResponseAction reducers ========== //

class GeminiAutocompleteResponseAction {
  final PostAIGeneration postInfo;

  GeminiAutocompleteResponseAction(this.postInfo);
}

CreatePostState geminiAutocompleteResponseAction(
  CreatePostState state, GeminiAutocompleteResponseAction action
) {
  return state.copyWith(
    isAIAutocompleteRequestLoading: false,
    postInfo: action.postInfo,
  );
}


// ========== AIAutocompleteSimulateRequestAction reducers ========== //

class AIAutocompleteSimulateRequestAction {

  AIAutocompleteSimulateRequestAction();
}

CreatePostState aIAutocompleteSimulateRequestActionReducer(
  CreatePostState state, AIAutocompleteSimulateRequestAction action
) {
  return state.copyWith(
    isAIAutocompleteRequestLoading: true,
  );
}


// ========== AIAutocompleteSimulateResponseAction reducers ========== //

class AIAutocompleteSimulateResponseAction {
  final PostAIGeneration postInfo;

  AIAutocompleteSimulateResponseAction(this.postInfo);
}

CreatePostState aIAutocompleteSimulateResponseReducer(
  CreatePostState state, AIAutocompleteSimulateResponseAction action
) {
  print('title : ${action.postInfo.title}');
  print('description : ${action.postInfo.description}');
  return state.copyWith(
    isAIAutocompleteRequestLoading: false,
    postInfo: action.postInfo,
  );
}


// ========== Combine all reducers ========== //

Reducer<CreatePostState> createPostReducer = combineReducers<CreatePostState>([
  TypedReducer<CreatePostState, CreatePostRequestAction>(createPostRequestReducer),
  TypedReducer<CreatePostState, CreatePostSuccessAction>(createPostSuccessReducer),
  TypedReducer<CreatePostState, AddErrorAction>(addErrorReducer),
  TypedReducer<CreatePostState, RemoveErrorAction>(removeErrorReducer),
  TypedReducer<CreatePostState, RemoveAllErrorsAction>(removeAllErrorsReducer),
  TypedReducer<CreatePostState, Gpt4AutocompleteRequestAction>(aIAutocompleteRequestReducer),
  TypedReducer<CreatePostState, Gpt4AutocompleteResponseAction>(aIAutocompleteResponseReducer),
  TypedReducer<CreatePostState, AIAutocompleteSimulateRequestAction>(aIAutocompleteSimulateRequestActionReducer),
  TypedReducer<CreatePostState, AIAutocompleteSimulateResponseAction>(aIAutocompleteSimulateResponseReducer),
  TypedReducer<CreatePostState, GeminiAutocompleteRequestAction>(geminiAutocompleteRequestAction),
  TypedReducer<CreatePostState, GeminiAutocompleteResponseAction>(geminiAutocompleteResponseAction),
]);