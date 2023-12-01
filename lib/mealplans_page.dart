import 'package:flutter/material.dart';
import 'package:flutter_calories_calculator/mealPlan.dart';
import 'database.dart';
class MealPlansPage extends StatefulWidget {
  const MealPlansPage({super.key});

  @override
  State<MealPlansPage> createState() => _MealPlanPageState();
}

class _MealPlanPageState extends State<MealPlansPage> {
  late List<MealPlan> mealPlans;
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

    mealPlans = await DatabaseHelper.instance.readAllMealPlans();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) =>Scaffold(appBar: AppBar(title: const Text("flutter calories calculator"),),
  body: Center(child:isLoading  ? const CircularProgressIndicator()
      : mealPlans.isEmpty
      ? const Text(
    'No Notes',
    style: TextStyle(color: Colors.white, fontSize: 24),
  )
      : Text("ok"),
  ),);
}