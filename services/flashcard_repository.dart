import 'package:sqflite/sqflite.dart';
import '../models/flashcard.dart';
import 'database_service.dart';

class FlashcardRepository {
  // Insert a new flashcard into the local SQLite database
  Future<void> insertFlashcard(Flashcard flashcard) async {
    final db = await DatabaseService.instance.database;
    await db.insert(
      'flashcards',
      flashcard.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all flashcards from local storage (works 100% offline!)
  Future<List<Flashcard>> getFlashcards() async {
    final db = await DatabaseService.instance.database;
    final maps = await db.query('flashcards');

    return List.generate(maps.length, (i) {
      return Flashcard.fromMap(maps[i]);
    });
  }

  // Delete a flashcard by its unique ID
  Future<void> deleteFlashcard(String id) async {
    final db = await DatabaseService.instance.database;
    await db.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
