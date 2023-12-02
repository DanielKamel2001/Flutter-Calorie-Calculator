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
  final TextEditingController _calTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late DateTime date;
  List<Food> selectedItems = [];
  bool isLoading = false;

  DateTime selectedDate = DateTime.now();

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

    var apple = const Food(
      id: null,
      name: 'Apple',
      calories: 59,
    );
    var banana = const Food(
      id: null,
      name: 'banana',
      calories: 151,
    );
    var grapes = const Food(
      id: null,
      name: 'grapes',
      calories: 100,
    );
    var Cheeseburger = const Food(
      id: null,
      name: 'cheeseburger',
      calories: 285,
    );
    var Pizza = const Food(
      name: 'pizza',
      calories: 285,
      id: null,
    );
var Egg = const Food(
      id: null,
      name: 'Egg',
      calories: 78,
    );
    var Fish = const Food(
      id: null,
      name: 'Fish',
      calories: 136,
    );
    var Bread = const Food(
      id: null,
      name: 'Bread',
      calories: 75,
    );
    var Chocolate = const Food(
      id: null,
      name: 'Chocolate',
      calories: 155,
    );
    var OrangeJ = const Food(
      name: 'Orange Juice',
      calories: 111,
      id: null,
    );

    // await DatabaseHelper.instance.insertFood(apple);
    // await DatabaseHelper.instance.insertFood(banana);
    // await DatabaseHelper.instance.insertFood(Cheeseburger);
    // await DatabaseHelper.instance.insertFood(Pizza);
    // await DatabaseHelper.instance.insertFood(grapes);
    // await DatabaseHelper.instance.insertFood(Egg);
    // await DatabaseHelper.instance.insertFood(Fish);
    // await DatabaseHelper.instance.insertFood(Bread);
    // await DatabaseHelper.instance.insertFood(Chocolate);
    // await DatabaseHelper.instance.insertFood(OrangeJ);
    foods = await DatabaseHelper.instance.readAllFoods();

    setState(() => isLoading = false);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2015, 8), lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(//actions: [buildButton()],
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
                    : Column(
                        children: [
                          TextField(
                            controller: _calTextController,
                            decoration: const InputDecoration(
                              labelText: 'Target Calories',
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(),
                              hintText: 'Target Calories',
                            ),
                          ),
                          const SizedBox(),
                          Text("Meal Plan For Date ${selectedDate.toLocal()}"),
                          MultiSelectDialogField(
                            items: buildFoodSelectors(foods),
                            title: const Text("Foods"),
                            selectedColor: Colors.blue,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                              border: Border.all(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                            buttonIcon: const Icon(
                              Icons.fastfood,
                              color: Colors.blue,
                            ),
                            buttonText: Text(
                              "Food In Plan",
                              style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 16,
                              ),
                            ),
                            validator: (values) {
                              if (values == null || values.isEmpty) {
                                return "Required";
                              }
                              List<String> names = values.map((e) => e.name).toList();
                              print("Checking");
                              if (names.contains("Apple")) {
                                return "Frogs are weird!";
                              }
                              return null;
                            },
                            // onConfirm: (values) {
                            //   setState(() {
                            //     _selectedAnimals3 = values;
                            //   });
                            //   _multiSelectKey.currentState.validate();
                            // },
                            onConfirm: (results) {
                              selectedItems = results;
                            },
                          ),
                          Container(child: ElevatedButton(onPressed: () => _selectDate(context), child: const Text('Select date'))),
                          TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                              ),
                              onPressed: () {
                                var calTotal = 0;
                                for (var food in selectedItems) {
                                  calTotal = calTotal + food.calories;
                                }
                                print(calTotal);
                                print("ok:" + _calTextController.text);
                                print("ok:" + int.parse(_calTextController.text).toString());
                                if (_calTextController.text.isEmpty) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('A Target cal is Blank'),
                                        content: const Text('Fields are not allowed to be blank please write all fields.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              // Close the dialog
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                                if (int.parse(_calTextController.text) < calTotal) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('A Too Many Calories'),
                                        content: const Text('Please select fewer or different items.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              // Close the dialog
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // dispose();
                                  addOrUpdateMealPlan();
                                }
                              },
                              child: const Text('Save Note'))
                        ] //SingleChildScrollView(child: foodCards(foods)),
                        ,
                      )),
      ));

  void addOrUpdateMealPlan() async {
    final isValid = _formKey.currentState!.validate();
    print("checking validity: $isValid");
    if (isValid) {
      // final isUpdating = widget.note != null;

      // if (isUpdating) {
      //   await updateNote();
      // } else {
      await addMealPlan();
      // }

      Navigator.of(context).pop();
    }
  }

  Widget buildButton() {
    final isFormValid = selectedItems.isNotEmpty && selectedDate != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateMealPlan,
        child: const Text('Save'),
      ),
    );
  }

  Widget foodCards(List<Food> foods) {
    return Column(children: foods.map((food) => foodCard(food)).toList());
  }

  List<MultiSelectItem<Food>> buildFoodSelectors(List<Food> foods) {
    // return  foods.map((food) => foodSelector(food)).toList();
    return foods.map((food) => MultiSelectItem<Food>(food, food.name)).toList();
  }

  // foodSelector(Food food){
  //   return
  // }

  Widget foodCard(Food food) {
    return Container(
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Column(children: [
          Row(children: [const Text("FOOD:"), Text(food.name)]),
          Row(children: [const Text("CALORIES:"), Text(food.calories.toString())])
        ]));
  }

  addMealPlan() async {
    print("num of selected Items${selectedItems.length}");
    print("num of selected date$selectedDate");
    print("num of selected date " + "${selectedDate.toLocal().day}-${selectedDate.toLocal().month}-${selectedDate.toLocal().year}");
    var mealPlans = [];
    for (var food in selectedItems) {
      if (food.id != null) {
        mealPlans.add(MealPlan(date: "${selectedDate.toLocal().day}-${selectedDate.toLocal().month}-${selectedDate.toLocal().year}", food: food.id));
      }
    }
    for (var meal in mealPlans) {
      await DatabaseHelper.instance.insertMealPlan(meal);
    }
  }
}
