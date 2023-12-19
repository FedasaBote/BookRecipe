import 'package:book_recipe/model/image.dart';
import 'package:book_recipe/model/recipe.dart';
import 'package:book_recipe/state/recipe_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CookingStepsDetail extends StatelessWidget {
  final List<CookingStep> cookingSteps;

  const CookingStepsDetail({
    super.key,
    required this.cookingSteps,
  });

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    // var images = recipeProvider.images;
    return Column(
      children: List.generate(
        cookingSteps.length,
        ((index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Этап ${index + 1}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.06),
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
                if (cookingSteps[index].imageId != null)
                  FutureBuilder(
                    future:
                        recipeProvider.getImage(cookingSteps[index].imageId!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        // let;s show some shimmer here
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: AspectRatio(
                              aspectRatio: 5 / 3,
                              child: Container(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      }
                      var image = snapshot.data as ImageModel;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: AspectRatio(
                          aspectRatio: 5 / 3,
                          child: Image.memory(
                            image.imageData,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    },
                  )
              ],
            ),
          );
        }),
      ),
    );
  }
}
