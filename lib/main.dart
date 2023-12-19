import 'package:book_recipe/pages/loading.dart';
import 'package:book_recipe/state/recipe_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'db/dbhelper.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => RecipeProvider(DBHelper.instance),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Recipe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAF4E1),
        colorScheme: const ColorScheme(brightness: Brightness.light, primary: Color(0xFFFAF4E1), onPrimary: Colors.black, secondary: Color(0xFFFAF4E1), onSecondary: Colors.black, error: Colors.redAccent, onError: Colors.red, background: Color(0xFFFAF4E1), onBackground: Colors.black, surface: Color(0xFFFAF4E1), onSurface: Colors.black),
      ),
      home: const Loading(),
    );
  }
}
