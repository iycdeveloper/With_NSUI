import 'dart:async';
import 'dart:developer';

import 'package:iyc/model/data_model/batch_member.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ScrutinyMembershipDBRepo {
  final Database database;
  late int count;

  ScrutinyMembershipDBRepo(this.database);

  Future<bool> insertData(BatchMember data) async {
    await database.transaction((txn) async {
      data.toMap();
      int id1 = await txn.insert(
        "scrutiny_batch_members",
        data.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('inserted1: $id1');
    });
    return true;
  }

  Future<bool> updateMembershipTable(BatchMember data) async {
    count = await database.update(
      "scrutiny_batch_members", data.toMap(),
      where: "MEMBER_ID = ?",
      whereArgs: [data.memberId],
      // conflictAlgorithm: ConflictAlgorithm.replace
    );
    print(count);
    return true;
  }

  Future<int> countData(String batchId) async {
    count = Sqflite.firstIntValue(await database.rawQuery(
        'SELECT COUNT(*) FROM scrutiny_batch_members WHERE BATCH_NO = ?',
        [batchId]))!;

    return count;
  }

  Future<bool> deleteData(String id) async {
    count = await database
        .rawDelete('DELETE FROM membershipTable WHERE membership_id = ?', [id]);
    print(id);
    return true;
  }

  Future<bool> deleteAllData() async {
    count = await database.rawDelete('DELETE FROM membershipTable ');
    return true;
  }

  Future<List<BatchMember>> getData(String batchId) async {
    // List<BatchMember> membershipRequestList = [];
    // List<Map> list = await database.rawQuery(
    //     'SELECT * FROM Members WHERE BATCH_NO = ?', [batchId]);
    // print(list);

    final List<Map<String, Object?>> queryResult = await database.query(
      'scrutiny_batch_members',
      where: "BATCH_NO = ?",
      whereArgs: [batchId],
    );
    print("--memberdata");
    log(queryResult.toString());
    return queryResult.map((e) => BatchMember.fromJson(e)).toList();

    // /// convert to list
    // list.forEach((map) {
    //   membershipRequestList.add(BatchMember.fromMap(map));
    // });
    // return membershipRequestList;
  }

  Future<List> getBatchData(String batchId) async {
    List<Map> list = await database.rawQuery(
        'SELECT * FROM scrutiny_batch_members WHERE BATCH_NO = ?', [batchId]);
    print(list);

    return list;
  }

  Future<List<BatchMember>> getRowData(String id) async {
    List<BatchMember> membershipRequestList = [];
    // MembershipRequestModel dataModel;
    List<Map> list = await database.rawQuery(
        'SELECT * FROM scrutiny_batch_members WHERE MEMBER_ID = ?', [id]);
    print(list);

    /// convert to list
    list.forEach((map) {
      // dataModel=MembershipRequestModel.fromMap(map);
      membershipRequestList.add(BatchMember.fromMap(map));
      membershipRequestList.forEach((element) {
        print(element.firstName);
      });
    });
    print(membershipRequestList.length);
    return membershipRequestList;
  }

  Future<List<BatchMember>> getAllScrutinyMembers() async {
    List<BatchMember> membershipRequestList = [];
    // MembershipRequestModel dataModel;
    List<Map> list =
        await database.rawQuery('SELECT * FROM scrutiny_batch_members');
    print(list);

    /// convert to list
    list.forEach((map) {
      // dataModel=MembershipRequestModel.fromMap(map);
      membershipRequestList.add(BatchMember.fromMap(map));
      membershipRequestList.forEach((element) {
        print(element.firstName);
      });
    });
    print(membershipRequestList.length);
    return membershipRequestList;
  }

  Future<bool> deleteTable() async {
    await database.rawQuery('DROP TABLE IF EXISTS scrutiny_batch_members');
    return true;
  }
}
