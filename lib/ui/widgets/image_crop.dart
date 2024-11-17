import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

Future<CroppedFile?> myImageCropper(String filePath) async {
  return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: ThemeData.dark().primaryColor,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
          activeControlsWidgetColor: ThemeData.dark().primaryColor,
        )
      ]);
}
