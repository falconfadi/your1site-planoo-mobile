import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PickImage {

  static Future<void> selectImage({required File? image}) async {
    final imagePicker = ImagePicker();
    var pickedFile = await imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
  }

}