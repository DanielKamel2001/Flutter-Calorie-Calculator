final String tableFood = 'foods';

class FoodFields {
  static final String id = '_id';
  static  final String name = 'name';
  static final String calories = 'calories';
}

class Food {
  final int id;
  final String name;
  final int calories;

  const Food({
    required this.id,
    required this.name,
    required this.calories,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
    };
  }

  // Implement toString to make it easier to see information about
  // each food when using the print statement.
  @override
  String toString() {
    return 'Food{id: $id, name: $name, age: $calories}';
  }
}
