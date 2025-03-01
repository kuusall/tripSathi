import 'package:minor/Database/insert-expense.dart';
import 'package:floor/floor.dart';

import 'insert-person.dart';
import 'insert-trip.dart';

@dao
abstract class TripDao {
  @insert
  Future<void> insertTrip(Trip trip);

  @insert
  Future<void> insertPerson(Person person);

  @insert
  Future<void> insertExpense(Expense expense);

  @Query('SELECT * FROM Trip WHERE isTripDeleted = :value')
  Future<List<Trip>> findAllTrip(bool value);

  @Query('SELECT * FROM Trip ORDER BY tripId DESC LIMIT 1')
  Future<Trip?> findLastElement();

  @Query(
      'SELECT * FROM Person WHERE isPersonDeleted = :value and tripId = :id ')
  Future<List<Person?>> findPersonsById(int id, bool value);

  @Query('SELECT * FROM Trip WHERE tripId = :id')
  Future<Trip?> findTripById(int id);

  @Query('SELECT * FROM Person WHERE personId = :id')
  Future<Person?> findPersonById(int id);

  @Query('SELECT * FROM Expense WHERE personId = :personId')
  Future<List<Expense?>> findPersonExpenseById(int personId);

  @Query('SELECT * FROM Expense WHERE tripId = :id')
  Future<List<Expense?>> findExpenseByTripId(int id);

  @Query('SELECT * FROM Expense WHERE expenseId = :id')
  Future<Expense?> findExpenseById(int id);

  @update
  Future<void> updatePerson(Person person);

  @update
  Future<void> updateTrip(Trip trip);

  @update
  Future<void> updateExpense(Expense trip);
}
