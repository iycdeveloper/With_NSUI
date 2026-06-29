import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

Future<String> downloadDbFile() async {
  final response = await http.get(Uri.parse('https://withiyc.s3.ap-south-1.amazonaws.com/metadata_iyc_agg_140525.db'));

  if (response.statusCode == 200) {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = join(documentsDirectory.path, 'mydb.db');

    final file = File(dbPath);
    await file.writeAsBytes(response.bodyBytes);
    return dbPath;
  } else {
    throw Exception('Failed to download database');
  }
}

Future<Database> openDatabaseFromFile(String dbPath) async {
  return await openDatabase(dbPath, readOnly: true); // or false if you need to write
}
