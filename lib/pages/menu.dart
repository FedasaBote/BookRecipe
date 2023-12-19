import 'package:book_recipe/pages/favorite_page.dart';
import 'package:book_recipe/pages/recipe.dart';
import 'package:book_recipe/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/recipe_provider.dart';
import 'list_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/hat.png", width: width * 0.6),
            SizedBox(
              height: width * 0.1,
            ),
            Text(
              "Книга рецептов",
              style: TextStyle(
                fontSize: width * 0.1 > 40 ? 40 : width * 0.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            CustomButton(
              text: "Новый рецепт",
              fontSize: width*0.1 > 70 ? 70 : width*0.1,
              size: Size(width*0.8, width*0.2 > 70 ? 70 : width*0.2),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const RecipePage()));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              text: "Мои рецепты",
              fontSize: width*0.1 > 70 ? 70 : width*0.1,
              size: Size(width*0.8, width*0.2 > 70 ? 70 : width*0.2),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RecipeList(
                            recipes:
                                Provider.of<RecipeProvider>(context).recipes)));
              },
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              text: "Избранные",
              fontSize: width*0.1 > 70 ? 70 : width*0.1,
              size: Size(width*0.8, width*0.2 > 70 ? 70 : width*0.2),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoritesList()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
