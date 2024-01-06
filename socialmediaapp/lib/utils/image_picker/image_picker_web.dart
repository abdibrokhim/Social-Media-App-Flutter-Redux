import 'package:image_picker/image_picker.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

class ImagePickerPlatformInterface {
  ImagePickerPlatformInterface._();

  static Future<XFile?> pickImageFromGallery() {
    ImagePickerPlugin imagePicker = ImagePickerPlugin();
    return imagePicker.getImageFromSource(source: ImageSource.gallery);
  }

  static Future<XFile?> pickImageFromCamera() {
    ImagePickerPlugin imagePicker = ImagePickerPlugin();
    return imagePicker.getImageFromSource(source: ImageSource.camera);
  }
}
