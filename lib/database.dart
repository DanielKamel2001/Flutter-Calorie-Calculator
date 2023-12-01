import 'dart:async';
import 'dart:html';

import 'package:flutter_calories_calculator/food.dart';
import 'package:flutter_calories_calculator/mealPlan.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('food-database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    // await db.execute( '''CREATE TABLE ${tableFood} ( ${FoodFields.id} ${idType}, ${FoodFields.name} VARCHAR, ${FoodFields.calories} INTERGER)  ; ''');
    await db.execute("CREATE TABLE foods(id INTEGER PRIMARY KEY, name TEXT, calories INTEGER);");
    await db.execute("CREATE TABLE mealPlans(id INTEGER PRIMARY KEY, date TEXT, calories INTEGER);");
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

  Future<Food> insertFood(Food food) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Food into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same food is inserted twice.
    //
    // In this case, replace any previous data.
    final id = await db.insert(
      tableFood,
      food.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return food.copy();
  }

  Future<MealPlan> insertMealPlan(MealPlan mealPlan) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Food into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same food is inserted twice.
    //
    // In this case, replace any previous data.
    final id = await db.insert(
      tableMealPlans,
      mealPlan.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return mealPlan.copy();
  }

  Future<Food> readFood(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableFood,columns: FoodFields.values,where: '${FoodFields.id} =?', whereArgs: [id]);
    if(maps.isNotEmpty){
      return Food.fromMap(maps.first);
    }else{
      throw Exception('ID $id is not found');
    }
  }

  Future<MealPlan> readMealPlan(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableFood,columns: FoodFields.values,where: '${FoodFields.id} =?', whereArgs: [id]);
    if(maps.isNotEmpty){
      return MealPlan.fromMap(maps.first);
    }else{
      throw Exception('ID $id is not found');
    }
  }

//   {
//   final database = openDatabase(
//     // Set the path to the database. Note: Using the `join` function from the
//     // `path` package is best practice to ensure the path is correctly
//     // constructed for each platform.
//       join(await getDatabasesPath(), 'food_database.db'),
// // When the database is first created, create a table to store dogs.
//       onCreate
//
//       :
//
//   (db, version)
//
//   {
//
// // Run the CREATE TABLE statement on the database.
//   return
//
//   db.execute
//
//   (
//
//   '
//
//
//
//   '
//
//   ,
//
//   );
// }, // Set the version. This executes the onCreate function and provides a
// // path to perform database upgrades and downgrades.
// version: 1
// ,
// );}
}
