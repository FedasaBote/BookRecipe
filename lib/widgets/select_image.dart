import 'package:flutter/material.dart';
import '../model/image.dart';

class SelectImageDialog extends StatelessWidget {
  const SelectImageDialog({Key? key}) : super(key: key);

  final List<ImageModel> images = const [];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Выберите изображение"),
      content: SizedBox(
        height: 300,
        width: 300,
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(
            images.length,
            (index) => GestureDetector(
              onTap: () {
                Navigator.pop(context, images[index]);
              },
              child: Image.memory(
                images[index].imageData,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
