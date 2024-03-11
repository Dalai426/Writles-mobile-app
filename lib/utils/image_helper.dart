
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper{
  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper
  }) : _imagePicker = imagePicker ?? ImagePicker(),
  _imageCropper= imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future<XFile?> pickImage({
    ImageSource source=ImageSource.gallery,
    int imageQuality=100
  })async{
    return await _imagePicker.pickImage(source: source, imageQuality: imageQuality);
  }

  Future<CroppedFile?> crop({required XFile file, required BuildContext context,CropStyle cropStyle=CropStyle.rectangle}) async =>
      await _imageCropper.cropImage(sourcePath: file.path, cropStyle: cropStyle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              dimmedLayerColor: Colors.white,
              backgroundColor: Colors.white,
              toolbarTitle: '',
              activeControlsWidgetColor: Theme.of(context).colorScheme.secondary,
              toolbarColor: Theme.of(context).colorScheme.primary,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
          ),
        ],
      );
}
