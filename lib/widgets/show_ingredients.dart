import 'package:book_recipe/model/recipe.dart';
import 'package:book_recipe/widgets/AddIngredientBottomSheet.dart';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

class ShowIngredients extends StatelessWidget {
  final List<Ingredient> ingredients;
  final bool isVisible;
  const ShowIngredients({
    Key? key,
    required this.ingredients,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        left: 20,
      ),
      margin: const EdgeInsets.only(bottom: 30),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(ingredients.length, (index) {
            String formattedingredientUnit = "";
            if (ingredients[index].kg != null && !ingredients[index].totaste) {
              formattedingredientUnit += "${ingredients[index].kg} Кг";
            }
            if (ingredients[index].gram != null &&
                !ingredients[index].totaste) {
              formattedingredientUnit += "${ingredients[index].gram} Гр";
            }
            return Row(
              children: [
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: DottedDecoration(
                        shape: Shape.line,
                        linePosition: LinePosition.right,
                        color: Colors.black,
                        strokeWidth: 2,
                        dash: const [2, 2]),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            ingredients[index].name,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Karantina',
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05),
                          ),
                          if (isVisible)
                            IconButton(
                              onPressed: () {
                                showBottomsheet(context, true, index);
                              },
                              icon: const Icon(Icons.edit),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Wrap(
                      children: [
                        Text(
                          ingredients[index].totaste
                              ? 'По вкусу'
                              : ingredients[index].description.isNotEmpty
                                  ? ingredients[index].description
                                  : formattedingredientUnit,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
      ),
    );
  }
}
