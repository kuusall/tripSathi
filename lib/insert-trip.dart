import 'dart:io';
import 'dart:typed_data';

import 'package:minor/res.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'Database/database.dart';
import 'Database/insert-person.dart';
import 'Database/insert-trip.dart';
import 'global.dart';

class InsertTripScreen extends StatefulWidget {
  final bool isFromEdit;

  const InsertTripScreen({super.key, required this.isFromEdit});

  @override
  _InsertTripScreenState createState() => _InsertTripScreenState();
}

class _InsertTripScreenState extends State<InsertTripScreen> {
  TextEditingController tripTitle = TextEditingController();
  TextEditingController tripDescription = TextEditingController();
  TextEditingController tripStartDate = TextEditingController();
  TextEditingController tripEndDate = TextEditingController();

  TextEditingController personName = TextEditingController();

  String? startDate;
  String? endDate;

  DateTime? date = DateTime.now();
  List<Person?>? person = [];
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();

  File? imgFile;
  final imgPicker = ImagePicker();
  Uint8List? _bytesImage;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFromEdit ? 'Edit Trip' : 'Add Trip'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    imgFile == null
                        ? Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              image: DecorationImage(image: AssetImage(Res.ic_trip_default3), fit: BoxFit.cover),
                            ),
                          )
                        : Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              image: DecorationImage(image: FileImage(imgFile!), fit: BoxFit.cover),
                            ),
                          ),
                    GestureDetector(
                      onTap: () {
                        showOptionsDialog(context);
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                          color: Colors.black.withOpacity(0.5),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Tap Background',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: tripTitle,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Trip Title';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF1BC0C5),
                        ),
                      ),
                      errorStyle: TextStyle(
                        color: const Color(0xFF1BC0C5),
                      ),
                      hintText: 'Trip Title',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: TextFormField(
                    controller: tripDescription,
                    cursorColor: Colors.black,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter Trip Description';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF1BC0C5),
                        ),
                      ),
                      errorStyle: TextStyle(
                        color: const Color(0xFF1BC0C5),
                      ),
                      hintText: 'Trip Description',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: tripStartDate,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Select Trip Start date';
                            } else {
                              return null;
                            }
                          },
                          onTap: () async {
                            date = await datePickerDialog(startDate);
                            if (date == null) {
                              date = DateTime.now();
                              tripStartDate.text = DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(date.toString()),
                              );
                              startDate = date!.microsecondsSinceEpoch.toString();
                            } else {
                              tripStartDate.text = DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(date.toString()),
                              );
                              startDate = date!.microsecondsSinceEpoch.toString();
                            }
                            setState(() {});
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: 'Trip Start Date',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color(0xFF1BC0C5),
                              ),
                            ),
                            errorStyle: TextStyle(
                              color: const Color(0xFF1BC0C5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('TO'),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          readOnly: true,
                          controller: tripEndDate,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Select Trip End date';
                            } else {
                              return null;
                            }
                          },
                          onTap: () async {
                            if (tripStartDate.text.isEmpty) {
                              buildErrorDialog(contant: 'Please Select Trip Start Date', context: context, title: '');
                            } else {
                              date = await endDatePickerDialog(startDate);
                              if (date == null) {
                                date = DateTime.now();
                                tripEndDate.text = DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(date.toString()),
                                );
                                endDate = date!.microsecondsSinceEpoch.toString();
                              } else {
                                tripEndDate.text = DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(date.toString()),
                                );
                                endDate = date!.microsecondsSinceEpoch.toString();
                              }
                              setState(() {});
                            }
                          },
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: 'Trip End Date',
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color(0xFF1BC0C5),
                              ),
                            ),
                            errorStyle: TextStyle(
                              color: const Color(0xFF1BC0C5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(7.0),
                    ),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add Person'),
                      GestureDetector(
                        onTap: () async {
                          showDialogs();
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: person!.length,
                    itemBuilder: (context, index) => Container(
                      margin: EdgeInsets.only(top: 7.0),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      height: 60.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(7.0),
                        ),
                        border: Border.all(color: Colors.grey),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.ac_unit_sharp),
                              Text(person![index]!.personName),
                            ],
                          ),
                          GestureDetector(
                              onTap: () async {
                                if (widget.isFromEdit) {
                                  print('object');
                                  final database = await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
                                  final tripDao = database.tripDao;
                                  final persons = Person(person![index]!.personId, tripId, person![index]!.personName, true);
                                  await tripDao.updatePerson(persons);
                                  getTripData();
                                }
                                person!.removeAt(index);
                                setState(() {});
                              },
                              child: Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  ),
                ),
                widget.isFromEdit
                    ? Container(
                        margin: EdgeInsets.only(top: 10.0),
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xFF1BC0C5),
                        child: TextButton(
                          onPressed: () => updateTrip(),
                          child: Text(
                            'Update Trip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    : Container(
                        margin: EdgeInsets.only(top: 10.0),
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xFF1BC0C5),
                        child: TextButton(
                          onPressed: () => insertData(),
                          child: Text(
                            'Add',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.isFromEdit) getTripData();

    super.initState();
  }

  getTripData() async {
    final database = await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    Trip? trip = await tripDao.findTripById(tripId!);

    person = await tripDao.findPersonsById(tripId!, false);

    tripTitle.text = trip!.tripTitle;
    tripDescription.text = trip.tripDescription;
    tripStartDate.text = DateFormat('dd-MM-yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(trip.tripStartDate))).toString();
    tripEndDate.text = DateFormat('dd-MM-yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(trip.tripEndDate))).toString();

    startDate = trip.tripStartDate;
    endDate = trip.tripEndDate;
    setState(() {});
  }

  insertData() async {
    if (formKey.currentState!.validate()) {
      final database = await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
      final tripDao = database.tripDao;
      if (_bytesImage == null) {
        final trip = Trip(null, '', tripTitle.text.toString(), tripDescription.text.toString(), startDate!, endDate!, false, null);
        await tripDao.insertTrip(trip);

        await addPerson();
        Navigator.pop(context, true);
      } else {
        final trip = Trip(null, '', tripTitle.text.toString(), tripDescription.text.toString(), startDate!, endDate!, false, _bytesImage);
        await tripDao.insertTrip(trip);
        await addPerson();
        Navigator.pop(context, true);
      }
    }
  }

  addPerson() async {
    final database = await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    Trip? trip = await tripDao.findLastElement();

    for (int i = 0; i < person!.length; i++) {
      await tripDao.insertPerson(Person(null, trip!.tripId, person![i]!.personName, false));
    }
  }

  insertPerson() async {
    person!.add(Person(null, null, personName.text, false));
    setState(() {});
  }

  datePickerDialog(String? date) async {
    return await showDatePicker(
        context: context,
        initialDate: tripStartDate.text.isEmpty ? DateTime.now() : DateTime.fromMicrosecondsSinceEpoch(int.parse(date!)),
        firstDate: tripStartDate.text.isEmpty ? DateTime.now() : DateTime.fromMicrosecondsSinceEpoch(int.parse(date!)),
        lastDate: DateTime(2100));
  }

  endDatePickerDialog(String? date) async {
    return await showDatePicker(
        context: context,
        initialDate: tripStartDate.text.isEmpty ? DateTime.now() : DateTime.fromMicrosecondsSinceEpoch(int.parse(date!)),
        firstDate: tripStartDate.text.isEmpty ? DateTime.now() : DateTime.fromMicrosecondsSinceEpoch(int.parse(date!)),
        lastDate: DateTime(2100));
  }

  void showDialogs() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)), //this right here
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: formKey1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Person Name';
                          }
                          return null;
                        },
                        controller: personName,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: const Color(0xFF1BC0C5),
                            ),
                          ),
                          errorStyle: TextStyle(
                            color: const Color(0xFF1BC0C5),
                          ),
                          hintText: 'Person Name',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 320.0,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey1.currentState!.validate()) {
                              final database = await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
                              final tripDao = database.tripDao;

                              if (widget.isFromEdit) {
                                await tripDao.insertPerson(Person(null, tripId, personName.text.trim().toString(), false));
                                insertPerson();
                                personName.clear();
                                Navigator.pop(context);
                                setState(() {});
                              } else {
                                insertPerson();
                                personName.clear();
                                Navigator.pop(context);
                                setState(() {});
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(const Color(0xFF1BC0C5)),
                          ),
                          child: Text(
                            "Add Person",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  updateTrip() async {
    final database = await $FloorAppDatabase.databaseBuilder('trip_database.db').build();
    final tripDao = database.tripDao;
    if (_bytesImage == null) {
      final trip = Trip(tripId, '', tripTitle.text.trim().toString(), tripDescription.text.trim().toString(), startDate!, endDate!, false, null);
      await tripDao.updateTrip(trip);
      Navigator.pop(context);
    } else {
      final trip =
          Trip(tripId, '', tripTitle.text.trim().toString(), tripDescription.text.trim().toString(), startDate!, endDate!, false, _bytesImage!);
      await tripDao.updateTrip(trip);
      Navigator.pop(context);
    }
  }

  Future<void> showOptionsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Options'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text('Capture Image From Camera'),
                    onTap: () {
                      openCamera();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  GestureDetector(
                    child: Text('Take Image From Gallery'),
                    onTap: () {
                      openGallery();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void openCamera() async {
    var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
    });
    _bytesImage = await imgCamera!.readAsBytes();
    Navigator.of(context).pop();
  }

  void openGallery() async {
    var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
    });
    _bytesImage = await imgGallery!.readAsBytes();
    Navigator.of(context).pop();
  }

}
