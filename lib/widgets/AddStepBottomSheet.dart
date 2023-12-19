import 'dart:typed_data';
import 'package:book_recipe/model/recipe.dart';
import 'package:book_recipe/widgets/picture_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/recipe_provider.dart';
import 'custom_button.dart';

class AddStepBottomSheet extends StatefulWidget {
  final bool isEdit;
  final int? index;
  const AddStepBottomSheet({
    super.key,
    this.isEdit = false,
    this.index,
  });

  @override
  State<AddStepBottomSheet> createState() => _AddStepBottomSheetState();
}

class _AddStepBottomSheetState extends State<AddStepBottomSheet> {
  TextEditingController nameController = TextEditingController();
  Uint8List? image;
  bool error = false;
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    var images = recipeProvider.images;

    if (firstTime) {
      RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
      if (widget.isEdit) {
        nameController.text = recipeProvider
            .recipetoDatabase.cookingSteps[widget.index!].description;

        // image should be read from database

        if (recipeProvider.recipetoDatabase.cookingSteps[widget.index!].index !=
            null) {
          image = images[recipeProvider
                  .recipetoDatabase.cookingSteps[widget.index!].index!]
              .imageData;
        }
      }

      firstTime = false;
    }

    double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            width: double.infinity,
            color: const Color(0xFFFAF4E1),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
                    child: Text(
                      'Описание этапа',
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      if (value.isEmpty) {
                        setState(() {
                          error = true;
                          return;
                        });
                      }
                      setState(() {
                        error = false;
                      });
                    },
                    controller: nameController,
                    maxLines: 8,
                    style: TextStyle(
                      fontSize: width * 0.05 > 20 ? 20 : width * 0.05,
                    ),
                    decoration: InputDecoration(
                      errorText: error ? "Required" : null,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      hintText: 'Ввести описание этапа',
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: width * 0.05 > 20 ? 20 : width * 0.05,
                      ),
                    ),
                  ),
                  SizedBox(height: width*0.15),
                  SizedBox(
                    width: width * 0.4 > 200 ? 200 : width * 0.4,
                    height: width * 0.25 > 200 ? 200 : width * 0.25,
                    child: PicturePicker(
                      image: image,
                      onPressed: (img) async {
                        image = await img!.readAsBytes();
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: width*0.025 > 20 ? 20 : width*0.025,
              left: width*0.075 > 20 ? 20 : width*0.075,
              right: width*0.075 > 20 ? 20 : width*0.075,
            child: 
                  CustomButton(
                      text: 'Добавить',
                      size: Size(MediaQuery.sizeOf(context).width * 0.9, 80),
                      onPressed: () {
                        if (nameController.text.isEmpty) {
                          setState(() {
                            error = true;
                          });

                          return;
                        }
                        int? index;
                        if (image != null) {
                          int? imageid = widget.isEdit
                              ? recipeProvider.recipetoDatabase
                                  .cookingSteps[widget.index!].index
                              : null;
                          index = recipeProvider.setImages(
                            image!,
                            null,
                            widget.isEdit,
                            imageid,
                          );
                        }
                        if (widget.isEdit) {
                          recipeProvider
                              .recipetoDatabase
                              .cookingSteps[widget.index!]
                              .description = nameController.text;
                          recipeProvider.recipetoDatabase
                              .cookingSteps[widget.index!].index = index;
                        } else {
                          CookingStep cookingStep = CookingStep(
                            description: nameController.text,
                            index: index,
                          );
                          recipeProvider.addCookingSteps(cookingStep);
                        }
                        Navigator.pop(context);
                      })
          )
        ],
      ),
    );
  }
}

