import 'package:book_recipe/model/recipe.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/recipe_provider.dart';
import 'custom_button.dart';

class AddIngredientsBottomSheet extends StatefulWidget {
  final bool isEdit;
  final int? index;
  const AddIngredientsBottomSheet({
    super.key,
    this.isEdit = false,
    this.index,
  });

  @override
  State<AddIngredientsBottomSheet> createState() =>
      _AddIngredientsBottomSheetState();
}

class _AddIngredientsBottomSheetState extends State<AddIngredientsBottomSheet> {
  bool _isSelected = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController kgController = TextEditingController();
  TextEditingController gramController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? errorText;
  String? validationError;
  bool isFirsTime = true;

  bool isKeyboardVisible = false;

  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).addListener(() {
        if (FocusScope.of(context).hasFocus) {
          setState(() {
            isKeyboardVisible = true;
          });
        } else {
          setState(() {
            isKeyboardVisible = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);

    if (widget.isEdit && isFirsTime) {
      Ingredient ingredient =
          recipeProvider.recipetoDatabase.ingredients[widget.index!];
      nameController.text = ingredient.name;
      kgController.text = ingredient.kg != null ? ingredient.kg.toString() : "";
      gramController.text =
          ingredient.gram != null ? ingredient.gram.toString() : "";
      descriptionController.text = ingredient.description;
      _isSelected = ingredient.totaste;

      isFirsTime = false;
    }

    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFFAF4E1),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Scaffold(
              resizeToAvoidBottomInset: !isKeyboardVisible,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width*0.1, vertical: width*0.05),
                      child: Text('Название Ингридиента',
                          style: TextStyle(fontSize: width*0.075, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center),
                    ),
                    TextField(
                      controller: nameController,
                      style: TextStyle(fontSize: width*0.05),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        labelText: 'Ввести название ингридиента',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: width*0.05,
                        ),
                      ),
                    ),
                    SizedBox(height: width*0.05),
                    Text('Количество',
                        style: TextStyle(fontSize: width*0.075, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Кг',
                          style: TextStyle(
                            fontSize: width*0.05,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: width*0.2,
                          child: TextField(
                            onChanged: (value) {
                              if (value.isNotEmpty && int.tryParse(value) == null) {
                                setState(() {
                                  errorText =
                                      'kilo'; // Set the validation error message
                                });
                              } else {
                                setState(() {
                                  errorText =
                                      null; // Clear the validation error message
                                });
                              }
                            },
                            controller: kgController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              enabled: !_isSelected,
                              errorText: errorText == "kilo" ? "Invalid" : null,
                              contentPadding: const EdgeInsets.all(4),
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              hintText: '00',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintStyle:
                                  const TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(width: width*0.1),
                        Text(
                          'Гр',
                          style: TextStyle(
                            fontSize: width*0.05,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: width*0.2,
                          child: TextField(
                            controller: gramController,
                            onChanged: (value) {
                              if (value.isNotEmpty && int.tryParse(value) == null) {
                                setState(() {
                                  errorText =
                                      'gram'; // Set the validation error message
                                });
                              } else {
                                setState(() {
                                  errorText =
                                      null; // Clear the validation error message
                                });
                              }
                            },
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              enabled: !_isSelected,
                              errorText: errorText == "gram" ? "Invalid" : null,
                              contentPadding: const EdgeInsets.all(4),
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5))),
                              hintText: '00',
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade200,
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintStyle:
                                  const TextStyle(color: Colors.grey, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('По вкусу', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Transform.scale(
                          scale: 1.5,
                          child: Checkbox(
                            value: _isSelected,
                            side: const BorderSide(color: Colors.grey),
                            fillColor: const MaterialStatePropertyAll(Colors.white),
                            checkColor: Colors.grey.shade700,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            onChanged: (value) {
                              setState(() {
                                _isSelected = value!;
                              });
                            },
                            visualDensity: VisualDensity.adaptivePlatformDensity,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('Другое', style: TextStyle(fontSize: 25)),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        enabled: !_isSelected,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        hintText: 'Ввести',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          
                  Positioned(
                    bottom: 10,
                    left: width*0.075,
                    right: width*0.075,
                    child: CustomButton(
                        text: 'Добавить',
                        fontSize: width*0.075 > 40 ? 40 : width*0.075,
                        size: Size(MediaQuery.sizeOf(context).width * 0.9, width*0.175 > 80 ? 80 : width*0.175),
                        onPressed: () {
                          if (nameController.text.isEmpty) {
                            showMessage('имя должно быть заполнено');
                            return;
                          } else if (gramController.text.isEmpty &&
                              kgController.text.isEmpty &&
                              !_isSelected &&
                              descriptionController.text.isEmpty) {
                            showMessage(
                                "Количество должно быть установлено в граммах и килограммах, по вкусу или в других единицах.");
                  
                            return;
                          } else if ((gramController.text.isNotEmpty &&
                                  int.tryParse(gramController.text) == null) ||
                              (kgController.text.isNotEmpty &&
                                  int.tryParse(kgController.text) == null)) {
                            showMessage('грамм и килограмм должны быть числом');
                            return;
                          } else if (
                              (!_isSelected && (gramController.text.isNotEmpty ||
                                      kgController.text.isNotEmpty) &&
                                  descriptionController.text.isNotEmpty)) {
                            showMessage(
                                'выберите один из способов установки количества');
                            return;
                          }
                          if (widget.isEdit) {
                            // if it edit we just change the ingredient in place inside recipe provider recipe to database
                            recipeProvider.recipetoDatabase
                                .ingredients[widget.index!] = Ingredient(
                              name: nameController.text,
                              kg: !_isSelected? kgController.text.isNotEmpty
                                  ? int.parse(kgController.text):null
                                  : null,
                              gram:!_isSelected? gramController.text.isNotEmpty
                                  ? int.parse(gramController.text):null
                                  : null,
                              description:!_isSelected? descriptionController.text.isNotEmpty
                                  ? descriptionController.text:""
                                  : "",
                              totaste: _isSelected,
                            );
                            recipeProvider.notify();
                          } else {
                            Ingredient ingredient = Ingredient(
                              name: nameController.text,
                              kg: kgController.text.isNotEmpty
                                  ? int.parse(kgController.text)
                                  : null,
                              gram: gramController.text.isNotEmpty
                                  ? int.parse(gramController.text)
                                  : null,
                              description: descriptionController.text.isNotEmpty
                                  ? descriptionController.text
                                  : "",
                              totaste: _isSelected,
                            );
                  
                            recipeProvider.addIngredient(ingredient);
                          }
                          Navigator.pop(context);
                        }),
                  )
        ],
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).width * 0.25),
      content: Text(message),
    ));
  }
}

void showBottomsheet(BuildContext context, [bool isEdit = false, int? index]) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return AddIngredientsBottomSheet(isEdit: isEdit, index: index);
    },
  );
}
