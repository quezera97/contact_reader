import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/contact_model.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "Contact.db";

  static Future<Database> _getDB() async {
    return openDatabase(join(await getDatabasesPath(), _dbName), onCreate: (db, version) async => await db.execute("CREATE TABLE Contact(id INTEGER PRIMARY KEY AUTOINCREMENT, first_name TEXT, last_name TEXT, email TEXT, avatar TEXT, favorited INTEGER);"), version: _version);
  }

  static Future<void> clearAllContacts() async {
    final db = await _getDB();
    await db.delete("Contact");
  }

  // static Future<int> addContact(ContactModel contact) async {
  //   final db = await _getDB();
  //   return await db.insert("Contact", contact.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  // }

  static Future<int> addContact(ContactModel contact) async {
    final db = await _getDB();

    final existingContacts = await db.query(
      'Contact',
      where: 'first_name = ? AND last_name = ?',
      whereArgs: [contact.firstName, contact.lastName],
    );

    print(existingContacts);

    if (existingContacts.isNotEmpty) {
      return -1;
    } else {
      return await db.insert('Contact', contact.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static Future<int> updateContact(ContactModel contact) async {
    final db = await _getDB();
    return await db.update("Contact", contact.toJson(), where: 'id = ?', whereArgs: [contact.id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteContact(ContactModel contact) async {
    final db = await _getDB();
    return await db.delete("Contact", where: 'id = ?', whereArgs: [contact.id]);
  }

  static Future<List<ContactModel>?> getAllContact() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Contact");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => ContactModel.fromJson(maps[index]));
  }
}
