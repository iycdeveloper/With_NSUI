import 'dart:collection';
import 'dart:io';
import 'package:flutter/foundation.dart' as debug;
import 'package:flutter/services.dart';
import 'package:iyc/app/core/utils/logger.dart';
import 'package:iyc/helper/dowload_db.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';
import 'package:iyc/model/offline_model/database/assembly.dart';
import 'package:iyc/model/offline_model/database/blocks.dart';
import 'package:iyc/model/offline_model/database/booth.dart';
import 'package:iyc/model/offline_model/database/category.dart';
import 'package:iyc/model/offline_model/database/districts.dart';
import 'package:iyc/model/offline_model/database/lok_sabha.dart';
import 'package:iyc/model/offline_model/database/mandalam.dart';
import 'package:iyc/model/offline_model/database/nominations.dart';
import 'package:iyc/model/offline_model/database/states.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:http/http.dart' as http;

/// accesss Dbservices.db . function
class DbServices {
  DbServices._();

  static final DbServices db = DbServices._();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  String databasePath = "metadata_iyc_agg_010725.db";

  initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databasePath);

    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    ByteData data = await rootBundle.load(join('assets', databasePath));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Save copied asset to documents
    await new File(path).writeAsBytes(bytes, flush: true);

    Database db = await openDatabase(path,
        version: 1, onCreate: (db, version) async => onCreate(db, version));
    // String path = await downloadDbFile();
    // print('PAth::'+path);

    // Database db = await openDatabase(path,
    //     version: 1, onCreate: (db, version) async => onCreate(db, version));

    return db;
  }

  // Future<Database> _initDBForWeb() async {
  //   var factory = databaseFactoryFfiWeb; // Web Database Factory
  //   String dbName = databasePath;

  //   // Check if the database exists in IndexedDB
  //   // Database db = await factory.openDatabase(dbName);
  //   Database db;
  //   // Load the database file from assets
  //   String baseUrl = html.window.document
  //           .querySelector('meta[name="assetBaseUrl"]')
  //           ?.attributes['content'] ??
  //       "./assets/";
  //   final response = await http.get(Uri.parse('$baseUrl$databasePath'));

  //   if (response.statusCode == 200) {
  //     Uint8List bytes = response.bodyBytes;
  //     await factory.writeDatabaseBytes(dbName, bytes);
  //     db = await factory.openDatabase(dbName);
  //   } else {
  //     throw Exception("Failed to load database from assets");
  //   }

  //   return db;
  // }

  deleteDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, databasePath);
    _database?.close();
    _database = null;
    await deleteDatabase(path);

    return true;
  }

  onCreate(Database db, int version) async {}

  Future<List<States>> getAllStates([bool pickAllStates = false]) async {
    //
    //
    final _dataObject = await database;
    // print("tabless");
    // (await _dataObject!.query('sqlite_master', columns: ['type', 'name'])).forEach((row) {
    //   print(row.values);
    // });
    // final tables = await _dataObject!.rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    // print(tables);
    final List<Map<String, dynamic>> _stateList;
    if (pickAllStates) {
      _stateList = await _dataObject!.query('TBL_MASTER_STATE_IYC',
          columns: [], orderBy: 'STATE_NAME ASC');
      // Log.printDLog('State in ASC order');
    } else {
      _stateList = await _dataObject!.query('TBL_MASTER_STATE_IYC',
          columns: [],
          where: "IS_ENABLED=?",
          whereArgs: ["1"],
          orderBy: 'STATE_NAME ASC');
    }
    List<States> stateList = List.generate(
        _stateList.length,
        (index) => States(
            id: _stateList[index]["ID"],
            name: _stateList[index]["STATE_NAME"],
            stateCode: _stateList[index]["MASTER_STATE_CODE"],
            isEnabled: _stateList[index]["IS_ENABLED"]));
    return stateList;
  }

  Future<List<LokSabha>> getAllLokSabha(String stateCode) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _stateList;
    _stateList = await _dataObject!.query('TBL_LS_AS_MAPPING',
        columns: ['DISTINCT LS_NAME, STATE_CODE, LS_CODE'],
        orderBy: 'LS_NAME ASC',
        where: "STATE_CODE = ?",
        whereArgs: [stateCode]);
    List<LokSabha> lokSabhaList = List.generate(_stateList.length, (index) {
      // Log.printDLog(_stateList[index]);
      return LokSabha(
          id: 0,
          name: _stateList[index]["LS_NAME"],
          stateCode: _stateList[index]["STATE_CODE"],
          lokSabhaCode: _stateList[index]["LS_CODE"].toString());
    });
    return lokSabhaList;
  }

  Future<List<LokSabha>> getAllAssemblyByLS(
      String lsCode, String stateCode) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _stateList;
    _stateList = await _dataObject!.query('TBL_LS_AS_MAPPING',
        columns: ['AS_NAME, AS_CODE, LS_CODE'],
        orderBy: 'AS_NAME ASC',
        where: "LS_CODE = ? AND STATE_CODE = ?",
        whereArgs: [lsCode, stateCode]);
    List<LokSabha> lokSabhaList = List.generate(_stateList.length, (index) {
      return LokSabha(
          id: 0,
          name: _stateList[index]["AS_NAME"],
          stateCode: _stateList[index]["LS_CODE"].toString(),
          lokSabhaCode: _stateList[index]["AS_CODE"].toString());
    });
    return lokSabhaList;
  }

  Future<List<Districts>> getDistricts(States? states,
      {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _districtList = await _dataObject!.query(
        'TBL_DISTRICT_IYC',
        where: "MASTER_STATE_CODE = ?",
        whereArgs: [stateCode ?? states?.stateCode]);
    List<Districts> districtsList =
        List.generate(_districtList.length, (index) {
      return Districts(
          id: _districtList[index]["ID"] ?? 0,
          name: _districtList[index]["DISTRICT_NAME"],
          stateCode: _districtList[index]["MASTER_STATE_CODE"],
          isEnabled: _districtList[index]["IS_ENABLED"],
          districtCode: _districtList[index]["DISTRICT_CODE"]);
    });
    districtsList.sort((a, b) => a.name.compareTo(b.name));

    return districtsList;
  }

  Future<List<DropdownItem>> getDistrictDropDown({
    String? stateCode,
  }) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _districtList = await _dataObject!.query(
        'TBL_DISTRICT_IYC',
        where: stateCode != null ? "MASTER_STATE_CODE = ?" : null,
        whereArgs: stateCode != null ? [stateCode] : null);
    List<DropdownItem> districtsList = List.generate(
        _districtList.length,
        (index) => DropdownItem(_districtList[index]["DISTRICT_NAME"],
            _districtList[index]["DISTRICT_CODE"]));
    return districtsList;
  }

  /// get assembly by passing district model or state code
  Future<List<Assembly>> getAssembly(Districts? districts,
      {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _assemblyList = await _dataObject!.query(
        'TBL_IYC_ASSEMBLY',
        where: stateCode != null
            ? "MASTER_STATE_CODE = ?"
            : "DISTRICT_CODE = ? AND MASTER_STATE_CODE = ?",
        whereArgs: stateCode != null
            ? [stateCode]
            : [districts?.districtCode, districts?.stateCode],
        orderBy: 'ASSEMBLY_NAME ASC');
    List<Assembly> assemblyList = List.generate(
        _assemblyList.length,
        (index) => Assembly(
            id: _assemblyList[index]["ID"] ?? 0,
            name: _assemblyList[index]["ASSEMBLY_NAME"],
            stateCode: _assemblyList[index]["MASTER_STATE_CODE"],
            isEnabled: _assemblyList[index]["IS_ENABLED"],
            districtCode: _assemblyList[index]["DISTRICT_CODE"],
            assemblyCode: _assemblyList[index]["ASSEMBLY_CODE"]));
    return assemblyList;
  }

  /// get assembly by passing district model or state code
  Future<List<Assembly>> getAssemblyByDistrictCode(String? districtCode,
      {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _assemblyList = await _dataObject!.query(
        'TBL_IYC_ASSEMBLY',
        where: stateCode != null
            ? "MASTER_STATE_CODE = ?"
            : "DISTRICT_CODE = ? AND MASTER_STATE_CODE = ?",
        whereArgs: stateCode != null ? [stateCode] : [districtCode!, stateCode],
        orderBy: 'ASSEMBLY_NAME ASC');
    List<Assembly> assemblyList = List.generate(
        _assemblyList.length,
        (index) => Assembly(
            id: _assemblyList[index]["ID"],
            name: _assemblyList[index]["ASSEMBLY_NAME"],
            stateCode: _assemblyList[index]["MASTER_STATE_CODE"],
            isEnabled: _assemblyList[index]["IS_ENABLED"],
            districtCode: _assemblyList[index]["DISTRICT_CODE"],
            assemblyCode: _assemblyList[index]["ASSEMBLY_CODE"]));
    return assemblyList;
  }

  Future<List<Assembly>> getAssemblyBJ(Districts? districts,
      {String? stateCode}) async {
    final _dataObject = await database;
    final List<Map<String, dynamic>> _assemblyList = await _dataObject!.query(
        'TBL_IYC_ASSEMBLY',
        where: stateCode != null
            ? "MASTER_STATE_CODE = ?"
            : "DISTRICT_CODE = ? AND MASTER_STATE_CODE = ?",
        whereArgs: stateCode != null
            ? [stateCode]
            : [districts?.districtCode, districts?.stateCode]);
    List<Assembly> assemblyList = List.generate(
        _assemblyList.length,
        (index) => Assembly(
            id: _assemblyList[index]["ID"],
            name: _assemblyList[index]["ASSEMBLY_NAME"],
            stateCode: _assemblyList[index]["MASTER_STATE_CODE"],
            isEnabled: _assemblyList[index]["IS_ENABLED"],
            districtCode: _assemblyList[index]["DISTRICT_CODE"],
            assemblyCode: _assemblyList[index]["ASSEMBLY_CODE"]));
    return assemblyList;
  }

  Future<List<Assembly>> getAssemblyForVotersList(Districts? districts,
      {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _assemblyList = await _dataObject!.query(
        'TBL_LS_AS_MAPPING',
        where: stateCode != null
            ? "STATE_CODE = ?"
            : "DS_CODE = ? AND STATE_CODE = ?",
        whereArgs: stateCode != null
            ? [stateCode]
            : [districts?.districtCode, districts?.stateCode]);
    List<Assembly> assemblyList = List.generate(_assemblyList.length,
        (index) => Assembly.fromVotersList(_assemblyList[index]));
    return assemblyList;
  }

  Future<List<Assembly>> getAssemblyForBoothJodho(String stateCode) async {
    //
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _assemblyList = await _dataObject!.query(
        'TBL_LS_AS_MAPPING',
        where: "STATE_CODE = ?",
        whereArgs: [stateCode]);
    List<Assembly> assemblyList = List.generate(_assemblyList.length,
        (index) => Assembly.fromVotersList(_assemblyList[index]));
    final ids = assemblyList.map((e) => e.districtCode).toSet();
    assemblyList.retainWhere((x) => ids.remove(x.districtCode));

    return assemblyList;
  }

  Future<List<DropdownItem>> getLocalNamedAssembly(
      {String? stateCode, String? loksabhaCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _assemblyParliamentList =
        await _dataObject!.query('TBL_LS_AS_MAPPING',
            where: "STATE_CODE = ? AND LS_CODE = ?",
            whereArgs: [stateCode, loksabhaCode],
            columns: ["AS_CODE", "AS_NAME", "REGIONAL_AS_NAME"],
            orderBy: 'AS_NAME ASC');
    print(_assemblyParliamentList);

    List<DropdownItem> _assemblyListDropdown = List.generate(
        _assemblyParliamentList.length,
        (index) => DropdownItem(
            "${_assemblyParliamentList[index]["AS_NAME"]} ${_assemblyParliamentList[index]["REGIONAL_AS_NAME"] != null ? "(${_assemblyParliamentList[index]["REGIONAL_AS_NAME"]})" : ""}",
            _assemblyParliamentList[index]["AS_CODE"].toString(),
            localLangName: _assemblyParliamentList[index]["REGIONAL_AS_NAME"],
            englishLangName: _assemblyParliamentList[index]["AS_NAME"]));
    return _assemblyListDropdown;
  }

  Future<List<DropdownItem>> getLocalNamedAssemblyForVoteList(
      {String? stateCode, String? loksabhaCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _assemblyParliamentList =
        await _dataObject!.query('TBL_LS_AS_MAPPING',
            where: "STATE_CODE = ? AND DS_CODE = ?",
            whereArgs: [stateCode, loksabhaCode],
            columns: ["AS_CODE", "AS_NAME", "REGIONAL_AS_NAME"],
            orderBy: 'AS_NAME ASC');
    print(_assemblyParliamentList);
    List<DropdownItem> _assemblyListDropdown = List.generate(
        _assemblyParliamentList.length,
        (index) => DropdownItem(
            "${_assemblyParliamentList[index]["AS_NAME"]} ${_assemblyParliamentList[index]["REGIONAL_AS_NAME"] != null ? "(${_assemblyParliamentList[index]["REGIONAL_AS_NAME"]})" : ""}",
            _assemblyParliamentList[index]["AS_CODE"].toString(),
            localLangName: _assemblyParliamentList[index]["REGIONAL_AS_NAME"],
            englishLangName: _assemblyParliamentList[index]["AS_NAME"]));

    final ids = _assemblyListDropdown.map((e) => e.value).toSet();
    _assemblyListDropdown.retainWhere((x) => ids.remove(x.value));
    return _assemblyListDropdown;
  }

  Future<List<DropdownItem>> getLocalNamedParliaments({
    String? stateCode,
  }) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _localNamedParliamentList =
        await _dataObject!.query('TBL_LS_AS_MAPPING',
            where: stateCode != null ? "STATE_CODE = ?" : null,
            whereArgs: stateCode != null ? [stateCode] : null,
            distinct: true,
            columns: ["LS_CODE", "LS_NAME", "REGIONAL_LS_NAME"],
            orderBy: 'LS_NAME ASC');

    List<DropdownItem> districtsList = List.generate(
        _localNamedParliamentList.length,
        (index) => DropdownItem(
            "${_localNamedParliamentList[index]["LS_NAME"]} ${_localNamedParliamentList[index]["REGIONAL_LS_NAME"] != null ? "(${_localNamedParliamentList[index]["REGIONAL_LS_NAME"]})" : ""}",
            _localNamedParliamentList[index]["LS_CODE"].toString(),
            localLangName: _localNamedParliamentList[index]["REGIONAL_LS_NAME"],
            englishLangName: _localNamedParliamentList[index]["LS_NAME"]));
    return districtsList;
  }

  Future<List<DropdownItem>> getLocalNamedParliamentsForVoteList({
    String? stateCode,
  }) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _localNamedParliamentList =
        await _dataObject!.query('TBL_LS_AS_MAPPING',
            where: stateCode != null ? "STATE_CODE = ?" : null,
            whereArgs: stateCode != null ? [stateCode] : null,
            distinct: true,
            columns: ["DS_CODE", "DS_NAME", "REGIONAL_LS_NAME"],
            orderBy: 'DS_NAME ASC');

    List<DropdownItem> districtsList = List.generate(
        _localNamedParliamentList.length,
        (index) => DropdownItem(
            "${_localNamedParliamentList[index]["DS_NAME"]} ${_localNamedParliamentList[index]["REGIONAL_LS_NAME"] != null ? "(${_localNamedParliamentList[index]["REGIONAL_LS_NAME"]})" : ""}",
            _localNamedParliamentList[index]["DS_CODE"].toString(),
            localLangName: _localNamedParliamentList[index]["REGIONAL_LS_NAME"],
            englishLangName: _localNamedParliamentList[index]["DS_NAME"]));
    return districtsList;
  }

  Future<List<DropdownItem>> getAssemblyDropdown({
    String? stateCode,
    String? districtCode,
  }) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _assemblyList = await _dataObject!.query(
        'TBL_IYC_ASSEMBLY',
        where: "DISTRICT_CODE = ? AND MASTER_STATE_CODE = ?",
        whereArgs: [districtCode, stateCode]);
    List<DropdownItem> assemblyList = List.generate(
        _assemblyList.length,
        (index) => DropdownItem(_assemblyList[index]["ASSEMBLY_NAME"],
            _assemblyList[index]["ASSEMBLY_CODE"]));
    return assemblyList;
  }

  Future<List<Blocks>> getBlocks(Districts districts,
      {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _blocksList = await _dataObject!.query(
        'TBL_BLOCK_IYC',
        where: stateCode != null
            ? "MASTER_STATE_CODE = ?"
            : "DISTRICT_CODE = ? AND MASTER_STATE_CODE = ?",
        whereArgs: stateCode != null
            ? [stateCode]
            : [districts.districtCode, districts.stateCode]);
    List<Blocks> blocksList = List.generate(
        _blocksList.length,
        (index) => Blocks(
            id: _blocksList[index]["ID"],
            stateCode: _blocksList[index]["MASTER_STATE_CODE"],
            districtCode: _blocksList[index]["DISTRICT_CODE"].toString(),
            assemblyCode: _blocksList[index]["ASSEMBLY_CODE"].toString(),
            blockCode: _blocksList[index]["BLOCK_CODE"].toString(),
            blockName: _blocksList[index]["BLOCK_NAME"]));
    return blocksList;
  }

  Future<List<Booth>> getBooths(Blocks block, {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _boothList = await _dataObject!.query(
        'TBL_BOOTH_IYC',
        where: stateCode != null
            ? "MASTER_STATE_CODE = ?"
            : "BLOCK_CODE = ? AND MASTER_STATE_CODE = ?",
        whereArgs: stateCode != null
            ? [stateCode]
            : [block.blockCode, block.stateCode]);
    List<Booth> boothList = List.generate(
        _boothList.length,
        (index) => Booth(
            id: _boothList[index]["ID"],
            stateCode: _boothList[index]["MASTER_STATE_CODE"],
            districtCode: _boothList[index]["DISTRICT_CODE"].toString(),
            assemblyCode: _boothList[index]["ASSEMBLY_CODE"].toString(),
            blockCode: _boothList[index]["BLOCK_CODE"].toString(),
            boothCode: _boothList[index]["BOOTH_CODE"].toString(),
            boothName: _boothList[index]["BOOTH_NAME"]));
    return boothList;
  }

  Future<List<Mandalam>> getMandalams(Assembly assembly,
      {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _mandalamList = await _dataObject!.query(
        'TBL_MANDALAM_IYC',
        where: stateCode != null
            ? "MASTER_STATE_CODE = ?"
            : "ASSEMBLY_CODE = ? AND MASTER_STATE_CODE = ?",
        whereArgs: stateCode != null
            ? [stateCode]
            : [assembly.assemblyCode, assembly.stateCode]);
    print(_mandalamList);
    List<Mandalam> mandalamList = List.generate(
        _mandalamList.length,
        (index) => Mandalam(
            id: _mandalamList[index]["ID"],
            stateCode: _mandalamList[index]["MASTER_STATE_CODE"],
            districtCode: _mandalamList[index]["DISTRICT_CODE"].toString(),
            assemblyCode: _mandalamList[index]["ASSEMBLY_CODE"].toString(),
            mandalamCode: _mandalamList[index]["MANDALAM_CODE"].toString(),
            mandalamName: _mandalamList[index]["MANDALAM_NAME"]));
    return mandalamList;
  }

  Future<List<Category>> getAllCategory() async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _category =
        await _dataObject!.query('TBL_MASTER_CATEGORY', columns: []);

    List<Category> categoryList = [];
    _category.forEach((map) {
      categoryList.add(Category.fromMap(map));
    });
    return categoryList;
  }

  Future<List<Nomination>> searchForStateNominations(
      {required String stateCode, required String contestingFor}) async {
    //
    final _dataObject = await database;
    List<Nomination> stateNominationsList = [];
    try {
      final List<Map<String, dynamic>> _stateNominations =
          await _dataObject!.query(
        'TBL_NOMINATION_CSN',
        where: "STATE_CODE = ? AND CONTESTING_FOR = ? ",
        whereArgs: [stateCode, contestingFor],
        orderBy: "CSN",
      );
      _stateNominations.forEach((map) {
        stateNominationsList.add(Nomination.fromMap(map));
      });
    } catch (e) {}
    return stateNominationsList;
  }

  Future<List<Nomination>> searchForDistrictNominations(
      {required String stateCode,
      required String districtCode,
      required String contestingFor}) async {
    //
    final _dataObject = await database;
    List<Nomination> stateNominationsList = [];
    try {
      final List<Map<String, dynamic>> _stateNominations =
          await _dataObject!.query(
        'TBL_NOMINATION_CSN',
        where: "STATE_CODE = ? AND DISTRICT_CODE =? AND CONTESTING_FOR = ? ",
        whereArgs: [stateCode, districtCode, contestingFor],
        orderBy: "CSN",
      );
      _stateNominations.forEach((map) {
        stateNominationsList.add(Nomination.fromMap(map));
      });
    } catch (e) {}
    return stateNominationsList;
  }

  Future<List<Nomination>> searchForAssemblyNominations(
      {required String stateCode,
      required String districtCode,
      required String assemblyCode,
      required String contestingFor}) async {
    //
    final _dataObject = await database;
    List<Nomination> stateNominationsList = [];
    try {
      final List<Map<String, dynamic>> _stateNominations =
          await _dataObject!.query(
        'TBL_NOMINATION_CSN',
        where:
            "STATE_CODE = ? AND DISTRICT_CODE =?AND ASSEMBLY_CODE=?AND CONTESTING_FOR = ? ",
        whereArgs: [stateCode, districtCode, assemblyCode, contestingFor],
        orderBy: "CSN",
      );

      _stateNominations.forEach((map) {
        stateNominationsList.add(Nomination.fromMap(map));
      });
    } catch (e) {
      if (debug.kDebugMode) print(e);
    }
    return stateNominationsList;
  }

  Future<List<Nomination>> searchForBlockNominations(
      {required String stateCode,
      required String districtCode,
      required String blockCode,
      required String contestingFor}) async {
    //
    final _dataObject = await database;
    List<Nomination> stateNominationsList = [];
    try {
      final List<Map<String, dynamic>> _stateNominations =
          await _dataObject!.query(
        'TBL_NOMINATION_CSN',
        where:
            "STATE_CODE = ? AND DISTRICT_CODE =?AND BLOCK_CODE=?AND CONTESTING_FOR = ? ",
        whereArgs: [stateCode, districtCode, blockCode, contestingFor],
        orderBy: "CSN",
      );

      _stateNominations.forEach((map) {
        stateNominationsList.add(Nomination.fromMap(map));
      });
    } catch (e) {}
    return stateNominationsList;
  }

  Future<List<Nomination>> searchForMandalamNominations(
      {required String stateCode,
      required String districtCode,
      required String blockCode,
      required String contestingFor}) async {
    //
    Log.printILog('$stateCode $districtCode $blockCode $contestingFor');
    final _dataObject = await database;
    List<Nomination> stateNominationsList = [];
    try {
      final List<Map<String, dynamic>> _stateNominations =
          await _dataObject!.query(
        'TBL_NOMINATION_CSN',
        where:
            "STATE_CODE = ? AND DISTRICT_CODE =?AND BLOCK_CODE=?AND CONTESTING_FOR = ? ",
        whereArgs: [stateCode, districtCode, blockCode, contestingFor],
        orderBy: "CSN",
      );
      Log.printILog(_stateNominations.length);
      _stateNominations.forEach((map) {
        stateNominationsList.add(Nomination.fromMap(map));
      });
    } catch (e) {}
    return stateNominationsList;
  }

  Future<List<Nomination>> searchForBoothNominations(
      {required String stateCode,
      required String districtCode,
      required String blockCode,
      required String boothCode,
      required String contestingFor}) async {
    //
    final _dataObject = await database;
    List<Nomination> stateNominationsList = [];
    try {
      final List<Map<String, dynamic>> _stateNominations =
          await _dataObject!.query(
        'TBL_NOMINATION_CSN',
        where:
            "STATE_CODE = ? AND DISTRICT_CODE =?AND BLOCK_CODE=?AND BOOTH_CODE=?AND CONTESTING_FOR = ? ",
        whereArgs: [
          stateCode,
          districtCode,
          blockCode,
          boothCode,
          contestingFor
        ],
        orderBy: "CSN",
      );

      _stateNominations.forEach((map) {
        stateNominationsList.add(Nomination.fromMap(map));
      });
    } catch (e) {}
    return stateNominationsList;
  }

  getVotersList(String searchKey,
      [String? parliamentName, String? assembly]) async {
    final _dataObject = await database;

    // print("tabless");
    // (await _dataObject!.query('sqlite_master', columns: ['type', 'name']))
    //     .forEach((row) {
    //   print(row.values);
    // });
    // final tables = await _dataObject!
    //     .rawQuery('SELECT * FROM sqlite_master ORDER BY name;');
    // print(tables);
    final result = await _dataObject!.query("TBL_VOTER_LIST_DL",
        where:
            "name LIKE ? OR voter_id LIKE ? ${(parliamentName != null) ? "AND parliament ?" : ""} ${assembly != null ? "AND assembly ?" : ""}",
        whereArgs: [
          searchKey + '%',
          searchKey + '%',
          if (parliamentName != null) parliamentName,
          if (assembly != null) assembly
        ]);
    return result;
  }

  getAllVotersList() async {
    final _dataObject = await database;
    final result = await _dataObject!.query("TBL_VOTER_LIST_DL");
    return result;
  }

  Future<List<Districts>> getAllDistrict(String stateCode) async {
    //
    final _dataObject = await database;

    // Perform the query, sorting by DS_NAME directly in the SQL query
    final List<Map<String, dynamic>> _stateList = await _dataObject!.rawQuery(
      'SELECT DISTINCT DS_NAME, DS_CODE, STATE_CODE FROM TBL_LS_AS_MAPPING WHERE STATE_CODE = ? ORDER BY DS_NAME ASC',
      [stateCode],
    );

    // Convert the list of maps into a list of Districts objects
    List<Districts> districtList = List.generate(_stateList.length, (index) {
      return Districts(
        id: 0, // ID is set to 0 as it’s not retrieved in the query
        name: _stateList[index]["DS_NAME"],
        stateCode: _stateList[index]["STATE_CODE"],
        districtCode: _stateList[index]["DS_CODE"].toString(),
        isEnabled: 'true',
      );
    });

    return districtList;
  }

  Future<List<Districts>> getDistrict(States? states,
      {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _districtList = await _dataObject!.query(
        'TBL_LS_AS_MAPPING',
        columns: ['DS_NAME, DS_CODE, STATE_CODE', 'ID'],
        where: "STATE_CODE = ?",
        distinct: true,
        whereArgs: [stateCode ?? states?.stateCode]);
    List<Districts> districtsList = List.generate(
        _districtList.length,
        (index) => Districts(
            id: _districtList[index]["ID"],
            name: _districtList[index]["DS_NAME"],
            stateCode: _districtList[index]["STATE_CODE"],
            isEnabled: 'true',
            districtCode: _districtList[index]["DS_CODE"].toString()));
    final ids = districtsList.map((e) => e.districtCode).toSet();
    districtsList.retainWhere((x) => ids.remove(x.districtCode));
    return districtsList;
  }

  Future<List<Districts>> getDistrictNew(States? states,
      {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _districtList = await _dataObject!.query(
        'TBL_LS_AS_MAPPING',
        columns: ['LS_NAME, LS_CODE, STATE_CODE', 'ID'],
        where: "STATE_CODE = ?",
        distinct: true,
        whereArgs: [stateCode ?? states?.stateCode]);
    List<Districts> districtsList = List.generate(
        _districtList.length,
        (index) => Districts(
            id: _districtList[index]["ID"],
            name: _districtList[index]["LS_NAME"],
            stateCode: _districtList[index]["STATE_CODE"],
            isEnabled: 'true',
            districtCode: _districtList[index]["LS_CODE"].toString()));
    final ids = districtsList.map((e) => e.districtCode).toSet();
    districtsList.retainWhere((x) => ids.remove(x.districtCode));

    return districtsList;
  }

  Future<List<Assembly>> getAllAssembly(Districts? districts,
      {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _assemblyList = await _dataObject!.query(
      'TBL_LS_AS_MAPPING',
      columns: ['ID', 'AS_NAME', 'STATE_CODE', 'DS_CODE', 'AS_CODE'],
      where: "DS_CODE = ? AND STATE_CODE = ?",
      whereArgs: [districts?.districtCode, districts?.stateCode],
    );

    // Use a Map to enforce uniqueness based on a composite key
    Map<String, Map<String, dynamic>> uniqueAssemblyMap = {};
    for (var item in _assemblyList) {
      String compositeKey =
          '${item['AS_NAME']}-${item['AS_CODE']}-${item['STATE_CODE']}-${item['DS_CODE']}';
      uniqueAssemblyMap[compositeKey] = item;
    }

    // Convert the Map values to a List
    List<Map<String, dynamic>> uniqueAssemblyList =
        uniqueAssemblyMap.values.toList();

    // Sort the unique assembly list based on a field, e.g., 'AS_NAME'
    uniqueAssemblyList.sort((a, b) => a['AS_NAME'].compareTo(b['AS_NAME']));

    List<Assembly> assemblyList = List.generate(
      uniqueAssemblyList.length,
      (index) => Assembly(
        id: uniqueAssemblyList[index]["ID"],
        name: uniqueAssemblyList[index]["AS_NAME"],
        stateCode: uniqueAssemblyList[index]["STATE_CODE"],
        isEnabled: 'true',
        districtCode: uniqueAssemblyList[index]["DS_CODE"].toString(),
        assemblyCode: uniqueAssemblyList[index]["AS_CODE"].toString(),
      ),
    );

    final ids = assemblyList.map((e) => e.assemblyCode).toSet();
    assemblyList.retainWhere((x) => ids.remove(x.assemblyCode));

    return assemblyList;
  }

  Future<List<Assembly>> getAllAssemblyByState(String? stateCode) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _assemblyList = await _dataObject!.query(
      'TBL_LS_AS_MAPPING',
      columns: ['ID', 'AS_NAME', 'STATE_CODE', 'DS_CODE', 'AS_CODE'],
      where: "STATE_CODE = ?",
      whereArgs: [stateCode],
    );

    // Use a Map to enforce uniqueness based on a composite key
    Map<String, Map<String, dynamic>> uniqueAssemblyMap = {};
    for (var item in _assemblyList) {
      String compositeKey =
          '${item['AS_NAME']}-${item['AS_CODE']}-${item['STATE_CODE']}-${item['DS_CODE']}';
      uniqueAssemblyMap[compositeKey] = item;
    }

    // Convert the Map values to a List
    List<Map<String, dynamic>> uniqueAssemblyList =
        uniqueAssemblyMap.values.toList();

    // Sort the unique assembly list based on a field, e.g., 'AS_NAME'
    uniqueAssemblyList.sort((a, b) => a['AS_NAME'].compareTo(b['AS_NAME']));

    List<Assembly> assemblyList = List.generate(
      uniqueAssemblyList.length,
      (index) => Assembly(
        id: uniqueAssemblyList[index]["ID"],
        name: uniqueAssemblyList[index]["AS_NAME"],
        stateCode: uniqueAssemblyList[index]["STATE_CODE"],
        isEnabled: 'true',
        districtCode: uniqueAssemblyList[index]["DS_CODE"].toString(),
        assemblyCode: uniqueAssemblyList[index]["AS_CODE"].toString(),
      ),
    );

    return assemblyList;
  }

  Future<List<Mandalam>> getAllMandalams(Assembly assembly,
      {String? stateCode}) async {
    //
    final _dataObject = await database;
    final List<Map<String, dynamic>> _mandalamList = await _dataObject!.query(
        'TBL_LS_AS_MAPPING',
        where: "AS_CODE = ? AND STATE_CODE = ?",
        whereArgs: [assembly.assemblyCode, assembly.stateCode]);
    print(_mandalamList);
    List<Mandalam> mandalamList = List.generate(
        _mandalamList.length,
        (index) => Mandalam(
            id: _mandalamList[index]["ID"],
            stateCode: _mandalamList[index]["STATE_CODE"],
            districtCode: _mandalamList[index]["DS_CODE"].toString(),
            assemblyCode: _mandalamList[index]["AS_CODE"].toString(),
            mandalamCode: _mandalamList[index]["MANDALAM_CODE"].toString(),
            mandalamName: _mandalamList[index]["MANDALAM_NAME"] ?? ''));
    return mandalamList;
  }
}
//CREATE INDEX "VOTER_LIST" ON "TBL_VOTER_LIST_DL" (
// 	"voter_id"	ASC,
// 	"name"	ASC,
// 	"parliament"	ASC,
// 	"assembly"	ASC,
// 	"part_no"	ASC,
// 	"father_husband_name"	ASC
// )
