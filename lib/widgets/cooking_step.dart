import 'package:book_recipe/model/recipe.dart';
import 'package:book_recipe/state/recipe_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AddStepBottomSheet.dart';

class CookingSteps extends StatelessWidget {
  final bool isEdit;
  final List<CookingStep> cookingSteps;

  const CookingSteps({
    super.key,
    required this.cookingSteps,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    var images = recipeProvider.images;
    return Column(
        children: List.generate(
            cookingSteps.length,
            (index) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Этап ${index + 1}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.06),
                          ),

                          // edit icon
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => AddStepBottomSheet(
                                          isEdit: true,
                                          index: index,
                                          // cookingStep: cookingStep,
                                        ));
                              },
                              icon: Icon(
                                Icons.mode_edit_outline_rounded,
                                size: MediaQuery.of(context).size.width * 0.06,
                                // color: Colors.white,
                                fill: 1.0,
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        cookingSteps[index].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Karantina',
                            fontSize: MediaQuery.of(context).size.width * 0.05),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      cookingSteps[index].index != null
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: AspectRatio(
                                aspectRatio: 5 / 3,
                                child: Image.memory(
                                  images[cookingSteps[index].index!].imageData,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )));
  }
}
