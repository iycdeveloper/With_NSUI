import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:sqflite/sqflite.dart';

class BatchDBRepo {
  final Database database;
  late int count;

  BatchDBRepo(this.database);

  Future<bool> insertData(BatchDataModel data) async {
    await database.insert("membership_batches", data.toJson());
    return true;
  }

  Future<bool> updateData(BatchDataModel data) async {
    await database.update("membership_batches", data.toJson(),
        where: "BATCH_NO=?", whereArgs: [data.batchId]);
    if (kDebugMode) {
      print('updated with: ${data.toJson()}');
    }
    return true;
  }

  // WHERE NOT EXISTS (Select BATCH_NO From membership_batches WHERE BATCH_NO ="${data.batchId}")

  Future<bool> updateAMCount(BatchDataModel data) async {
    count = await database.rawUpdate(
        'UPDATE membership_batches SET TOTAL_AM=?'
        ' WHERE BATCH_NO =?',
        [data.countAM, data.batchId]);
    print(count);
    return true;
  }

  Future<int> countData() async {
    count = Sqflite.firstIntValue(await database
        .rawQuery('SELECT COUNT(*) BATCH_NO FROM membership_batches '))!;
    return count;
  }

  Future<bool> deleteData(String id) async {
    count = await database
        .rawDelete('DELETE FROM membership_batches WHERE BATCH_NO = ?', [id]);
    print(id);
    return true;
  }

  Future<bool> deleteTable() async {
    await database.rawQuery('DROP TABLE IF EXISTS membership_batches');
    return true;
  }

  Future<List<BatchDataModel>> getData() async {
    List<BatchDataModel> batchList = [];
    List<Map> list = await database.query(
      'membership_batches',
    );
    if (kDebugMode) log(list.toString());

    /// convert to list
    ///
    await Future.forEach(list,
        (element) => batchList.add(BatchDataModel.fromMap(element as Map)));
    // list.forEach((map) {
    //   batchList.add(BatchDataModel.fromMap(map));
    // });
    return batchList;
  }
}
