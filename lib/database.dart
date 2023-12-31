import 'dart:async';


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
    print("db Init");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    print("DB Create");
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    await db.execute( '''CREATE TABLE ${tableFood} ( ${FoodFields.id} ${idType}, ${FoodFields.name} VARCHAR, ${FoodFields.calories} INTEGER)  ; ''');
    // await db.execute("CREATE TABLE foods ('_id' INTEGER PRIMARY KEY, 'name' TEXT, 'calories' INTEGER )");
    await db.execute("CREATE TABLE mealPlans ('_id' INTEGER PRIMARY KEY, 'date' TEXT, 'food' INTEGER )");


  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    return db.close();
  }

  Future<Food> insertFood(Food food) async {
    // Get a reference to the database.
    final db = await database;
    print("inserting food");

    // Insert the Food into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same food is inserted twice.
    //
    // In this case, replace any previous data.
    final id = await db.insert(
      tableFood,
      food.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return food.copy(id:id);
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
    print("reading food $id");
    final maps = await db.query(tableFood,columns: FoodFields.values,where: '${FoodFields.id} =?', whereArgs: [id]);
    if(maps.isNotEmpty){
      return Food.fromMap(maps.first);
    }else{
      throw Exception('ID $id is not found');
    }
  }

  Future<List<Food>> readAllFoods() async {
    final db = await instance.database;
    print("Foods reading all foods");
    final maps = await db.query(tableFood,columns: FoodFields.values);


    print(maps.length);
    return maps.map((json)=> Food.fromMap(json)).toList();
  }



  Future<MealPlan> readMealPlan(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableMealPlans,columns: MealPlanFields.values,where: '${MealPlanFields.id} =?', whereArgs: [id]);
    if(maps.isNotEmpty){
      return MealPlan.fromMap(maps.first);
    }else{
      throw Exception('ID $id is not found');
    }
  }

  Future<List<String>> readDatesOfMealPlans() async {
    final db = await instance.database;
    print("Getting Dates");
    final maps = await db.query(tableMealPlans,columns: [MealPlanFields.date],distinct: true );
    print("got unique dates ${maps.length}");
    return maps.map((json)=> MealPlan.fromMap(json).date as String).toList();


  }

  Future<List<MealPlan>> readMealPlanFromDate(String date) async {
    final db = await instance.database;
    final maps = await db.query(tableMealPlans,columns: MealPlanFields.values,where: '${MealPlanFields.date} =?', whereArgs: [date]);

    return maps.map((json)=> MealPlan.fromMap(json)).toList();
    

  }
  Future<List<MealPlan>> readAllMealPlans() async {
    final db = await instance.database;
    final maps = await db.query(tableMealPlans,columns: MealPlanFields.values,);

    return maps.map((json)=> MealPlan.fromMap(json)).toList();
  }

  Future<int> updateMealPlan(MealPlan mealPlan)async{
    final db = await instance.database;
    return db.update(tableMealPlans, mealPlan.toMap(),where: '${MealPlanFields.id} = ?', whereArgs: [mealPlan.id],);
  }
  Future<int> deleteMealPlan(int id )async{
    final db = await instance.database;
    return db.delete(tableMealPlans, where: '${MealPlanFields.id} = ?', whereArgs: [id],);
  }


}
