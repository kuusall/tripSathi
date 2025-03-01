import 'package:minor/res.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'Database/database.dart';
import 'Database/insert-expense.dart';
import 'Database/insert-person.dart';
import 'Database/insert-trip.dart';
import 'insert-trip.dart';
import 'trip-details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Trip>? tripDetails;
  int? totalExpense;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            bool? added = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InsertTripScreen(
                  isFromEdit: false,
                ),
              ),
            );

            if (added != null && added) {
              getData();
            }
          }),
      appBar: AppBar(
        title: Text('Trip Expense'),
        centerTitle: false,
      ),
      body: tripDetails == null
          ? Container()
          : ListView.builder(
              itemCount: tripDetails!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TripDetailsScreen(
                            tripId: tripDetails![index].tripId!,
                          ),
                        ));
                    getData();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 5.0,
                    ),
                    child: Stack(
                      children: [
                        tripDetails![index].tripImage == null
                            ? Container(
                                width: MediaQuery.of(context).size.width,
                                clipBehavior: Clip.hardEdge,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Image.asset(
                                  Res.ic_trip_default3,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                clipBehavior: Clip.hardEdge,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Image.memory(
                                  tripDetails![index].tripImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          alignment: Alignment.center,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: Text(
                                  tripDetails![index].tripTitle.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  tripDetails![index]
                                      .tripDescription
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  DateFormat('yyyy-MM-dd')
                                      .format(
                                        DateTime.fromMicrosecondsSinceEpoch(
                                          int.parse(tripDetails![index]
                                              .tripStartDate),
                                        ),
                                      )
                                      .toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 200,
                          alignment: Alignment.bottomCenter,
                          child: FutureBuilder<List<Person?>>(
                            future: getPersonData(tripDetails![index].tripId),
                            builder: (context,
                                AsyncSnapshot<List<Person?>> snapshot) {
                              if (snapshot.hasData) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                    vertical: 10.0,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ListView.builder(
                                        padding: EdgeInsets.all(10.0),
                                        shrinkWrap: true,
                                        primary: false,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) =>
                                            Container(
                                                alignment: Alignment.bottomLeft,
                                                child:
                                                    Icon(Icons.ac_unit_sharp)),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                          color: Color(0xFF1BC0C5),
                                        ),
                                        child: FutureBuilder<List<Expense?>>(
                                          builder: (context,
                                              AsyncSnapshot<List<Expense?>>
                                                  expenseSnapshot) {
                                            if (snapshot.hasData) {
                                              totalExpense = 0;

                                              if (expenseSnapshot.data != null)
                                                for (int i = 0;
                                                    i <
                                                        expenseSnapshot
                                                            .data!.length;
                                                    i++) {
                                                  bool contain = snapshot.data!
                                                      .where((element1) =>
                                                          element1!.personId ==
                                                          expenseSnapshot
                                                              .data![i]!
                                                              .personId)
                                                      .isNotEmpty;

                                                  if (contain) {
                                                    totalExpense =
                                                        (totalExpense! +
                                                            expenseSnapshot
                                                                .data![i]!
                                                                .amount);
                                                  }
                                                }
                                              return Text(
                                                '${totalExpense.toString()}\$',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            } else {
                                              return Text(
                                                '\$',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              );
                                            }
                                          },
                                          future: getTotalExpense(
                                              tripDetails![index].tripId),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return Text(
                                  '\$',
                                  style: TextStyle(color: Colors.white),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }

  Future<List<Expense?>> getTotalExpense(id) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    return await tripDao.findExpenseByTripId(id);
  }

  Future<List<Trip>> viewData() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    return await tripDao.findAllTrip(false);
  }

  Future<List<Person?>> getPersonData(id) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    return await tripDao.findPersonsById(id, false);
  }

  getData() async {
    tripDetails = await viewData();

    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
    requestPermission(Permission.storage);
  }

  Future<void> requestPermission(Permission permission) async {
    await permission.request();
  }
}
