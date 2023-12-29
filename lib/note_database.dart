import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
class NoteDatabase {
  static late Isar isar;
  static Future<void> initialize() async{
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
        [NoteSchema],
        directory: dir.path );
  }
  final List<Note> currentNotes = [];
}