import 'package:book_recipe/pages/recipetwo.dart';
import 'package:book_recipe/model/recipe.dart';
import 'package:book_recipe/state/recipe_provider.dart';
import 'package:book_recipe/widgets/custom_button.dart';
import 'package:book_recipe/widgets/picture_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({
    super.key,
    this.isEdit = false,
  });
  final bool isEdit;

  @override
  State<RecipePage> createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();
    RecipeProvider recipeProvider =
        Provider.of<RecipeProvider>(context, listen: false);
    Recipe recipe = recipeProvider.recipetoDatabase;

    nameController = TextEditingController();
    nameController.text = recipe.name;
    descriptionController = TextEditingController();
    descriptionController.text = recipe.description ?? "";
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    var images = recipeProvider.images;
    Recipe recipe = recipeProvider.recipetoDatabase;
    var recipe_image = recipeProvider.recipes_images;

    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF4E1),
        body: ListView(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CustomButton(
                text: "Назад",
                fontSize: width * 0.05 > 20 ? 20 : width * 0.05,
                size: Size(width*0.25 > 150 ? 150 : width*0.25, width*0.1 > 40 ? 40 : width*0.1),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Text(
              "Название",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.075 > 40 ? 40 : width * 0.075,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  constraints: BoxConstraints(
                      maxHeight: 50,
                      maxWidth: MediaQuery.of(context).size.width),
                  contentPadding: EdgeInsets.symmetric(horizontal: width*0.02 > 10 ? 10 : width*0.02, vertical: width*0.01 > 5 ? 5 : width*0.01),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  hintText: 'Ввести название блюда',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Text(
              "фото",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.06 > 30 ? 30 : width * 0.06,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: width * 0.025 > 20 ? 20 : width * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: PicturePicker(
                    image: recipe_image[0] != null
                        ? images[recipe_image[0]!].imageData
                        : null,
                    onPressed: (img) async {
                      var imageby = await img!.readAsBytes();
                      recipeProvider.setImages(imageby, 0);
                    },
                  ),
                ),
                Expanded(
                  child: PicturePicker(
                    image: recipe_image[1] != null
                        ? images[recipe_image[1]!].imageData
                        : null,
                    onPressed: (img) async {
                      var imageby = await img!.readAsBytes();
                      recipeProvider.setImages(imageby, 1);
                    },
                  ),
                ),
                Expanded(
                  child: PicturePicker(
                    image: recipe_image[2] != null
                        ? images[recipe_image[2]!].imageData
                        : null,
                    onPressed: (img) async {
                      var imageby = await img!.readAsBytes();
                      recipeProvider.setImages(imageby, 2);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: width * 0.075 > 50 ? 50 : width * 0.075,
            ),
            Text(
              "Описание",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: width * 0.075 > 50 ? 50 : width * 0.075,
                fontWeight: FontWeight.bold,
              ),
            ),

            // wide text field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: descriptionController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    recipe.description = value;
                  }
                },
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width * 0.05 > 20 ? 20 : width * 0.05,
                ),
                maxLines: 10,
                decoration: InputDecoration(
                  constraints: BoxConstraints(
                      maxHeight: 200,
                      maxWidth: MediaQuery.of(context).size.width),
                  contentPadding: const EdgeInsets.all(10),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  hintText: 'Краткое описание блюда',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade200,
                    ),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: width * 0.05 > 20 ? 20 : width * 0.05,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: width*0.05 > 30 ? 30 : width*0.05).copyWith(bottom: width*0.025),
          child: CustomButton(
                        text: "Далее",
                        fontSize: width*0.075 > 60 ? 60 : width*0.075,
                        size: Size(width*0.8, width*0.2 > 80 ? 80 : width*0.2),
                        onPressed: () {
                          // lets's set the name and description here
                          if (nameController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('имя должно быть заполнено'),
                            ));
                            return;
                          }
                          recipe.name = nameController.text;
                          recipe.description = descriptionController.text;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipePageTwo(
                                        isEdit: widget.isEdit,
                                      )));
                        }),
        ),
      ),
    );
  }
}
