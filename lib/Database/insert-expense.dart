import 'package:floor/floor.dart';

@entity
class Expense {
  @PrimaryKey(autoGenerate: true)
  final int? expenseId;
  final int? personId;
  final int? tripId;
  final String category;
  final String description;
  final int dateTimeStamp;
  final int amount;

  Expense(this.expenseId, this.personId, this.tripId, this.category,
      this.description, this.dateTimeStamp, this.amount);
}
