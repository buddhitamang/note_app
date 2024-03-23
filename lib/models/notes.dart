import 'package:isar/isar.dart';

part 'notes.g.dart';
@collection
class Notes {
  Id id = Isar.autoIncrement;
  late String text;
}
