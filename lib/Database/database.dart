import 'dart:async';
import 'dart:typed_data';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'get-trip-details.dart';
import 'insert-expense.dart';
import 'insert-person.dart';
import 'insert-trip.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Trip, Person, Expense])
abstract class AppDatabase extends FloorDatabase {
  TripDao get tripDao;
}
