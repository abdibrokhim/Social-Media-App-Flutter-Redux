import 'dart:io';
import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:socialmediaapp/components/shared/build_cached_image.dart';
import 'package:socialmediaapp/components/shared/error/cuctom_error_widget.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/components/widgets/selected_assets_list_view.dart';
import 'package:socialmediaapp/screens/category/category_reducer.dart';
import 'package:socialmediaapp/screens/explore/single_post/single_post_reducer.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/post/create_post_reducer.dart';
import 'package:socialmediaapp/screens/post/post_model.dart';
import 'package:socialmediaapp/screens/post/update_post_reducer.dart';
import 'package:socialmediaapp/screens/profile/components/renew_subscription_dialog.dart';
import 'package:socialmediaapp/screens/profile/components/subscription_dialog.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/image_picker/image_picker_platform.dart';
import 'package:socialmediaapp/utils/image_picker/picker_method.dart';
import 'package:socialmediaapp/utils/logs.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show
        AssetEntity,
        DefaultAssetPickerProvider,
        DefaultAssetPickerBuilderDelegate;



class EditPostDialog extends StatefulWidget {

  const EditPostDialog({
    Key? key,
  }) : super(key: key);

  @override
  _EditPostDialogState createState() => _EditPostDialogState();
}

class _EditPostDialogState extends State<EditPostDialog>
      with AutomaticKeepAliveClientMixin {
  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool isUploadingImage = false;

  Uint8List? _imageData;
  XFile? _imageFile;
  String? imageUrl;

  List<AssetEntity> assets = <AssetEntity>[];
  int maxAssetsCount = 1;

  late DefaultAssetPickerProvider keepScrollProvider =
      DefaultAssetPickerProvider();
  DefaultAssetPickerBuilderDelegate? keepScrollDelegate;

  List<String> errors = [];

  @override
  void initState() {
    super.initState();

    initErrors();
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  void initErrors() {
    setState(() {
      errors = [];
    });
  }




  @override
  Widget build(BuildContext context) {
    super.build(context);
    Future<void> uploadImageToFirebase() async {
    try {
      AppLog.log().i('Uploading image to firebase storage.');
      String fileName = 'post_${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads/$fileName');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName},
      );

      UploadTask uploadTask;

      if (kIsWeb) {
        uploadTask = firebaseStorageRef.putData(_imageData!, metadata);
      } else {
        uploadTask = firebaseStorageRef.putData(_imageData!, metadata);
        // uploadTask = firebaseStorageRef.putFile(io.File(_imageFile!.path), metadata);
      }

      TaskSnapshot taskSnapshot = await uploadTask;
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      
      AppLog.log().i('Image uploaded to firebase storage.');
      setState(() {
        this.imageUrl = imageUrl;
        isUploadingImage = false;
        print('_uploadImageToFirebase value: $imageUrl');
      });
    } catch (e) {
      print('Failed to upload image to firebase storage: $e');
    }
  }




  Future<void> pickImageFromGalleryWeb() async {
    try {
      XFile? image = await ImagePickerPlatformInterface.pickImageFromGallery();
      if (image != null) {
        Uint8List? data = await image.readAsBytes();
        setState(() {
          _imageFile = image;
          _imageData = data;
          isUploadingImage = true;
          print('image path: ${_imageFile!.path}');
        });
        await uploadImageToFirebase();
        print('image url: $imageUrl');
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<void> pickImageFromCameraWeb() async {
    try {
      XFile? image = await ImagePickerPlatformInterface.pickImageFromCamera();
      if (image != null) {
        Uint8List? data = await image.readAsBytes();
        setState(() {
          _imageFile = image;
          _imageData = data;
          isUploadingImage = true;
          print('image path: ${_imageFile!.path}');
        });
        await uploadImageToFirebase();
        print('image url: $imageUrl');
      }
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }


  Future<void> selectAssets(PickMethod model) async {
    try {
    final List<AssetEntity>? result = await model.method(context, assets);
    if (result != null) {
      File? myFile = await result.first.file;
      if (myFile != null) {
        Uint8List? data = await myFile.readAsBytes();
        if (mounted) {
          setState(() {
            assets = List<AssetEntity>.from(result);
            _imageData = data;
            isUploadingImage = true;
            imageUrl == '';
            print('creating post with assets: $assets');
          });
          await uploadImageToFirebase();
        }
      }
    } 
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Widget buildImageField(BuildContext context) {
    print('current image: ${store.state.appState.singlePostScreenState.post!.image!}');
    return Column(
      children: [
        if (_imageFile != null)
          Image.network(_imageFile!.path, width: 200, height: 200,),
        const SizedBox(height: 16,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildIconButton(
              icon: Icons.photo_library_rounded,
              text: 'Gallery',
              onPressed: () {
                if (kIsWeb) {
                  print('selecting assets in web');
                  pickImageFromGalleryWeb();
                } else {
                  print('selecting assets in IO');
                    selectAssets(
                      PickMethod.cameraAndStay(maxAssetsCount)
                    );
                }
              }
            ),
            buildIconButton(
              icon: Icons.camera_alt_rounded,
              text: 'Camera',
              onPressed: () {
                if (kIsWeb) {
                  print('selecting assets in web');
                  pickImageFromCameraWeb();
                } else {
                  print('selecting assets in IO');
                  selectAssets(
                                        PickMethod.camera(
                  context: context,
                  maxAssetsCount: maxAssetsCount,
                  handleResult: (BuildContext context, AssetEntity result) =>
                      Navigator.of(context).pop(<AssetEntity>[result]),
                ),
            );
                }
              }
            ),
          ],
        ),
      ],
    );
  }


  void removeAsset(int index, String imageKey) {
    setState(() {
      assets.removeAt(index);
      imageUrl = store.state.appState.singlePostScreenState.post!.image!;
    });
    if (assets.isEmpty) {
      isDisplayingDetail.value = false;
    }
  }

  void onResult(List<AssetEntity>? result, String imageKey) {
    if (result != null) {
      if (mounted) {
        setState(() {
          assets = result.toList();
        });
      }
    }
  }
    var categoryState = StoreProvider.of<GlobalState>(context).state.appState.categoryState;

    return Dialog(
      child: SizedBox(
        width: 500,
        height: 500,
        child:
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: StoreConnector<GlobalState, CreatePostState>(
              onInit: (store) {
                _titleController.text = store.state.appState.singlePostScreenState.post!.title;
                _descriptionController.text = store.state.appState.singlePostScreenState.post!.description!;
                imageUrl = store.state.appState.singlePostScreenState.post!.image!;
              },
              converter: (store) => store.state.appState.createPostState,
              builder: (context, createPostState) {
                return SingleChildScrollView(
                  child: 
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Create New Post'),
                      const Divider(),
                  if (errors.isNotEmpty)
                      CustomErrorWidget(
                        errors: errors
                      ),
                      const SizedBox(height: 20,),
                      if (createPostState.isAIAutocompleteRequestLoading)
                        const Column(
                          children: [
                            LinearProgressIndicator(),
                            Padding(padding: EdgeInsets.only(left:16.0, right:16.0),
                              child: 
                                Text('Using AI to generate post title and description. Please wait...'),
                            ),
                          ],
                        ),
                      if (isUploadingImage) 
                        const Column(
                          children: [
                            LinearProgressIndicator(),
                            Padding(padding: EdgeInsets.only(left:16.0, right:16.0),
                              child: 
                                Text('Processing Image. Please wait...'),
                            ),
                          ],
                        ),
                      buildImageField(context),
                      if (assets.isNotEmpty)
                        SelectedAssetsListView(
                          assets: assets,
                          isDisplayingDetail: isDisplayingDetail,
                          onResult: onResult,
                          onRemoveAsset: removeAsset,
                          imageKey: 'create_post',
                        ),
                      if (assets.isEmpty)
                        if (store.state.appState.singlePostScreenState.post!.image!.isNotEmpty)
                          buildCachedImagePlaceHolder(
                              store.state.appState.singlePostScreenState.post!.image!,
                              context,
                            ),
                      imageUrl != null && imageUrl!.isNotEmpty
                      ?
                      Column(
                        children: [
                      const SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text('WTF! is this?'),
                          TextButton(
                            onPressed: () {
                              var user = StoreProvider.of<GlobalState>(context).state.appState.userState.user;
                              print('sub: ${user!.subscription!.isNotEmpty}');
                              
                              if (user.subscription!.isNotEmpty) {
                                DateTime expirationDate = user.subscription![0].expirationDate;
                                DateTime subscriptionDate = user.subscription![0].subscribedDate;
                                bool isExpired = expirationDate.difference(subscriptionDate).inDays > 30;
                              
                                if (isExpired) {
                                  showToast(message: "Your subscription is expired. Please renew your subscription.", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
                                  renewSubscriptionDialog(context);
                                } else {
                                  AppLog.log().i('Using AI to generate post title and description.');
                                  if (imageUrl != null) {
                                    AppLog.log().i('Simulation started.');
                                    store.dispatch(GeminiAutocompleteRequestAction(imageUrl!));
                                    // Use simulation if AI is not working
                                    // store.dispatch(AIAutocompleteSimulateRequestAction());
                                  } else {
                                    showToast(message: "Could not recognize image.", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
                                    AppLog.log().i('Image url is null.');
                                  }
                                }
                              } else {
                                showSubscriptionDialog(context);
                              }
                            },
                            child: const Text('Use AI'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16,),
                    ],) : const SizedBox(),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Enter Post Title'),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(error: 'Please enter a title.');
                          }
                        },
                      ),
                      TextField(
                        maxLines: 6,
                        minLines: 3,
                        controller: _descriptionController,
                        decoration: const InputDecoration(labelText: 'Enter Post Description'),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            removeError(error: 'Please enter a description.');
                          }
                        },
                      ),
                      const SizedBox(height: 40,),
                      Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          buildIconButton(
                            icon: Icons.cancel_rounded,
                            text: 'Cancel',
                            onPressed: () {
                              Navigator.pop(context);
                            }
                          ),
                          buildIconButton(
                            icon: Icons.post_add_rounded,
                            text: 'Update',
                            onPressed: () {
                              if (_imageData == null) {
                                addError(error: 'Please select an image.');
                                return;
                              }

                              if (isUploadingImage) {
                                showToast(message: "Please wait until image is uploaded.", bgColor: getNotificationColor(NotificationColor.blue), webBgColor: "blue");
                                return;
                              }
                              if (imageUrl!.isEmpty || imageUrl == null) {
                                showToast(message: "There was an error while processing image. Please, close dialog and try again.", bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
                                return;
                              }

                              if (_titleController.text.isEmpty) {
                                addError(error: 'Please enter a title.');
                                return;
                              }

                              if (_descriptionController.text.isEmpty) {
                                addError(error: 'Please enter a description.');
                                return;
                              }

                              UpdatePost updatedPost = UpdatePost(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                image: imageUrl,
                              );
                              
                              AppLog.log().i('Creating new post.');

                              if (store.state.appState.userState.selectedPostId != null) {

                                store.dispatch(UpdatePostAction(store.state.appState.userState.selectedPostId!, updatedPost));
                                
                                if (createPostState.createdPostId != null) {
                                  AppLog.log().i('sending single post request');
                                  AppLog.log().i('displaying post id: ${createPostState.createdPostId}');
                                  store.dispatch(SinglePostRequestAction(createPostState.createdPostId!));
                                } else {
                                  showToast(message: "Could not load upodated post. Please try to refresh window.", bgColor: getNotificationColor(NotificationColor.blue), webBgColor: "blue");
                                }
                                
                                AppLog.log().i('fetching user posts');
                                store.dispatch(GetUserPostsAction(store.state.appState.profileScreenState.selectedUserId!));

                                if (createPostState.errors.isNotEmpty) {
                                  showToast(message: createPostState.errors.first, bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
                                } else {
                                  showToast(message: "Post was upodated successfully.", bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
                                }
                              } else {
                                showToast(message: "Could not load upodated post. Please try to refresh window.", bgColor: getNotificationColor(NotificationColor.blue), webBgColor: "blue");
                              }

                              initErrors();
                              
                              Navigator.pop(context);

                            },
                          ),
                        ],
                      )
                    ]
                  ),
                );
              },
              onDidChange: (prev, next) {
                if (next.postInfo != null) {
                  _titleController.text = next.postInfo!.title;
                  _descriptionController.text = next.postInfo!.description;
                }
                if (_imageFile != null) {
                  removeError(error: 'Please select an image.');
                }
              },
              onDispose: (store) {},
            ),
          ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  @override
  bool get wantKeepAlive => true;
}


void showEditPostDialog(BuildContext context) {

  AppLog.log().i('Showing user edit post dialog.');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const EditPostDialog();
    }
  );
}
