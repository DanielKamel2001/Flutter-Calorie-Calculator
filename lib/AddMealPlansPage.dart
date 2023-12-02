
import 'package:flutter/material.dart';
import 'package:flutter_calories_calculator/mealPlan.dart';

class AddMealPlansPage extends StatefulWidget {
  final List<MealPlan>? mealPlan; //list of meal plan objects in "THIS" mealplan

  const AddMealPlansPage({
    Key? key,
    this.mealPlan,
  }) : super(key: key);

  @override
  State<AddMealPlansPage> createState()  => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddMealPlansPage>{
  final _formKey = GlobalKey<FormState>();
  late DateTime date;


  @override
  Widget build(BuildContext context)=> Scaffold(
    appBar: AppBar(
      // actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: Text("AddMealPlansPage")
      // NoteFormWidget(
      //   isImportant: isImportant,
      //   number: number,
      //   title: title,
      //   description: description,
      //   onChangedImportant: (isImportant) =>
      //       setState(() => this.isImportant = isImportant),
      //   onChangedNumber: (number) => setState(() => this.number = number),
      //   onChangedTitle: (title) => setState(() => this.title = title),
      //   onChangedDescription: (description) =>
      //       setState(() => this.description = description),
      // ),
    ),
  );
}