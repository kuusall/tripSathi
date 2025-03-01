// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TripDao? _tripDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Trip` (`tripId` INTEGER PRIMARY KEY AUTOINCREMENT, `tripBackgroundImage` TEXT NOT NULL, `tripTitle` TEXT NOT NULL, `tripDescription` TEXT NOT NULL, `tripStartDate` TEXT NOT NULL, `tripEndDate` TEXT NOT NULL, `isTripDeleted` INTEGER NOT NULL, `tripImage` BLOB)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Person` (`personId` INTEGER PRIMARY KEY AUTOINCREMENT, `tripId` INTEGER, `personName` TEXT NOT NULL, `isPersonDeleted` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Expense` (`expenseId` INTEGER PRIMARY KEY AUTOINCREMENT, `personId` INTEGER, `tripId` INTEGER, `category` TEXT NOT NULL, `description` TEXT NOT NULL, `dateTimeStamp` INTEGER NOT NULL, `amount` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TripDao get tripDao {
    return _tripDaoInstance ??= _$TripDao(database, changeListener);
  }
}

class _$TripDao extends TripDao {
  _$TripDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _tripInsertionAdapter = InsertionAdapter(
            database,
            'Trip',
            (Trip item) => <String, Object?>{
                  'tripId': item.tripId,
                  'tripBackgroundImage': item.tripBackgroundImage,
                  'tripTitle': item.tripTitle,
                  'tripDescription': item.tripDescription,
                  'tripStartDate': item.tripStartDate,
                  'tripEndDate': item.tripEndDate,
                  'isTripDeleted': item.isTripDeleted ? 1 : 0,
                  'tripImage': item.tripImage
                }),
        _personInsertionAdapter = InsertionAdapter(
            database,
            'Person',
            (Person item) => <String, Object?>{
                  'personId': item.personId,
                  'tripId': item.tripId,
                  'personName': item.personName,
                  'isPersonDeleted': item.isPersonDeleted ? 1 : 0
                }),
        _expenseInsertionAdapter = InsertionAdapter(
            database,
            'Expense',
            (Expense item) => <String, Object?>{
                  'expenseId': item.expenseId,
                  'personId': item.personId,
                  'tripId': item.tripId,
                  'category': item.category,
                  'description': item.description,
                  'dateTimeStamp': item.dateTimeStamp,
                  'amount': item.amount
                }),
        _personUpdateAdapter = UpdateAdapter(
            database,
            'Person',
            ['personId'],
            (Person item) => <String, Object?>{
                  'personId': item.personId,
                  'tripId': item.tripId,
                  'personName': item.personName,
                  'isPersonDeleted': item.isPersonDeleted ? 1 : 0
                }),
        _tripUpdateAdapter = UpdateAdapter(
            database,
            'Trip',
            ['tripId'],
            (Trip item) => <String, Object?>{
                  'tripId': item.tripId,
                  'tripBackgroundImage': item.tripBackgroundImage,
                  'tripTitle': item.tripTitle,
                  'tripDescription': item.tripDescription,
                  'tripStartDate': item.tripStartDate,
                  'tripEndDate': item.tripEndDate,
                  'isTripDeleted': item.isTripDeleted ? 1 : 0,
                  'tripImage': item.tripImage
                }),
        _expenseUpdateAdapter = UpdateAdapter(
            database,
            'Expense',
            ['expenseId'],
            (Expense item) => <String, Object?>{
                  'expenseId': item.expenseId,
                  'personId': item.personId,
                  'tripId': item.tripId,
                  'category': item.category,
                  'description': item.description,
                  'dateTimeStamp': item.dateTimeStamp,
                  'amount': item.amount
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Trip> _tripInsertionAdapter;

  final InsertionAdapter<Person> _personInsertionAdapter;

  final InsertionAdapter<Expense> _expenseInsertionAdapter;

  final UpdateAdapter<Person> _personUpdateAdapter;

  final UpdateAdapter<Trip> _tripUpdateAdapter;

  final UpdateAdapter<Expense> _expenseUpdateAdapter;

  @override
  Future<List<Trip>> findAllTrip(bool value) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Trip WHERE isTripDeleted = ?1',
        mapper: (Map<String, Object?> row) => Trip(
            row['tripId'] as int?,
            row['tripBackgroundImage'] as String,
            row['tripTitle'] as String,
            row['tripDescription'] as String,
            row['tripStartDate'] as String,
            row['tripEndDate'] as String,
            (row['isTripDeleted'] as int) != 0,
            row['tripImage'] as Uint8List?),
        arguments: [value ? 1 : 0]);
  }

  @override
  Future<Trip?> findLastElement() async {
    return _queryAdapter.query(
        'SELECT * FROM Trip ORDER BY tripId DESC LIMIT 1',
        mapper: (Map<String, Object?> row) => Trip(
            row['tripId'] as int?,
            row['tripBackgroundImage'] as String,
            row['tripTitle'] as String,
            row['tripDescription'] as String,
            row['tripStartDate'] as String,
            row['tripEndDate'] as String,
            (row['isTripDeleted'] as int) != 0,
            row['tripImage'] as Uint8List?));
  }

  @override
  Future<List<Person?>> findPersonsById(int id, bool value) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Person WHERE isPersonDeleted = ?2 and tripId = ?1',
        mapper: (Map<String, Object?> row) => Person(
            row['personId'] as int?,
            row['tripId'] as int?,
            row['personName'] as String,
            (row['isPersonDeleted'] as int) != 0),
        arguments: [id, value ? 1 : 0]);
  }

  @override
  Future<Trip?> findTripById(int id) async {
    return _queryAdapter.query('SELECT * FROM Trip WHERE tripId = ?1',
        mapper: (Map<String, Object?> row) => Trip(
            row['tripId'] as int?,
            row['tripBackgroundImage'] as String,
            row['tripTitle'] as String,
            row['tripDescription'] as String,
            row['tripStartDate'] as String,
            row['tripEndDate'] as String,
            (row['isTripDeleted'] as int) != 0,
            row['tripImage'] as Uint8List?),
        arguments: [id]);
  }

  @override
  Future<Person?> findPersonById(int id) async {
    return _queryAdapter.query('SELECT * FROM Person WHERE personId = ?1',
        mapper: (Map<String, Object?> row) => Person(
            row['personId'] as int?,
            row['tripId'] as int?,
            row['personName'] as String,
            (row['isPersonDeleted'] as int) != 0),
        arguments: [id]);
  }

  @override
  Future<List<Expense?>> findPersonExpenseById(int personId) async {
    return _queryAdapter.queryList('SELECT * FROM Expense WHERE personId = ?1',
        mapper: (Map<String, Object?> row) => Expense(
            row['expenseId'] as int?,
            row['personId'] as int?,
            row['tripId'] as int?,
            row['category'] as String,
            row['description'] as String,
            row['dateTimeStamp'] as int,
            row['amount'] as int),
        arguments: [personId]);
  }

  @override
  Future<List<Expense?>> findExpenseByTripId(int id) async {
    return _queryAdapter.queryList('SELECT * FROM Expense WHERE tripId = ?1',
        mapper: (Map<String, Object?> row) => Expense(
            row['expenseId'] as int?,
            row['personId'] as int?,
            row['tripId'] as int?,
            row['category'] as String,
            row['description'] as String,
            row['dateTimeStamp'] as int,
            row['amount'] as int),
        arguments: [id]);
  }

  @override
  Future<Expense?> findExpenseById(int id) async {
    return _queryAdapter.query('SELECT * FROM Expense WHERE expenseId = ?1',
        mapper: (Map<String, Object?> row) => Expense(
            row['expenseId'] as int?,
            row['personId'] as int?,
            row['tripId'] as int?,
            row['category'] as String,
            row['description'] as String,
            row['dateTimeStamp'] as int,
            row['amount'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertTrip(Trip trip) async {
    await _tripInsertionAdapter.insert(trip, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertPerson(Person person) async {
    await _personInsertionAdapter.insert(person, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertExpense(Expense expense) async {
    await _expenseInsertionAdapter.insert(expense, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePerson(Person person) async {
    await _personUpdateAdapter.update(person, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTrip(Trip trip) async {
    await _tripUpdateAdapter.update(trip, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateExpense(Expense trip) async {
    await _expenseUpdateAdapter.update(trip, OnConflictStrategy.abort);
  }
}
