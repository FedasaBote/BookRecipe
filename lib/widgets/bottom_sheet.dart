import 'dart:typed_data';
import 'package:book_recipe/widgets/picture_picker.dart';
import 'package:flutter/material.dart';

class BottomSheetWidget extends StatefulWidget {
  const BottomSheetWidget({super.key});

  @override
  State<BottomSheetWidget> createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  TextEditingController nameController = TextEditingController();
  Uint8List? image;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                // in english in brackets
                'Описание этапа (Description of the stage)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: nameController,
                maxLines: 6,
                decoration: const InputDecoration(
                  hintText:
                      'Нарезать хлеб/батон на ломтики (Cut the bread / loaf into slices)',
                ),
              ),
              const SizedBox(height: 12),
              PicturePicker(
                image: image != null ? image! : null,
                onPressed: (img) {
                  setState(() async {
                    image = await img!.readAsBytes();
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

// void bottom_sheet(
//   BuildContext context,
// ) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     builder: (BuildContext context) {
//       return const BottomSheetWidget();
//     },
//   );
// }
