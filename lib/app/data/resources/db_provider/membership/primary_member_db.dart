import 'package:iyc/model/data_model/primary_member.dart';
import 'package:sqflite/sqflite.dart';

class PrimaryMemberDB {
  final Database database;

  PrimaryMemberDB(this.database);

  Future<bool> insertData(PrimaryMember data) async {
    await database.insert(
      "primary_members",
      data.toJson(data),
    );
    print(data.toJson(data));
    return true;
  }

  Future<bool> updateData(PrimaryMember data) async {
    await database.update(
      "primary_members",
      data.toJson(data),
      where: "MEMBER_ID = ?",
      whereArgs: [data.memberId],
    );
    print(data.toJson(data));
    return true;
  }

  Future<List<PrimaryMember>> getData(String refrererId) async {
    final List<Map<String, Object?>> queryResult = await database.query(
        'primary_members',
        where: "REFERRER_ID=?",
        whereArgs: [refrererId]);
    // print();
    return queryResult.map((e) => PrimaryMember.fromJson(e)).toList();

    /// convert to list
    // list.forEach((map) {
    //   membershipRequestList.add(MembershipRequestModel.fromMap(map));
    // });
    // return membershipRequestList;
  }

  Future<List<PrimaryMember>> getDataByBatchId(String batchId) async {
    final List<Map<String, Object?>> queryResult = await database.query(
        'primary_members',
        where: "BATCH_NO=?",
        whereArgs: [batchId]
    );
    return queryResult.map((e) => PrimaryMember.fromJson(e)).toList();

    /// convert to list
    // list.forEach((map) {
    //   membershipRequestList.add(MembershipRequestModel.fromMap(map));
    // });
    // return membershipRequestList;
  }
}
