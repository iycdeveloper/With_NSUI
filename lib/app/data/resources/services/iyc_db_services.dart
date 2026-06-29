import 'dart:io';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// accesss Dbservices.db . function
class IycDbServices {
  IycDbServices._();

  static final IycDbServices db = IycDbServices._();

  static Database? _database;

  Future<Database?> get database async {
    Log.printILog("get database.................. IYC DB services....................");
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Log.printILog("..............init iyc db..........................");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "iyc.db");

    final exist = await databaseExists(path);
    if (exist) {
      Log.printILog("IYC DB found");
      Database db = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async => onCreate(db, version),
      );
      return db;
    } else {
      Log.printILog("IYC DB not found");
//db not available
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      File dbFile = File(path);
      print(dbFile.path == path);
      // Save copied asset to documents

      Database db = await openDatabase(path,
          version: 1, onCreate: (db, version) async => onCreate(db, version));
      Log.printILog("copied db");
      return db;
    }
  }

  deleteDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "iyc.db");
    _database?.close();
    _database = null;
    await deleteDatabase(path);

    return true;
  }

  onCreate(Database db, int version) async {
    Log.printILog("on create db................ version $version ...........");

    await db.execute(
      "CREATE TABLE IF NOT EXISTS membership_batches(BATCH_NO TEXT PRIMARY KEY ,TOTAL_AM INTEGER,"
      "PAYMENT_STATUS TEXT,STATE_CODE TEXT,DISTRICT_CODE TEXT,SYNC_STATUS TEXT)",
    );
    await db.execute(
        "CREATE TABLE IF NOT EXISTS membership_batch_members(ID TEXT,MEMBER_ID TEXT PRIMARY KEY, FIRST_NAME TEXT,"
        "LAST_NAME TEXT,PROFESSION TEXT,RELATIVE_NAME TEXT,EDUCATION TEXT,SEX_CODE TEXT,RELATION_CODE TEXT,"
        "CATEGORY_CODE TEXT,MOBILE1 TEXT,VERIFICATION_CODE TEXT,EMAIL TEXT,PINCODE TEXT,ADDRESS TEXT,DISTRICT_CODE TEXT,STATE_CODE TEXT,"
        "ASSEMBLY_CODE TEXT,DATE_OF_BIRTH TEXT,ID_TYPE TEXT, ID_DOCUMENT TEXT,ID_VALUE TEXT,AM_PHOTO TEXT,"
        "DISTRICT_NAME TEXT,STATE_NAME TEXT,ASSEMBLY_NAME TEXT,CSN_SP TEXT,"
        "CSN_SG TEXT, CSN_DP TEXT,CSN_AP TEXT,CSN_BL TEXT,CSN_BT TEXT,CREATED_BY TEXT,"
        "BATCH_NO TEXT,IS_SYNC TEXT,MODIFIED_ON TEXT,IS_EDITED_SCRUTINY TEXT,"
        "DOCUMENT_BACK_PATH TEXT,AADHAR TEXT,AADHAR_BACK_PATH TEXT,AADHAR_FRONT_PATH TEXT,VIDEO_FILE_PATH TEXT,AGGR_ID TEXT,"
        "DEVICE_ID TEXT,TMP_ID TEXT,REFERRER_ID TEXT,BOOTH_CODE TEXT,CITY TEXT,"
        "MANDALAM_CODE TEXT,BLOCK_CODE TEXT,CHANNEL TEXT,IS_INC_MEMBER TEXT)");

    await db.execute(
      "CREATE TABLE IF NOT EXISTS scrutiny_batches(BATCH_NO TEXT PRIMARY KEY ,TOTAL_AM INTEGER,"
      "PAYMENT_STATUS TEXT,STATE_CODE TEXT,DISTRICT_CODE TEXT,SYNC_STATUS TEXT,ONHOLD TEXT)",
    );
    await db.execute(
      "CREATE TABLE IF NOT EXISTS scrutiny_batch_members(MEMBER_ID TEXT PRIMARY KEY,ID TEXT, FIRST_NAME TEXT,"
      "LAST_NAME TEXT,PROFESSION TEXT,RELATIVE_NAME TEXT,RELATION_CODE TEXT,EDUCATION TEXT,SEX_CODE TEXT,"
      "CATEGORY_CODE TEXT,MOBILE1 TEXT,EMAIL TEXT,PINCODE TEXT,ADDRESS TEXT,DISTRICT_CODE TEXT,STATE_CODE TEXT,"
      "ASSEMBLY_CODE TEXT,DATE_OF_BIRTH TEXT,ID_TYPE TEXT, ID_DOCUMENT TEXT,AM_PHOTO TEXT,"
      "DISTRICT_NAME TEXT,STATE_NAME TEXT,ASSEMBLY_NAME TEXT,CSN_SP TEXT,"
      "CSN_SG TEXT, CSN_DP TEXT,CSN_AP TEXT,CSN_BL TEXT,CSN_BT TEXT,"
      "BATCH_NO TEXT,IS_SYNC TEXT,VERIFICATION_CODE TEXT,ID_VALUE TEXT,"
      "SCRUTINY_STATUS TEXT,SCRUTINY_CODE TEXT,REASON TEXT,MODIFIED_ON TEXT,VSN TEXT,VOTING_STATUS TEXT,IS_EDITED_SCRUTINY TEXT,"
      "CREATED_BY TEXT,"
      "DOCUMENT_BACK_PATH TEXT,VIDEO_FILE_PATH TEXT,AGGR_ID TEXT,"
      "DEVICE_ID TEXT,TMP_ID TEXT,REFERRER_ID TEXT,BOOTH_CODE TEXT,CITY TEXT,"
      "MANDALAM_CODE TEXT,BLOCK_CODE TEXT,CHANNEL TEXT,IS_INC_MEMBER TEXT)",
    );

    await db.execute(
      "CREATE TABLE IF NOT EXISTS primary_members(MEMBER_ID TEXT PRIMARY KEY,ID TEXT, FIRST_NAME TEXT,"
      "LAST_NAME TEXT,MOBILE TEXT,DISTRICT_CODE TEXT,STATE_CODE TEXT,BOOTH_CODE TEXT,ASSEMBLY_CODE TEXT,"
      "DOB TEXT,ACTIVE_STATUS TEXT,REFERRER_ID TEXT,AGGR_ID TEXT,ID_TYPE TEXT,BATCH_NO TEXT,"
      "DECLARATION TEXT,CREATED_BY TEXT,CREATED_ON TEXT,TMP_ID TEXT)",
    );
    return true;
  }
}
