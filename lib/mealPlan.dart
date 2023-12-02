import 'food.dart';
final String tableMealPlans = 'mealPlans';


class MealPlanFields {

  static final List<String> values = [id, date, food];
  static final String id = '_id';
  static final String date = 'date';
  static final String food = 'food';
}

class MealPlan {
  final int id;
  final String date;
  final int food;

  const MealPlan({required this.id, required this.date, required this.food,});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'food': food,};
  }

  static MealPlan fromMap(Map<String, Object?> json) => MealPlan (
    id: json[MealPlanFields.id] as int,
    date: (json[MealPlanFields.date] as String),
    food: json[MealPlanFields.food] as int,
  );

  MealPlan copy({ int? id, String? date, int? food}) =>
      MealPlan(id: id ?? this.id, date: date ?? this.date, food: food ??this.food);
  // Implement toString to make it easier to see information about
  // each food when using the print statement.
  @override
  String toString() {
    return 'Food{id: $id, date: $date, age: ${food}}';
  }
}
