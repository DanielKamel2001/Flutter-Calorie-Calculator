import 'package:flutter/material.dart';
import 'package:flutter_calories_calculator/mealPlan.dart';
import 'package:flutter_calories_calculator/AddMealPlansPage.dart';
import 'database.dart';

class MealPlansPage extends StatefulWidget {
  const MealPlansPage({super.key});

  @override
  State<MealPlansPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlansPage> {
  late List<MealPlan> mealPlans;
  List<Widget> mealPlanCards = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshMealPlans();
  }

  @override
  void dispose() {
    DatabaseHelper.instance.close();

    super.dispose();
  }

  Future refreshMealPlans() async {
    setState(() => isLoading = true);

    print("refreshing plan");
    mealPlans = await DatabaseHelper.instance.readAllMealPlans();
    print("refreshing dates");
    var dates = await DatabaseHelper.instance.readDatesOfMealPlans();

    mealPlanCards = []; // reset cards to display
    for (var date in dates) {
      print("for each date: ${date}");
      mealPlanCards.add(await mealPlanCard(date));
    }

    print(mealPlans.length);
    // DateTime temp = DateTime.timestamp();
    // mealPlans = [
    //   MealPlan(
    //       id: 1,
    //       date:
    //           "${temp.toLocal().day}-${temp.toLocal().month}-${temp.toLocal().year}",
    //       food: 1)
    // ];

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    print("buiding meals page");
    return Scaffold(
      appBar: AppBar(
        title: const Text("flutter calories calculator"),
      ),
      body: Center(
          child: isLoading
              ? const CircularProgressIndicator()
              : mealPlans.isEmpty
                  ? const Text(
                      'No MealPlans',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  : Column(
                      children: mealPlanCards,
                    ) //buildMealPlans(mealPlans),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddMealPlansPage()),
          );

          refreshMealPlans();
        },
        tooltip: 'Add Meal Plan',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget buildMealPlans(/*List<MealPlan> mealPlans*/) {
  //   print(mealPlans.length);
  //
  //   return Column(
  //       children: mealPlans
  //           .map((mealPlan) => buildMealPlanCard(mealPlan))
  //           .toList() //<Widget> [ for(var mealplan in mealPlans)buildMealPlanCard(mealPlan) ],
  //   );
  // }
  // Widget buildMealPlanCard(MealPlan mealPlan) {
  //   print("Meal PLan To String: " + mealPlan.toString());
  //
  //   return Column(
  //     children: [Text(mealPlan.food.toString())],
  //   );
  // }

  Future<Widget> mealPlanCard(String date) async {
    var meals = await DatabaseHelper.instance.readMealPlanFromDate(date);
    var foods = [];
    var calTotal = 0;

    for (var meal in meals) {
      var food = await DatabaseHelper.instance.readFood(meal.food!);
      foods.add(food);
      calTotal = calTotal + food.calories;
    }

    return Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Column(children: [
          Text(date),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: foods.map((food) => Text(food.name)).toList(),
          ),
          Text("Total Calories: $calTotal")
        ]));
  }
}
