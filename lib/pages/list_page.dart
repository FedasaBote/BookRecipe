import 'package:book_recipe/model/image.dart';
import 'package:book_recipe/model/recipe.dart';
import 'package:book_recipe/pages/recipe.dart';
import 'package:book_recipe/pages/recipe_detail.dart';
import 'package:book_recipe/state/recipe_provider.dart';
import 'package:book_recipe/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class RecipeList extends StatefulWidget {
  const RecipeList({
    super.key,
    required this.recipes,
  });

  final List<Recipe> recipes;

  @override
  State<RecipeList> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  void initState() {
    super.initState();
    RecipeProvider recipeProvider =
        Provider.of<RecipeProvider>(context, listen: false);
    recipeProvider.loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFAF4E1),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: width * 0.1),
              Text(
                'Мои рецепты',
                style: TextStyle(
                  fontSize: width*0.09 > 50 ? 50 : width*0.09,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: width*0.075 > 40 ? 40 : width*0.075,
              ),
              ListView.separated(
                itemBuilder: (context, index) {
                  return FutureBuilder(
                      future: recipeProvider
                          .getImageRecipe(widget.recipes[index].id!),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: ListTile(
                              leading: Container(
                                width: 48.0,
                                height: 48.0,
                                color: Colors.white,
                              ),
                              title: Container(
                                width: double.infinity,
                                height: 16.0,
                                color: Colors.white,
                              ),
                              subtitle: Container(
                                width: double.infinity,
                                height: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }
                        var recipe_images = snapshot.data as List<ImageModel>;
                        var img = recipe_images.isNotEmpty
                            ? recipe_images
                                .where((element) =>
                                    element.index ==
                                    widget.recipes[index].mainIndex)
                                .toList()[0]
                            : null;
                          return TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetail(
                                    recipe: widget.recipes[index],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              color: Colors.white,
                              height: width*0.25 > 100 ? 100 : width*0.25,
                              child: Row(
                                children: [
                                  SizedBox(width: width * 0.05),
                                  img != null
                                      ? SizedBox(
                                          height: width * 0.175 > 70 ? 70 : width * 0.175,
                                          width: width * 0.25 > 100 ? 100 : width * 0.25,
                                          child: Image.memory(
                                            img.imageData,
                                            fit: BoxFit.fill,
                                          ),
                                      )
                                      : SizedBox(
                                          height: width * 0.175 > 70 ? 70 : width * 0.175,
                                          width: width * 0.25 > 100 ? 100 : width * 0.25,
                                          child: Image.asset("assets/images/place_holder.png", fit: BoxFit.fill)
                                      ),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.recipes[index].name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: width*0.075 > 50 ? 50 : width*0.075,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * 0.05,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Image.asset(
                                          widget.recipes[index].isFavorite
                                              ? "assets/images/filled_star.png"
                                              : "assets/images/empty_star.png",
                                          width: width*0.075 > 50 ? 50 : width*0.075,
                                        ),
                                        onTap: () {
                                          // let's just update the recipe isFavorite
                                          widget.recipes[index].isFavorite =
                                              !widget.recipes[index].isFavorite;
                                          recipeProvider
                                              .updateRecipe(widget.recipes[index]);
                                        },
                                      ),
                                      SizedBox(
                                        height: width*0.025 > 10 ? 10 : width*0.025,
                                      ),
                                      GestureDetector(
                                        child: Image.asset("assets/images/edit.png", width: width*0.075 > 50 ? 50 : width*0.075),
                                        onTap: () {
                                          // first set this recipe as the current recipe
                                          recipeProvider
                                              .setRecipeForEdit(widget.recipes[index]);
                                          // then navigate to the edit recipe page
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const RecipePage(
                                                isEdit: true,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: width * 0.025 > 20 ? 20 : width * 0.025,
                                  ),
                                ],
                              ),
                            ),
                          );
                      });
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: width*0.05 > 20 ? 20 : width*0.05,
                  );
                },
                itemCount: widget.recipes.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
              SizedBox(
                height: width*0.1 > 50 ? 50 : width*0.1,
              ),
              CustomButton(
                text: 'Новый рецепт',
                fontSize: width*0.075 > 60 ? 60 : width*0.075,
                size: Size(
                    width*0.8 > 300 ? 300 : width*0.8, width*0.125 > 80 ? 80 : width*0.125),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecipePage()));
                },
              ),
              SizedBox(
                height: width*0.5 > 200 ? 200 : width*0.5,
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: width*0.05 > 30 ? 30 : width*0.05).copyWith(bottom: width*0.025),
          child: CustomButton(
            text: 'Назад',
            fontSize: width*0.075 > 60 ? 60 : width*0.075,
            size: Size(
                width*0.8 > 300 ? 300 : width*0.8, width*0.16 > 80 ? 80 : width*0.16),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
