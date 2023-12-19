import 'dart:typed_data';
import 'package:book_recipe/model/image.dart';
import 'package:flutter/material.dart';
import '../db/dbhelper.dart';
import '../model/recipe.dart';

class RecipeProvider with ChangeNotifier {
  DBHelper db;

  RecipeProvider(this.db);
  List<Recipe> _recipes = [];

  List<Recipe> get recipes {
    return [..._recipes];
  }

  String validationError = "";
  List<ImageModel> images = [];
  List<int?> recipes_images = [null, null, null];
  Recipe recipetoDatabase = Recipe(
    serve: 0,
    cookingSteps: [],
    preparationHours: 0,
    preparationMinutes: 0,
    name: "",
    ingredients: [],
  );

  void setMainImage(int index) {
    recipetoDatabase.mainIndex = index;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  int setImages(Uint8List img, [int? index, bool? isEdit, int? image_id]) {
    ImageModel image = ImageModel(
      imageData: img,
    );
    if (isEdit != null && isEdit) {
      if (image_id != null) {
        images[image_id].imageData = img;
        notifyListeners();
        return image_id;
      }
      images.add(image);
      notifyListeners();
      return images.length - 1;
    }

    if (index != null) {
      //
      recipetoDatabase.mainIndex ??= index;
      if (recipes_images[index] != null) {
        images[recipes_images[index]!].imageData = img;
        notifyListeners();
        return recipes_images[index]!;
      }
      image.index = index;
      images.add(image);
      recipes_images[index] = images.length - 1;
      notifyListeners();
      return images.length - 1;
    }
    images.add(image);

    notifyListeners();
    return images.length - 1;
  }

  void saveToDatabase([bool? isEdit]) async {
    validateRecipe();
    if (validationError.isNotEmpty) {
      notifyListeners();
      return;
    }

    if (isEdit != null && isEdit) {
      await db.updateRecipe(recipetoDatabase);
      for (int i = 0; i < images.length; i++) {
        if (images[i].id != null) {
          await db.updateImage(images[i]);
        } else {
          if (recipes_images.contains(i)) {
            images[i].recipe_id = recipetoDatabase.id;
          }
          images[i].id = await db.insertImage(images[i]);
        }
      }

      for (var step in recipetoDatabase.cookingSteps) {
        if (step.id != null) {
          if (step.index != null && step.imageId == null) {
            step.imageId = images[step.index!].id;
          }
          step.recipe_id = recipetoDatabase.id;
          await db.updateCookingStep(step);
        } else {
          if (step.index != null) step.imageId = images[step.index!].id;
          step.recipe_id = recipetoDatabase.id;
          await db.insertCookingStep(step);
        }
      }
    } else {
      // first save recipe and take its id
      int id = await db.insertRecipe(recipetoDatabase.toMap());
      for (var i = 0; i < images.length; i++) {
        if (recipes_images.contains(i)) {
          images[i].recipe_id = id;
        }
        images[i].id = await db.insertImage(images[i]);
      }

      // replace the image in the recipe with the image id and the image in cookingStep with image id
      for (var step in recipetoDatabase.cookingSteps) {
        if (step.index != null) step.imageId = images[step.index!].id;
        step.recipe_id = id;
        db.insertCookingStep(step);
      }
    }

    resetRecipe();
    notifyListeners();
  }

  void setRecipeForEdit(Recipe recipe) async {
    recipetoDatabase = recipe;
    var recipeImages = await db.getImageRecipe(recipe.id!);
    for (int i = 0; i < recipeImages.length; i++) {
      images.add(recipeImages[i]);
      recipes_images[recipeImages[i].index!] = images.length - 1;
    }

    for (var step in recipetoDatabase.cookingSteps) {
      if (step.imageId == null) continue;
      var image = await db.getImage(step.imageId!);
      images.add(image);
      step.index = images.length - 1;
    }

    notifyListeners();
  }

  void addIngredient(Ingredient ingredient) {
    recipetoDatabase.ingredients.add(ingredient);
    notifyListeners();
  }

  void addCookingSteps(CookingStep cookingStep) {
    recipetoDatabase.cookingSteps.add(cookingStep);
    notifyListeners();
  }

  void validateRecipe() {
    if (recipetoDatabase.name.isEmpty) {
      validationError = "Название рецепта не может быть пустым";
      return;
    }
    validationError = "";
  }

  void resetRecipe() {
    recipetoDatabase = Recipe(
      cookingSteps: [],
      preparationHours: 0,
      preparationMinutes: 0,
      name: "",
      serve: 0,
      ingredients: [],
    );
    images = [];
    // cooking_steps = [];
    recipes_images = [null, null, null];
  }

  Future<List<ImageModel>> getImageRecipe(int recipe_id) async {
    return await db.getImageRecipe(recipe_id);
  }

  Future<ImageModel> getImage(int image_id) async {
    return await db.getImage(image_id);
  }

  Future<void> updateRecipe(Recipe recipe) async{
    db.updateRecipe(recipe);
    notifyListeners();
  }

  Future<void> loadRecipes() async {
    _recipes = await db.getRecipes();
    notifyListeners();
  }

  void deleteRecipe(int id) {
    db.deleteRecipe(id);
    _recipes.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
