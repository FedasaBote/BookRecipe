import 'package:book_recipe/model/image.dart';
import 'package:book_recipe/model/recipe.dart';
import 'package:book_recipe/state/recipe_provider.dart';
import 'package:book_recipe/widgets/cooking_step_detail.dart';
import 'package:book_recipe/widgets/custom_button.dart';
import 'package:book_recipe/widgets/show_ingredients.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecipeDetail extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetail({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    String formattedTime = '';
    if (recipe.preparationHours != 0) {
      formattedTime += "${recipe.preparationHours} Часов  ";
    }
    if (recipe.preparationMinutes != 0) {
      formattedTime += '${recipe.preparationMinutes} Минут';
    }

    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF4E1),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: width*0.1,
              ),
              SizedBox(
                width: width * 0.8,
                child: Text(
                  recipe.name,
                  textAlign: TextAlign.center,
                  // making overflow to pass to next lin
                  style: TextStyle(
                    // fontFamily: 'Karantina',
                    fontWeight: FontWeight.bold,
                    fontSize: width * 0.1 > 50 ? 50 : width * 0.1,
                  ),
                ),
              ),
              SizedBox(
                height: width * 0.1 > 50 ? 50 : width * 0.1,
              ),
              recipe.mainIndex != null ?
                  FutureBuilder(
                    future: recipeProvider.getImageRecipe(recipe.id!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                      var recipe_images = snapshot.data as List<ImageModel>;
                      var img = recipe_images.isNotEmpty
                          ? recipe_images
                              .where((element) =>
                                  element.index ==
                                  recipe.mainIndex)
                              .toList()[0]
                          : null;
                        // var image = snapshot.data as ImageModel;
                        return SizedBox(
                          height: width * 0.4,
                          width: width * 0.7,
                          child: Image.memory(
                            img!.imageData,
                            fit: BoxFit.fill,
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: width * 0.4,
                          width: width * 0.7,
                          child: Image.asset("assets/images/place_holder.png", fit: BoxFit.fill),
                        );
                      }
                    },
                  )
              : SizedBox(
                height: width * 0.4,
                width: width * 0.7,
                child: Image.asset("assets/images/place_holder.png", fit: BoxFit.fill),
              ),
              SizedBox(
                height: width * 0.075 > 50 ? 50 : width * 0.075,
              ),
              Text(
                "Время приготовления",
                style: TextStyle(
                  // fontFamily: 'Karantina',
                  fontWeight: FontWeight.bold,
                  fontSize: width*0.075 > 50 ? 50 : width*0.075,
                ),
              ),
              SizedBox(
                height: width * 0.075 > 40 ? 40 : width * 0.075,
              ),
              Text(
                formattedTime,
                style: TextStyle(
                  // fontFamily: 'Karantina',
                  fontSize: width*0.06 > 40 ? 40 : width*0.06,
                ),
              ),
              SizedBox(
                height: width * 0.075 > 50 ? 50 : width * 0.075,
              ),
              Text(
                'Ингридиенты',
                style: TextStyle(
                  // fontFamily: 'Karantina',
                  fontSize: width*0.075 > 50 ? 50 : width*0.075,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: width * 0.075 > 50 ? 50 : width * 0.075,
              ),
              ShowIngredients(
                ingredients: recipe.ingredients,
                isVisible: false,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Этапы приготовления',
                style: TextStyle(
                  // fontFamily: 'Karantina',
                  fontSize: width*0.075 > 50 ? 50 : width*0.075,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: width * 0.075 > 50 ? 50 : width * 0.075,
              ),
              CookingStepsDetail(
                cookingSteps: recipe.cookingSteps,
              ),
              SizedBox(
                height: width * 0.075 > 50 ? 50 : width * 0.075,
              ),
            ],
          ),
        ),
        bottomNavigationBar: 
              Container(
                margin: EdgeInsets.symmetric(horizontal: width*0.075).copyWith(bottom: width*0.025),
                child: CustomButton(
                  text: 'Назад',
                  fontSize: width*0.075 > 50 ? 50 : width*0.075,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  size: Size(width * 0.8, width*0.18 > 80 ? 80 : width*0.18),
                ),
              ),
      ),
    );
  }
}
