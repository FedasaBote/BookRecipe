import 'package:book_recipe/model/recipe.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/image.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper instance = DBHelper._();

  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'recipe_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE images(id INTEGER PRIMARY KEY, image_data BLOB,pos INTEGER,recipe_id INTEGER, FOREIGN KEY(recipe_id) REFERENCES recipes(id) ON DELETE CASCADE)',
        );
        db.execute(
          'CREATE TABLE cookingsteps(id INTEGER PRIMARY KEY, image_id INTEGER, description TEXT,'
          'recipe_id INTEGER, FOREIGN KEY(recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,'
          'FOREIGN KEY(image_id) REFERENCES images(id) ON DELETE CASCADE)',
        );
        return db.execute(
          'CREATE TABLE recipes(id INTEGER PRIMARY KEY, name TEXT,serve INTEGER,main_index INTEGER,preparation_hours INTEGER,preparation_minutes INTEGER, description TEXT, ingredients TEXT, isFavorite INTEGER DEFAULT 0)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertRecipe(Map<String, dynamic> recipe) async {
    final Database db = await database();

    int id = await db.insert(
      'recipes',
      recipe,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<List<Recipe>> getRecipes() async {
    final Database db = await database();

    final List<Map<String, dynamic>> maps = await db.query('recipes');

    List<Recipe> recipes = [];

    for (int i = 0; i < maps.length; i++) {
      List<CookingStep> cookingSteps = await getCookingSteps(maps[i]['id']);
      Recipe recipe = Recipe.fromMap(maps[i], cookingSteps);
      recipes.add(recipe);
    }

    return recipes;
  }

  // get all things inside the cooking steps table
  Future<List<CookingStep>> getAllCookingSteps() async {
    final Database db = await database();

    final List<Map<String, dynamic>> maps = await db.query('cookingsteps');

    return List.generate(
        maps.length, (index) => CookingStep.fromMap(maps[index]));
  }

  Future<List<CookingStep>> getCookingSteps(recipe_id) async {
    final Database db = await database();

    final List<Map<String, dynamic>> maps = await db
        .query('cookingsteps', where: 'recipe_id = ?', whereArgs: [recipe_id]);

    return List.generate(
        maps.length, (index) => CookingStep.fromMap(maps[index]));
  }

  Future<void> updateRecipe(Recipe recipe) async {
    final Database db = await database();

    await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.toMap()['id']],
    );
  }

  Future<void> deleteRecipe(int id) async {
    final Database db = await database();

    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertImage(ImageModel imageModel) async {
    final Database db = await database();

    // insert image and get id
    int id = await db.insert(
      'images',
      imageModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<ImageModel> getImage(int imageIds) async {
    final Database db = await database();

    List<Map<String, dynamic>> maps = await db.query(
      'images',
      where: 'id = ?',
      whereArgs: [imageIds],
    );

    return ImageModel.fromMap(maps[0]);
  }

  Future<List<ImageModel>> getImageRecipe(int recipe_id) async {
    final Database db = await database();

    List<Map<String, dynamic>> maps = await db.query(
      'images',
      where: 'recipe_id = ?',
      whereArgs: [recipe_id],
    );

    return List.generate(
        maps.length, (index) => ImageModel.fromMap(maps[index]));
  }

  Future<void> updateImage(ImageModel imageModel) async {
    final Database db = await database();

    await db.update(
      'images',
      imageModel.toMap(),
      where: 'id = ?',
      whereArgs: [imageModel.toMap()['id']],
    );
  }

  Future<void> insertCookingStep(CookingStep cookingStep) async {
    final Database db = await database();
    await db.insert(
      'cookingsteps',
      cookingStep.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateCookingStep(CookingStep cookingStep) async {
    final Database db = await database();

    await db.update(
      'cookingsteps',
      cookingStep.toMap(),
      where: 'id = ?',
      whereArgs: [cookingStep.toMap()['id']],
    );
  }

  //clear database
  Future<void> clearDatabase() async {
    deleteDatabase(join(await getDatabasesPath(), 'recipe_database.db'));
  }
}
