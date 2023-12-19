import 'dart:convert';

class Recipe {
  int? id;
  int? mainIndex;
  String name;
  String? description;
  int preparationHours;
  int preparationMinutes;
  bool isFavorite;
  List<Ingredient> ingredients;
  List<CookingStep> cookingSteps;
  int serve;

  Recipe({
    this.id,
    this.mainIndex,
    this.description,
    this.isFavorite = false,
    required this.name,
    required this.preparationHours,
    required this.preparationMinutes,
    required this.ingredients,
    required this.cookingSteps,
    required this.serve,
  });

  factory Recipe.fromMap(
      Map<String, dynamic> map, List<CookingStep> cookingSteps) {
    return Recipe(
      id: map['id'],
      serve: map['serve'],
      mainIndex: map['main_index'],
      isFavorite: map['isFavorite'] == 1 ? true : false,
      description: map["description"],
      name: map['name'],
      preparationHours: map['preparation_hours'],
      preparationMinutes: map['preparation_minutes'],
      ingredients: (jsonDecode(map['ingredients']) as List<dynamic>)
          .map((ingredientMap) => Ingredient.fromMap(ingredientMap))
          .toList(),
      cookingSteps: cookingSteps,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (description != null && description!.isNotEmpty)
        'description': description,
      if (id != null) 'id': id,
      if (mainIndex != null) 'main_index': mainIndex,
      'isFavorite': isFavorite ? 1 : 0,
      'name': name,
      'serve': serve,
      'preparation_hours': preparationHours,
      'preparation_minutes': preparationMinutes,
      'ingredients': jsonEncode(
          ingredients.map((ingredient) => ingredient.toMap()).toList()),
    };
  }
}

class Ingredient {
  int? kg;
  int? gram;
  String name;
  String description;
  bool totaste;

  Ingredient({
    this.kg,
    this.gram,
    required this.name,
    this.totaste = false,
    this.description = "",
  });

  Map<String, dynamic> toMap() {
    return {
      if (kg != null) 'kg': kg,
      if (gram != null) 'gram': gram,
      'totaste': totaste,
      if (description.isNotEmpty) 'description': description,
      'name': name,
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map) {
    return Ingredient(
      name: map['name'],
      description: map['description'] ?? "",
      kg: map["kg"],
      gram: map['gram'],
      totaste: map['totaste'],
    );
  }
}

class CookingStep {
  int? id;
  String description;
  int? recipe_id;
  int? imageId;
  int? index;

  CookingStep({
    required this.description,
    this.imageId,
    this.id,
    this.recipe_id,
    this.index,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'description': description,
      if (imageId != null) 'image_id': imageId,
      if (recipe_id != null) 'recipe_id': recipe_id,
    };
  }

  factory CookingStep.fromMap(Map<String, dynamic> map) {
    return CookingStep(
        description: map['description'],
        imageId: map['image_id'],
        recipe_id: map['recipe_di'],
        id: map['id']);
  }
}
