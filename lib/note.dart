import 'package:isar/isar.dart';
part 'notepage.dart';

@Collection()
class Note{
  Id id = Isar.autoIncrement;
  late String text;
}