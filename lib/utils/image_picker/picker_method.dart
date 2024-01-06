import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

Future<AssetEntity?> _pickFromCamera(BuildContext c) {
  return CameraPicker.pickFromCamera(
    c,
    pickerConfig: const CameraPickerConfig(
      enableRecording: true,
      textDelegate: CameraPickerTextDelegate() 
    ),
  );
}

/// Define a regular pick method.
class PickMethod {
  const PickMethod({
    required this.icon,
    required this.name,
    required this.description,
    required this.method,
    this.onLongPress,
  });

  factory PickMethod.common(BuildContext context, int maxAssetsCount) {
    return PickMethod(
      icon: '📹',
      name: 'Common Picker',
      description: 'Pick assets with common picker.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            textDelegate: const EnglishAssetPickerTextDelegate() 
          ),
        );
      },
    );
  }

  factory PickMethod.image(BuildContext context, int maxAssetsCount) {
    return PickMethod(
      icon: '🖼️',
      name: 'Image Picker',
      description: 'Pick images with image picker.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.image,
            textDelegate: const EnglishAssetPickerTextDelegate() 
          ),
        );
      },
    );
  }

  factory PickMethod.video(BuildContext context, int maxAssetsCount) {
    return PickMethod(
      icon: '🎞',
      name: 'Video Picker',
      description: 'Pick videos with video picker.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.video,
            textDelegate: const EnglishAssetPickerTextDelegate() 
          ),
        );
      },
    );
  }

  factory PickMethod.audio(BuildContext context, int maxAssetsCount) {
    return PickMethod(
      icon: '🎶',
      name: 'Audio Picker',
      description: 'Pick audios with audio picker.',
      method: (BuildContext context, List<AssetEntity> assets) {
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            requestType: RequestType.audio,
            textDelegate: const EnglishAssetPickerTextDelegate() 
          ),
        );
      },
    );
  }

  factory PickMethod.camera({
    required BuildContext context,
    required int maxAssetsCount,
    required Function(BuildContext, AssetEntity) handleResult,
  }) {
    return PickMethod(
      icon: '📷',
      name: 'Camera Picker',
      description: 'Pick assets with camera picker.',
      method: (BuildContext context, List<AssetEntity> assets) {
        const EnglishAssetPickerTextDelegate textDelegate = EnglishAssetPickerTextDelegate();
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            textDelegate: const EnglishAssetPickerTextDelegate() ,
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            specialItemPosition: SpecialItemPosition.prepend,
            specialItemBuilder: (
              BuildContext context,
              AssetPathEntity? path,
              int length,
            ) {
              if (path?.isAll != true) {
                return null;
              }
              return Semantics(
                label: textDelegate.sActionUseCameraHint,
                button: true,
                onTapHint: textDelegate.sActionUseCameraHint,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    Feedback.forTap(context);
                    final AssetEntity? result = await _pickFromCamera(context);
                    if (result != null) {
                      handleResult(context, result);
                    }
                  },
                  child: const Center(
                    child: Icon(Icons.camera_enhance, size: 42.0),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  factory PickMethod.cameraAndStay(int maxAssetsCount) {
    return PickMethod(
      icon: '📸',
      name: 'Camera Picker And Stay',
      description: 'Pick assets with camera picker and stay in picker.',
      method: (BuildContext context, List<AssetEntity> assets) {
        const EnglishAssetPickerTextDelegate textDelegate = EnglishAssetPickerTextDelegate();
        return AssetPicker.pickAssets(
          context,
          pickerConfig: AssetPickerConfig(
            maxAssets: maxAssetsCount,
            selectedAssets: assets,
            specialItemPosition: SpecialItemPosition.prepend,
            specialItemBuilder: (
              BuildContext context,
              AssetPathEntity? path,
              int length,
            ) {
              if (path?.isAll != true) {
                return null;
              }
              return Semantics(
                label: textDelegate.sActionUseCameraHint,
                button: true,
                onTapHint: textDelegate.sActionUseCameraHint,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () async {
                    final AssetEntity? result = await _pickFromCamera(context);
                    if (result == null) {
                      return;
                    }
                    final AssetPicker<AssetEntity, AssetPathEntity> picker =
                        context.findAncestorWidgetOfExactType()!;
                    final DefaultAssetPickerBuilderDelegate builder =
                        picker.builder as DefaultAssetPickerBuilderDelegate;
                    final DefaultAssetPickerProvider p = builder.provider;
                    await p.switchPath(
                      PathWrapper<AssetPathEntity>(
                        path:
                            await p.currentPath!.path.obtainForNewProperties(),
                      ),
                    );
                    p.selectAsset(result);
                  },
                  child: const Center(
                    child: Icon(Icons.camera_enhance, size: 42.0),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  
  final String name;
  final String icon;
  final String description;

  /// The core function that defines how to use the picker.
  final Future<List<AssetEntity>?> Function(
    BuildContext context,
    List<AssetEntity> selectedAssets,
  ) method;

  final GestureLongPressCallback? onLongPress;
}
