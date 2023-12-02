import 'package:flutter/material.dart';
import 'package:flutter_calories_calculator/database.dart';
import 'package:flutter_calories_calculator/mealPlan.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'food.dart';

class AddMealPlansPage extends StatefulWidget {
  final List<MealPlan>? mealPlan; //list of meal plan objects in "THIS" mealplan

  const AddMealPlansPage({
    Key? key,
    this.mealPlan,
  }) : super(key: key);

  @override
  State<AddMealPlansPage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddMealPlansPage> {
  late final List<Food> foods; //list of all foods that can be added

  final _formKey = GlobalKey<FormState>();
  late DateTime date;
  List<int> selectedItems = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    refreshFoods();
  }

  @override
  void dispose() {
    DatabaseHelper.instance.close();

    super.dispose();
  }

  Future refreshFoods() async {
    setState(() => isLoading = true);

    print("Foods refreshing");

    // var apple = const Food(
    //   id: null,
    //   name: 'Apple',
    //   calories: 59,
    // );
    // var banana = const Food(
    //   id: null,
    //   name: 'banana',
    //   calories: 151,
    // );
    // var grapes = const Food(
    //   id: null,
    //   name: 'grapes',
    //   calories: 100,
    // );
    // var Cheeseburger = const Food(
    //   id: null,
    //   name: 'cheeseburger',
    //   calories: 285,
    // );
    // var Pizza = const Food(
    //   name: 'pizza',
    //   calories: 285, id: null,
    // );

    // await DatabaseHelper.instance.insertFood(apple);
    // await DatabaseHelper.instance.insertFood(banana);
    // await DatabaseHelper.instance.insertFood(Cheeseburger);
    // await DatabaseHelper.instance.insertFood(Pizza);
    // await DatabaseHelper.instance.insertFood(grapes);
    foods = await DatabaseHelper.instance.readAllFoods();
    // DateTime temp = DateTime.timestamp();
    // foods = [
    //   const Food(
    //       id: 1,
    //       name:
    //       "idk",
    //       calories: 1)
    // ];

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(// actions: [buildButton()],
            ),
        body: Form(
            key: _formKey,
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : foods.isEmpty
                      ? const Text(
                          'No foods',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        )
                      : SingleChildScrollView(child: foodCards(foods)),
            )),
      );

  Widget foodCards(List<Food> foods) {
    return Column(children: foods.map((food) => foodCard(food)).toList());
  }

  Widget foodCard(Food food) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Column(children: [
          Row(children: [const Text("FOOD:"), Text(food.name)]),
          Row(children: [
            const Text("CALORIES:"),
            Text(food.calories.toString())
          ])
        ]));
  }
}
