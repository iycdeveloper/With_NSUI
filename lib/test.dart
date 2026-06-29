//  // --> POST https://api.ycea.in/ycea/ycea-api/service/iyc/api/v1.0/chaloPanchayat/addYouthJodoData.php
//  // data: [{"V":"1.0","ORG":"IYC","SESSION_ID":"0Rb6AXVmpv2bqFmFoqLWBSod0Ojcjz+ytwFFuNSCJxhzXjscBO4xBDs9Up0IIwAi","DEVICE_ID":"UE1A.230829.036.A1","USER_ID":"HtSIAE5hR/P2iGvWq23EsA==","LATITUDE":"37.4219983","LONGITUDE":"-122.084","STATE_CODE":"BR","ASSEMBLY_CODE":"159","WARD":"32","FILE_LINK":"9916557335_1738479164508.jpg","FILE_VIDEO":"9916557335_1738479164508.mp4","PROGRAM_DATE":"2-2-2025","PROGRAM_PLACE":"Delhi","NO_OF_PEOPLE":"32","PROGRAM_TYPE":"Nukkad Sabha","EVENT_LEVEL":"National","USER_TYPE":"CREATOR","SOCIAL_LINKS":"instagram;facebook;twitter;youtube","FEEDBACK":"1","LEADER_NAME":"Gaurav kumar","LEADER_MOBILE":"8539959795","YOUTH_JODO_TYPE":"CP"}]
//  // --> END HTTP
//  // <-- 200 POST https://api.ycea.in/ycea/ycea-api/service/iyc/api/v1.0/chaloPanchayat/addYouthJodoData.php
//  // {"status":"SUCCESS","response":"Data added successfully"}
//  // <-- END HTTP
// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
// import 'package:http/http.dart' as http;
// // import 'dart:html' as html; // Only for Web

// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:path/path.dart';
// import 'package:flutter/foundation.dart' show kIsWeb;

// // Future<ByteData> loadAsset(String path) async {
// //   // String baseUrl = html.window.document.querySelector('meta[name="assetBaseUrl"]')?.attributes['content'] ?? "";
// //   final response = await http.get(Uri.parse('$baseUrl$path'));
  
// //   if (response.statusCode == 200) {
// //     return ByteData.sublistView(response.bodyBytes);
// //   } else {
// //     throw Exception("Failed to load asset");
// //   }
// // }

// class DatabaseHelper {
//   // static const String databasePath = "assets/local.fb";
//   static Database? _database;

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await initDB();
//     return _database!;
//   }

//   Future<Database> initDB() async {
//     var factory = databaseFactoryFfiWeb; // Web Database Factory
//     String dbName = "metadata_iyc_agg_010725.db"; // IndexedDB Name
//     return await factory.openDatabase(dbName);
//   }

//   Future<List<Map<String, dynamic>>> getTableData(String tableName) async {
//     final db = await database;
//     return await db.query(tableName);
//   }
// }

// // import 'dart:convert';
// // import 'package:flutter/services.dart' show rootBundle;
// // import 'package:flutter/foundation.dart' show kIsWeb;
// // import 'package:http/http.dart' as http;
// // import 'dart:html' as html;

// class FileLoader {
//   static const String filePath = "assets/metadata_iyc_agg_010725.db";

//   /// Load JSON data from file
//   static Future<Map<String, dynamic>?> loadJsonData() async {
//     try {
//       String jsonString;

//       if (kIsWeb) {
//         // Web: Fetch from assets via HTTP
//         // String baseUrl = html.window.document.querySelector('meta[name="assetBaseUrl"]')?.attributes['content'] ?? "./";
//         // final response = await http.get(Uri.parse('$baseUrl$filePath'));

//         // if (response.statusCode != 200) throw Exception("Failed to load file");
//         // jsonString = utf8.decode(response.bodyBytes);
//       } else {
//         // Mobile: Load from assets
//         jsonString = await rootBundle.loadString(filePath);
//       }

//       // return jsonDecode(jsonString); // Convert JSON string to Map
//     } catch (e) {
//       print("Error loading JSON: $e");
//       return null;
//     }
//   }
// }

// class Livelinesscheck extends StatefulWidget {
//   const Livelinesscheck({super.key});

//   @override
//   State<Livelinesscheck> createState() => _LivelinesscheckState();
// }

// class _LivelinesscheckState extends State<Livelinesscheck> {

// CameraController cameraController=CameraController(camera, ResolutionPreset.high,enableAudio: false);
// final inputImage=InputImage.fromBytes(bytes: bytes, metadata: metadata);


// Future<void> 
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       body: Transform.scale(scale: 0.5,
//       child: isCamera?Center():,
//       ),
//     );
//   }
// }