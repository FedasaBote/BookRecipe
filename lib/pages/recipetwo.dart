import 'dart:typed_data';
import 'package:book_recipe/model/image.dart';
import 'package:book_recipe/widgets/AddIngredientBottomSheet.dart';
import 'package:book_recipe/widgets/AddStepBottomSheet.dart';
import 'package:book_recipe/widgets/cooking_step.dart';
import 'package:flutter/material.dart';
import '../state/recipe_provider.dart';
import '../widgets/custom_button.dart';
import 'package:provider/provider.dart';
import '../widgets/show_ingredients.dart';
import '../model/recipe.dart';

class RecipePageTwo extends StatefulWidget {
  final bool isEdit;
  const RecipePageTwo({
    super.key,
    this.isEdit = false,
  });

  @override
  State<RecipePageTwo> createState() => _RecipePageTwoState();
}

class _RecipePageTwoState extends State<RecipePageTwo> {
  Uint8List? image;
  String? errorText;
  String? hErrorText;
  String? sErrorText;
  late TextEditingController minController;
  late TextEditingController hController;
  TextEditingController serveController = TextEditingController(text: '1');

  @override
  void initState() {
    super.initState();
    RecipeProvider recipeProvider =
        Provider.of<RecipeProvider>(context, listen: false);
    minController = TextEditingController();
    minController.text = recipeProvider.recipetoDatabase.preparationMinutes > 0 ? recipeProvider.recipetoDatabase.preparationMinutes.toString() : '';
    hController = TextEditingController();
    hController.text = recipeProvider.recipetoDatabase.preparationHours > 0 ? recipeProvider.recipetoDatabase.preparationHours.toString() : '';
  }

  @override
  void dispose() {
    serveController.dispose();
    minController.dispose();
    hController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Recipe recipe = Provider.of<RecipeProvider>(context).recipetoDatabase;
    RecipeProvider recipeProvider = Provider.of<RecipeProvider>(context);
    var images = recipeProvider.images;
    var img = recipeProvider.recipetoDatabase.mainIndex != null
        ? images[recipeProvider
                .recipes_images[recipeProvider.recipetoDatabase.mainIndex!]!]
            .imageData
        : null;
    
    double width = MediaQuery.sizeOf(context).width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: CustomButton(
                  text: "Назад",
                  size: Size(
                      width * 0.25 > 150 ? 150 : width * 0.25,
                      width * 0.1 > 40 ? 40 : width * 0.1),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width*0.1).copyWith(bottom: width*0.05 > 20 ? 20 : width*0.05),
                child: Text(
                  recipe.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: width*0.1 > 40 ? 40 : width*0.1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: width * 0.7,
                margin: const EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.grey.shade700, width: 0.5)),
                child: GestureDetector(
                  child: img != null
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: AspectRatio(
                            aspectRatio: 5 / 3,
                            child: Image.memory(
                              img,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: AspectRatio(
                            aspectRatio: 5 / 3,
                            child: Image.asset(
                              'assets/images/place_holder.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                  onTap: () {
                    List<ImageModel?> images =
                        recipeProvider.recipes_images.map((e) {
                      if (e == null) {
                        return null;
                      }
                      return recipeProvider.images[e];
                    }).toList();
                    // let;s show the dialog here
                    int nonNullImages = images.where((element) => element != null).length;
                    if (nonNullImages <= 1) return;
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Выберите фото"),
                              content: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                    images.length,
                                    (index) {
                                      if (images[index] == null) {
                                        return const SizedBox();
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          recipeProvider
                                              .setMainImage(index);

                                          Navigator.pop(context);
                                        },
                                        child: Card(
                                          margin:
                                              const EdgeInsets.all(0),
                                          elevation: 2,
                                          shadowColor:
                                              Colors.grey.shade50,
                                          child: Container(
                                            height: 200,
                                            width: 200,
                                            margin: const EdgeInsets
                                                    .symmetric(
                                                vertical: 10),
                                            child: Image.memory(
                                              images[index]!.imageData,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ));
                  },
                ),
              ),
              SizedBox(
                height: width*0.1 > 50 ? 50 : width*0.1,
              ),
              Text(
                "Время приготовления",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width*0.075,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: width*0.05,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Text("Часов",
                          style: TextStyle(fontSize: width*0.06 > 50 ? 50 : width*.06, color: Colors.black)),
                    ),
                    TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty && int.tryParse(value) == null) {
                          setState(() {
                            hErrorText = 'hour';
                          });
                        } else {
                          setState(() {
                            hErrorText = null;
                          });
                        }
                      },
                      style: TextStyle(fontSize: width*0.06 > 50 ? 50 : width*0.06),
                      controller: hController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          errorText: hErrorText == "hour" ? "Invalid" : null,
                          fillColor: Colors.white,
                          hintText: '00',
                          hintStyle: TextStyle(fontSize: width*0.06 > 40 ? 40 : width*0.06),
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade100,
                            ),
                          ),
                          constraints: BoxConstraints(
                            maxHeight: 50,
                            minHeight: 50,
                            maxWidth: 100,
                            minWidth:
                                MediaQuery.of(context).size.width / 4 > 100
                                    ? 100
                                    : MediaQuery.of(context).size.width / 4,
                          )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      child: Text(
                        "Минут",
                        style: TextStyle(
                          fontSize: width*0.06 > 50 ? 50 : width*0.06,
                        ),
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        if (value.isNotEmpty && int.tryParse(value) == null) {
                          setState(() {
                            errorText =
                                'minute'; // Set the validation error message
                          });
                        } else {
                          setState(() {
                            errorText =
                                null; // Clear the validation error message
                          });
                        }
                      },
                      textAlign: TextAlign.center,
                      controller: minController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: width*0.06 > 50 ? 50 : width*0.06),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          errorText: errorText == "minute" ? "Invalid" : null,
                          hintText: '00',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade200,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.grey.shade100,
                            ),
                          ),
                          constraints: BoxConstraints(
                            maxHeight: 50,
                            minHeight: 50,
                            maxWidth: 100,
                            minWidth:
                                MediaQuery.of(context).size.width / 4 > 100
                                    ? 100
                                    : MediaQuery.of(context).size.width / 4,
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width*0.1 > 50 ? 50 : width*0.1,
              ),
              Text(
                "Ингридиенты",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width*0.075 > 40 ? 40 : width*0.075,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: width*0.01 > 30 ? 30 : width*0.01,
              ),
              ShowIngredients(
                  ingredients: recipeProvider.recipetoDatabase.ingredients),
              CustomButton(
                text: "Добавить +",
                size: Size(
                    width * 0.5 > 200 ? 200 : width * 0.5,
                    width * 0.1 > 40 ? 40 : width * 0.1),
                onPressed: () {
                  showBottomsheet(context);
                },
              ),
              SizedBox(
                height: width*0.1 > 50 ? 50 : width*0.1,
              ),
              Text(
                "Этапы приготовления",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width*0.075 > 40 ? 40 : width*0.075,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: width*0.075 > 50 ? 50 : width*0.075,
              ),
              CookingSteps(
                cookingSteps: recipeProvider.recipetoDatabase.cookingSteps,
                isEdit: widget.isEdit,
              ),
              CustomButton(
                text: "Добавить +",
                size: Size(
                    width * 0.5 > 200 ? 200 : width * 0.5,
                    width * 0.1 > 40 ? 40 : width * 0.1),
                onPressed: () {
                  bottomSheet(context);
                },
              ),
              SizedBox(
                height: width*0.1 > 50 ? 50 : width*0.1,
              ),
              Text(
                'Количество порций',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: width*0.075 > 50 ? 50 : width*0.075,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: width*0.05 > 30 ? 30 : width*0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty && int.tryParse(value) == null) {
                        setState(() {
                          sErrorText =
                              'serve'; // Set the validation error message
                        });
                      } else {
                        setState(() {
                          sErrorText =
                              null; // Clear the validation error message
                        });
                      }
                    },
                    controller: serveController,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: width*0.06 > 40 ? 40 : width*0.06),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        errorText: sErrorText == "serve" ? "Invalid" : null,
                        fillColor: Colors.white,
                        hintText: '00',
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade200,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade100,
                          ),
                        ),
                        constraints: BoxConstraints(
                          maxHeight: 50,
                          minHeight: 50,
                          maxWidth: 100,
                          minWidth: MediaQuery.of(context).size.width / 4 > 100
                              ? 100
                              : MediaQuery.of(context).size.width / 4,
                        )),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('порций(и)', style: TextStyle(fontSize: width*0.075, fontWeight: FontWeight.bold))
                ],
              ),
              SizedBox(height: width)
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: width*0.075).copyWith(bottom: width*0.03),
          child: CustomButton(
                  text: "Сохранить",
                  fontSize: width*0.075,
                  size: Size(
                    width*0.8,
                    width*0.175),
                  onPressed: () {
                    if (serveController.text.isEmpty) {
                      showMessage("установить количество подач");
                      return;
                    }
                    if (minController.text.isEmpty && hController.text.isEmpty) {
                      // время должно быть установлено
                      showMessage('время должно быть установлено');
                      return;
                    } else if ((minController.text.isNotEmpty &&
                            int.tryParse(minController.text) == null) ||
                        (hController.text.isNotEmpty &&
                            int.tryParse(hController.text) == null) ||
                        (serveController.text.isNotEmpty &&
                            int.tryParse(serveController.text) == null)) {
                      return;
                    }
                    recipeProvider.recipetoDatabase.serve =
                        int.parse(serveController.text);
                    if (hController.text.isNotEmpty) {
                      recipeProvider.recipetoDatabase.preparationHours =
                          int.parse(hController.text);
                    }
                    if (minController.text.isNotEmpty) {
                      recipeProvider.recipetoDatabase.preparationMinutes =
                          int.parse(minController.text);
                    }
                    recipeProvider.saveToDatabase(widget.isEdit);
                    if (recipeProvider.validationError.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(recipeProvider.validationError),
                        ),
                      );
        
                      return;
                    }
        
                    minController.clear();
                    hController.clear();
                    serveController.clear();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Добавлено успешно', style: TextStyle(fontSize: width*0.06), textAlign: TextAlign.center,),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                                'Рецепт успешно добавлен в ваш список рецептов', textAlign: TextAlign.center),
                            SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                              text: 'Ок',
                              onPressed: () {
                                Navigator.pop(context);
                              }, 
                              size: Size(
                                width*0.2,
                                width*0.1
                              )
                            )
                          ],
                        ),
                      ),
                    ).then((value) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  },
                ),
        ),
      ),
    );
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}

void bottomSheet(BuildContext context,
    [bool isEdit = false, int? cookingStep]) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return AddStepBottomSheet(
        isEdit: isEdit,
        index: cookingStep,
      );
    },
  );
}
