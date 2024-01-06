import 'package:image_picker/image_picker.dart';

class ImagePickerPlatformInterface {
  ImagePickerPlatformInterface._();

  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImageFromGallery() {
    return _picker.pickImage(source: ImageSource.gallery);
  }

  static Future<XFile?> pickImageFromCamera() {
    return _picker.pickImage(source: ImageSource.camera);
  }
}
