import 'dart:async';
import 'dart:developer';

import 'package:iyc/model/data_model/batch_member.dart';
import 'package:sqflite/sqflite.dart';

import 'batch_db_repo.dart';

class MembershipMemberDB {
  final Database database;
  late int count;

  MembershipMemberDB(this.database);

  Future<bool> insertData(BatchMember data) async {
    await database.insert(
      "membership_batch_members",
      data.toMap2(),
    );
    print(data.toMap2());

    return true;
  }

  Future<bool> updateMembershipTable(BatchMember data) async {
    count = await database.update(
      "membership_batch_members", data.toMap2(),
      where: "MEMBER_ID = ?",
      whereArgs: [data.memberId],
      // conflictAlgorithm: ConflictAlgorithm.replace
    );
    // print(data.toJson());
    return true;
  }

  Future<bool> updateNominationData(BatchMember data) async {
    count = await database.rawUpdate(
        'UPDATE membershipTable SET CSN_SP=?,CSN_SG=?,CSN_DP=?,'
        'CSN_AP=?'
        ' WHERE membership_id =?',
        [
          data.statePresidentCandidate,
          data.stateGSCandidate,
          data.districtCandidate,
          data.assemblyCandidate,
          data.memberId
        ]);
    print(count);
    return true;
  }

  Future<int> countData(String batchId) async {
    count = Sqflite.firstIntValue(await database.rawQuery(
        'SELECT COUNT(*) FROM membership WHERE BATCH_NO = ?', [batchId]))!;

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
    List<BatchMember> membershipRequestList = [];
    // List<Map> list = await database.rawQuery(
    //     'SELECT * FROM membershipTable WHERE BATCH_NO = ?', [batchId]);
    // print(list);

    final List<Map<String, Object?>> queryResult = await database.query(
        'membership_batch_members',
        where: "BATCH_NO=?",
        whereArgs: [batchId]);
    log(queryResult.toString());

    return queryResult.map((e) => BatchMember.fromJson(e)).toList();

    /// convert to list
    // list.forEach((map) {
    //   membershipRequestList.add(MembershipRequestModel.fromMap(map));
    // });
    // return membershipRequestList;
  }

  Future<List> getBatchData(String batchId) async {
    List<Map> list = await database.rawQuery(
        'SELECT * FROM membership_batch_members WHERE BATCH_NO = ?', [batchId]);
    print(list);
    await BatchDBRepo(database).countData();

    return list;
  }

  Future<List<BatchMember>> getRowData(String id) async {
    List<BatchMember> membershipRequestList = [];
    // MembershipRequestModel dataModel;
    List<Map> list = await database.rawQuery(
        'SELECT * FROM membership_batch_members WHERE MEMBER_ID = ?', [id]);
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
    await database.rawQuery('DROP TABLE IF EXISTS membership_batch_members');
    return true;
  }
}
