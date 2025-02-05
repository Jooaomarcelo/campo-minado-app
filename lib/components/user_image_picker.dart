import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File image) onImagePick;

  const UserImagePicker({
    required this.onImagePick,
    super.key,
  });

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _image;

  void _pickImage() async {
    final picker = ImagePicker();

    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedImage == null) {
      return;
    }

    final cropper = ImageCropper();
    final croppedImage = await cropper.cropImage(
      sourcePath: pickedImage.path,
      maxWidth: 150,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Editar imagem',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
        IOSUiSettings(
          title: 'Editar imagem',
          aspectRatioLockEnabled: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
          ],
        ),
      ],
    );

    if (croppedImage == null) {
      return;
    }

    setState(() {
      _image = File(croppedImage.path);
    });

    widget.onImagePick(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: DottedBorder(
        padding: EdgeInsets.all(10),
        borderType: BorderType.RRect,
        radius: Radius.circular(12),
        dashPattern: [7, 4],
        color: Colors.white,
        strokeWidth: 2,
        child: Container(
          width: 140,
          alignment: Alignment.center,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Color.fromRGBO(42, 43, 56, 1),
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? Icon(
                        Icons.upload_file,
                        size: 40,
                        color: Colors.white,
                      )
                    : null,
              ),
              Text('Adicionar imagem'),
            ],
          ),
        ),
      ),
    );
  }
}
