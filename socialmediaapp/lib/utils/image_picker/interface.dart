import 'package:image_picker/image_picker.dart';

class ImagePickerPlatformInterface {
  ImagePickerPlatformInterface._();

  static Future<XFile?> pickImageFromGallery() {
    throw UnimplementedError();
  }
  static Future<XFile?> pickImageFromCamera() {
    throw UnimplementedError();
  }
}