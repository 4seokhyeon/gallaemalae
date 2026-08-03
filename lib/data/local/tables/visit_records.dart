import 'package:drift/drift.dart';

class VisitRecords extends Table {
  TextColumn get id => text()();
  TextColumn get placeId => text()();
  TextColumn get placeName => text()();
  DateTimeColumn get visitedAt => dateTime()();
  IntColumn get crowdLevel => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
