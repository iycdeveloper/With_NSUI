import 'dart:convert';

import 'package:iyc/di_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IycLog {
  String title;
  String status;
  String content;
  String createdOn;
  static const String _tableName = 'IYC_LOGS';

  IycLog({
    required this.title,
    required this.status,
    required this.createdOn,
    required this.content,
  });

  factory IycLog.empty() => IycLog(
        createdOn: "",
        title: "",
        status: "",
        content: "",
      );

  factory IycLog.log({
    required String title,
    required String status,
    required String content,
    required String createdOn,
  }) {
    IycLog iycLogs = IycLog(
      title: title,
      status: status,
      content: content,
      createdOn: createdOn,
    )..add();

    return IycLog.empty();
  }

  factory IycLog.fromMap(Map<String, dynamic> data) {
    return IycLog(
      title: data['TITLE'],
      status: data['STATUS'],
      content: data["CONTENT"],
      createdOn: data["CREATED_ON"],
    );
  }

  Map<String, dynamic> toMap() => {
        "TITLE": title,
        "STATUS": status,
        "CONTENT": content,
        "CREATED_ON": createdOn
      };

  Future<Null> add() async {
    final rawJson = await sl<SharedPreferences>().getString(_tableName) ?? "";
    var mapList =
        rawJson.isNotEmpty ? (json.decode(rawJson) as List<dynamic>) : [];
    mapList.add(this.toMap());
    await sl<SharedPreferences>().setString(_tableName, jsonEncode(mapList));

    // try {
    //   if (AtomLogDB.instance.logDB != null)
    //     await AtomLogDB.instance.logDB.insert(_tableName, this.toMap());
    // } catch (e, s) {
    //   errorLogs('add Error', e, s);
    // }
  }

  static deleteAllLogs() async {
    await sl<SharedPreferences>().remove(_tableName);
  }

  static getLogs() async {
    final rawJson = await sl<SharedPreferences>().getString(_tableName) ?? "";
    // print(decode(rawJson));
  }

  static String encode(List<IycLog> iycLogs) => json.encode(
        iycLogs.map<Map<String, dynamic>>((iycLog) => iycLog.toMap()).toList(),
      );

  static List<IycLog> decode(String iycLogs) =>
      (json.decode(iycLogs) as List<dynamic>)
          .map<IycLog>((item) => IycLog.fromMap(item))
          .toList();
}
