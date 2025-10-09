import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PickImage {

  static Future<File?> selectImage({required ImageSource imageSource}) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(
      source: imageSource,
      imageQuality: 25,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}