import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialmediaapp/components/shared/error/cuctom_error_widget.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';
import 'package:socialmediaapp/components/shared/toast.dart';
import 'package:socialmediaapp/components/widgets/selected_assets_list_view.dart';
import 'package:socialmediaapp/screens/mainlayout/components/notification_reducer.dart';
import 'package:socialmediaapp/screens/profile/profile_screen_reducer.dart';
import 'package:socialmediaapp/screens/user/user_model.dart';
import 'package:socialmediaapp/screens/user/user_reducer.dart';
import 'package:socialmediaapp/store/app/app_store.dart';
import 'package:socialmediaapp/utils/image_picker/picker_method.dart';
import 'package:socialmediaapp/utils/logs.dart';
import 'package:socialmediaapp/utils/image_picker/image_picker_platform.dart';
import 'dart:io' as io;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart'
    show
        AssetEntity,
        DefaultAssetPickerProvider,
        DefaultAssetPickerBuilderDelegate;



class EditUserInfoDialog extends StatefulWidget {

  const EditUserInfoDialog({
    Key? key,
  }) : super(key: key);

  @override
  _EditUserInfoDialogState createState() => _EditUserInfoDialogState();
}

class _EditUserInfoDialogState extends State<EditUserInfoDialog> 
      with AutomaticKeepAliveClientMixin {
  final ValueNotifier<bool> isDisplayingDetail = ValueNotifier<bool>(true);

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();


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
        uploadTask = firebaseStorageRef.putFile(io.File(_imageFile!.path), metadata);
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
            print('creating post with assets: $assets');
          });
          await uploadImageToFirebase();
        }
      }
    }
  }

  Widget buildImageField(BuildContext context) {
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
                      PickMethod.image(context, maxAssetsCount)
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


    var state = StoreProvider.of<GlobalState>(context).state.appState.profileScreenState;

    return Dialog(
      child: SizedBox(
        width: 500,
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: StoreConnector<GlobalState, User?>(
            onInit: (store) {
              _firstNameController.text = state.user!.firstName!;
              _lastNameController.text =  state.user!.lastName!;
            },
            converter: (store) => store.state.appState.profileScreenState.user,
            builder: (context, user) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Edit User Info'),
                    const Divider(),
                                      if (errors.isNotEmpty)
                      CustomErrorWidget(
                        errors: errors
                      ),
                      const SizedBox(height: 20,),
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
                          imageKey: 'edit_user_info',
                        ),
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'First Name'),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: 'Please enter a first name.');
                        }
                      },
                    ),
                    TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Last Name'),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          removeError(error: 'Please enter a last name.');
                        }
                      },
                    ),
                    Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        buildIconButton(
                          icon: Icons.cancel,
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        buildIconButton(
                          icon: Icons.save,
                          text: 'Save',
                          onPressed: () {
                            if (isUploadingImage) {
                              showToast(message: "Please wait until image is uploaded.", bgColor: getNotificationColor(NotificationColor.blue), webBgColor: "blue");
                              return;
                            }
                                                          if (_firstNameController.text.isEmpty) {
                                addError(error: 'Please enter a first name.');
                                return;
                              }

                              if (_lastNameController.text.isEmpty) {
                                addError(error: 'Please enter a last name.');
                                return;
                              }

                            AppLog.log().i('Saving user info id: ${state.selectedUserId!}');
                            UpdateUser updatedLink = UpdateUser(
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              profileImage: imageUrl,
                            );
                            store.dispatch(UpdateUserAction(updatedLink));
                            AppLog.log().i('fetching user info');
                            store.dispatch(GetUpdatedUserAction());
                            if (state.errors.isNotEmpty) {
                              showToast(message: state.errors.first, bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
                            } else {
                              showToast(message: "User info was updated successfully. Please, refresh window if don't see changes.", bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
                            }
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    )
                  ]
                ),
              );
            }
          ),
        ),
      ),
    );
  }
  
  @override
  bool get wantKeepAlive => true;
}


void showEditUserInfoDialog(BuildContext context) {

  AppLog.log().i('Showing user profile edit small info dialog.');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const EditUserInfoDialog();
    }
  );
}