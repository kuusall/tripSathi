import 'package:minor/Database/insert-person.dart';
import 'package:minor/add-expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Database/database.dart';
import 'Database/insert-expense.dart';
import 'global.dart';

class ExpenseSummery extends StatefulWidget {
  final bool isFromPersonDetails;

  const ExpenseSummery({super.key, required this.isFromPersonDetails});

  @override
  _ExpenseSummeryState createState() => _ExpenseSummeryState();
}

class _ExpenseSummeryState extends State<ExpenseSummery> {
  int? totalExpense;
  List<Expense?>? totalExpenses;

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Summery'),
      ),
      body: isLoading == true
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 10.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7.0),
                        ),
                        color: Colors.white,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50.0,
                      child: Text(
                        'Total Expense: ${totalExpense.toString()}',
                      ),
                    ),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: totalExpenses!.length,
                      itemBuilder: (context, index) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7.0),
                          ),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(DateFormat('dd-MM-yyyy')
                                  .format(DateTime.fromMicrosecondsSinceEpoch(
                                      totalExpenses![index]!.dateTimeStamp))
                                  .toString()),
                            ),
                            Container(
                              child: Text(
                                  totalExpenses![index]!.category.toString()),
                            ),
                            Container(
                              child: Text(totalExpenses![index]!
                                  .description
                                  .toString()),
                            ),
                            Container(
                              child: FutureBuilder<Person?>(
                                future: getPersonById(
                                    totalExpenses![index]!.personId),
                                builder: (context,
                                        AsyncSnapshot<Person?> snapshot) =>
                                    Container(
                                  child: Text(!snapshot.hasData
                                      ? ''
                                      : 'Expense BY:  ${snapshot.data!.personName}'),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Text(
                                      totalExpenses![index]!.amount.toString()),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    expenseId =
                                        totalExpenses![index]!.expenseId;
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AddExpanseScreen(
                                                  personId:
                                                      totalExpenses![index]!
                                                          .personId,
                                                  isFromEdit: true),
                                        ));
                                    getData();
                                  },
                                  child: Container(
                                    child: Icon(
                                      Icons.edit,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  getData() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;

    if (widget.isFromPersonDetails) {
      totalExpenses = [];
      totalExpense = 0;

      List<Expense?> totalExpensess = await viewPersonExpenseData(personId!);
      if (totalExpenses!.isNotEmpty)
        for (int i = 0; i < totalExpensess.length; i++) {
          totalExpense = (totalExpense! + totalExpensess[i]!.amount);
          totalExpenses!.add(totalExpensess[i]);
          if (i == (totalExpensess.length - 1)) {
            isLoading = false;
            setState(() {});
          }
        }
      else {
        isLoading = false;
        setState(() {});
      }

      print(totalExpenses!.length);
    } else {
      totalExpense = 0;
      List<Expense?> totalExpensess = await getTotalExpense(tripId);

      totalExpenses = [];
      if (totalExpensess.isNotEmpty) {
        for (int i = 0; i < totalExpensess.length; i++) {
          Person? person =
              await tripDao.findPersonById(totalExpensess[i]!.personId!);
          if (!person!.isPersonDeleted) {
            totalExpense = (totalExpense! + totalExpensess[i]!.amount);
            totalExpenses!.add(totalExpensess[i]);
          }
          if (i == (totalExpensess.length - 1)) {
            isLoading = false;
            setState(() {});
          }
        }
      } else {
        isLoading = false;
        setState(() {});
      }
    }
  }

  Future<List<Expense?>> viewPersonExpenseData(id) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    return await tripDao.findPersonExpenseById(id);
  }

  Future<List<Expense?>> getTotalExpense(id) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    return await tripDao.findExpenseByTripId(id);
  }

  Future<Person?> getPersonById(id) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    return await tripDao.findPersonById(id);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
}
