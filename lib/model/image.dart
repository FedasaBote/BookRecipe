// db.execute(
//           'CREATE TABLE images(id INTEGER PRIMARY KEY, recipe_id INTEGER, image_data BLOB)',
//         );

import 'dart:typed_data';

class ImageModel {
  int? id;
  int? index;
  int? recipe_id;
  Uint8List imageData;

  ImageModel({
    this.id,
    this.index,
    this.recipe_id,
    required this.imageData,
  });

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    return ImageModel(
      id: map['id'],
      imageData: map['image_data'],
      recipe_id: map['recipe_id'],
      index: map['pos'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'image_data': imageData,
      if (recipe_id != null) 'recipe_id': recipe_id,
      if (index != null) 'pos': index,
    };
  }

  @override
  String toString() {
    return '$id $index $recipe_id';
  }
}
