import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

typedef ImagePickerFunction = void Function(XFile? image);

class PicturePicker extends StatelessWidget {
  const PicturePicker({
    super.key,
    this.onPressed,
    this.image,
  });

  final ImagePickerFunction? onPressed;
  final Uint8List? image;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    return GestureDetector(
      onTap: () {
        if (onPressed != null) _showPicker(context);
      },
      child: Container(
        height: width * 0.25,
        margin: EdgeInsets.symmetric(
          horizontal: width * 0.04 > 10 ? 10 : width * 0.04,
        ),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/place_holder.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: image != null
              ? Image.memory(
                  image!,
                  height: width*0.25,
                  fit: BoxFit.fill,
                )
              : null
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  _imgFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _imgFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _imgFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 700,
    );
    if (image != null) {
      onPressed!(image);
    }
  }

  _imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 700,
    );
    if (image != null) {
      onPressed!(image);
    }
  }
}
