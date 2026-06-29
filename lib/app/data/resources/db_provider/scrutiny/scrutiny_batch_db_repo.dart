import 'dart:async';

import 'package:iyc/model/api_model/batch/batch_data_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ScrutinyBatchDBRepo {
  Database database;
  late int count;

  ScrutinyBatchDBRepo(this.database);

  Future<bool> insertData(BatchDataModel data) async {
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT OR REPLACE INTO scrutiny_batches(BATCH_NO,TOTAL_AM,PAYMENT_STATUS,'
          'STATE_CODE,DISTRICT_CODE,SYNC_STATUS,ONHOLD)'
          'VALUES("${data.batchId}","${data.countAM}","${data.paymentStatus}","${data.stateCode}","${data.districtCode}","${data.syncStatus}","${data.onhold}")');
      print('inserted1: $id1');
    });
    return true;
  }

  // WHERE NOT EXISTS (Select BATCH_NO From scrutiny_batches WHERE BATCH_NO ="${data.batchId}")

  Future<bool> updateAMCount(BatchDataModel data) async {
    count = await database.rawUpdate(
        'UPDATE scrutiny_batches SET TOTAL_AM=?'
        ' WHERE BATCH_NO =?',
        [data.countAM, data.batchId]);
    print(count);
    return true;
  }

  Future<int> countData() async {
    count = Sqflite.firstIntValue(
        await database.rawQuery('SELECT COUNT(*) FROM scrutiny_batches'))!;
    return count;
  }

  Future<bool> deleteData(String id) async {
    count = await database
        .rawDelete('DELETE FROM scrutiny_batches WHERE BATCH_NO = ?', [id]);
    print(id);
    return true;
  }

  Future<bool> deleteTable() async {
    await database.rawQuery('DROP TABLE IF EXISTS scrutiny_batches');
    return true;
  }

  Future<bool> deleteAllData() async {
    count = await database.rawDelete('DELETE FROM scrutiny_batches ');
    return true;
  }

  Future<List<BatchDataModel>> getData() async {
    List<BatchDataModel> batchList = [];
    List<Map> list = await database.rawQuery('SELECT * FROM scrutiny_batches');
    print(list);

    /// convert to list
    list.forEach((map) {
      batchList.add(BatchDataModel.fromMap(map));
    });
    return batchList;
  }

  Future<List<BatchDataModel>> getRowData(String id) async {
    List<BatchDataModel> batchList = [];
    List<Map> list = await database
        .rawQuery('SELECT * FROM scrutiny_batches WHERE BATCH_NO= ?', [id]);
    print(list);

    /// convert to list
    list.forEach((map) {
      batchList.add(BatchDataModel.fromMap(map));
    });
    return batchList;
  }
}
