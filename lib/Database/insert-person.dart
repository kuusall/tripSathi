import 'package:floor/floor.dart';

@entity
class Person {
  @PrimaryKey(autoGenerate: true)
  final int? personId;
  final int? tripId;
  final String personName;
  final bool isPersonDeleted;

  Person(this.personId, this.tripId, this.personName, this.isPersonDeleted);
}
