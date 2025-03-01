import 'package:minor/Database/insert-expense.dart';
import 'package:minor/Database/insert-trip.dart';
import 'package:minor/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Database/database.dart';

class AddExpanseScreen extends StatefulWidget {
  final int? personId;
  final bool isFromEdit;

  const AddExpanseScreen(
      {super.key, required this.personId, required this.isFromEdit});

  @override
  _AddExpanseScreenState createState() => _AddExpanseScreenState();
}

class _AddExpanseScreenState extends State<AddExpanseScreen> {
  TextEditingController description = TextEditingController();
  TextEditingController expenseAmount = TextEditingController();
  final formKey = GlobalKey<FormState>();

  DateTime? selectDate;
  Trip? trip;
  Expense? expense;
  List<String> categoryList = [
    'Drink',
    'Food',
    'Hotel',
    'Medical',
    'Other',
    'Parking',
    'Shopping',
    'Toll',
  ];

  String? selectedCategory = 'Food';

  @override
  void initState() {
    personId = widget.personId;
    getTripDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 10.0,
        ),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6.0),
                  ),
                  border: Border.all(color: Colors.grey),
                ),
                margin: EdgeInsets.symmetric(vertical: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: DropdownButton<String>(
                  underline: Container(),
                  isExpanded: true,
                  value: selectedCategory,
                  items: categoryList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedCategory = value;
                    setState(() {});
                  },
                ),
              ),
              Container(
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Description';
                    }
                    return null;
                  },
                  controller: description,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  cursorColor: Colors.black,
                  maxLines: 1,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  DateTime? selectedDate = await selectDateGlobal(
                      context,
                      selectDate,
                      DateTime.fromMicrosecondsSinceEpoch(
                        int.parse(trip!.tripStartDate),
                      ),
                      DateTime.fromMicrosecondsSinceEpoch(
                        int.parse(trip!.tripEndDate),
                      ));
                  selectDate = selectedDate;
                  setState(() {});
                                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  height: 45,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(
                      Radius.circular(6.0),
                    ),
                  ),
                  child: Text(
                    selectDate == null
                        ? 'Select Date'
                        : DateFormat('dd/MM/yyyy')
                            .format(selectDate!)
                            .toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Container(
                child: TextFormField(
                  controller: expenseAmount,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Amount';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Amount',
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6.0),
                        ),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  cursorColor: Colors.black,
                  maxLines: 1,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Color(0xFF1BC0C5)),
                  ),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (selectDate == null) {
                        buildErrorDialog(
                            context: context,
                            title: '',
                            contant: 'Please select expense date');
                      } else {
                        if (widget.isFromEdit) {
                          updateExpense(expense!);
                        } else {
                          saveExpense();
                        }
                      }
                    }
                  },
                  child: Text(
                    'Save Expense',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateExpense(Expense expense) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    Expense expenses = Expense(
        expense.expenseId,
        expense.personId,
        expense.tripId,
        selectedCategory!,
        description.text.trim().toString(),
        selectDate!.microsecondsSinceEpoch,
        int.parse(expenseAmount.text.trim().toString()));
    await tripDao.updateExpense(expenses);
    Navigator.pop(context);
  }

  saveExpense() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;

    await tripDao.insertExpense(Expense(
      null,
      personId,
      tripId,
      selectedCategory!,
      description.text.trim().toString(),
      selectDate!.microsecondsSinceEpoch,
      int.parse(expenseAmount.text.trim().toString()),
    ));
    Navigator.pop(context);
  }

  getTripDetails() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    trip = await tripDao.findTripById(tripId!);

    if (widget.isFromEdit) {
      await getExpenseDetails();
      selectedCategory = expense!.category;
      description.text = expense!.description;
      expenseAmount.text = expense!.amount.toString();
      selectDate = DateTime.fromMicrosecondsSinceEpoch(expense!.dateTimeStamp);
    }
    setState(() {});
  }

  getExpenseDetails() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    expense = await tripDao.findExpenseById(expenseId!);
  }
}
