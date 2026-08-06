import 'dart:convert';

import 'package:iyc/model/data_model/app_notification.dart';
import 'package:sqflite/sqflite.dart';

/// Self-contained, **isolate-safe** local store for received push
/// notifications.
///
/// Deliberately uses NO get_it / GetX / providers so it can run inside the FCM
/// BACKGROUND ISOLATE (which never runs `main()`/`di.init()`, so the app's
/// scoped `Database` and `sl` are unavailable there). It keeps its OWN sqflite
/// file (`notifications.db`), separate from the app's `iyc.db`, and opens/closes
/// per operation to minimise cross-isolate lock contention. `iyc.db` is left
/// completely untouched.
///
/// Retention: entries older than [retentionDays] are purged on every insert and
/// on every read — no background scheduler needed.
class NotificationStore {
  NotificationStore._();

  static const String _dbName = 'notifications.db';
  static const String _table = 'notifications';
  static const int retentionDays = 21; // ~3 weeks

  static Future<String> _path() async {
    final dir = await getDatabasesPath();
    final sep = dir.endsWith('/') || dir.endsWith('\\') ? '' : '/';
    return '$dir$sep$_dbName';
  }

  static Future<Database> _open() async {
    return openDatabase(
      await _path(),
      version: 1,
      onCreate: (db, _) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $_table (
            id TEXT PRIMARY KEY,
            title TEXT,
            body TEXT,
            data TEXT,
            type TEXT,
            received_at INTEGER,
            is_read INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  /// Insert a notification and purge anything older than [retentionDays].
  /// Safe to call from the background isolate.
  static Future<void> insert({
    required String? title,
    required String? body,
    required Map<String, dynamic> data,
    String? id,
    int? receivedAtMs,
  }) async {
    // Skip totally empty payloads (nothing to show the user).
    final t = (title ?? '').trim();
    final b = (body ?? '').trim();
    if (t.isEmpty && b.isEmpty && data.isEmpty) return;

    final db = await _open();
    try {
      final now = receivedAtMs ?? DateTime.now().millisecondsSinceEpoch;
      final rowId = (id != null && id.isNotEmpty) ? id : '$now';
      await db.insert(
        _table,
        {
          'id': rowId,
          'title': t,
          'body': b,
          'data': jsonEncode(data),
          'type': (data['type'] ?? '').toString(),
          'received_at': now,
          'is_read': 0,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _purge(db, now);
    } finally {
      await db.close();
    }
  }

  static Future<void> _purge(Database db, int nowMs) async {
    final cutoff = nowMs - retentionDays * 24 * 60 * 60 * 1000;
    await db.delete(_table, where: 'received_at < ?', whereArgs: [cutoff]);
  }

  static Future<List<AppNotification>> getAll() async {
    final db = await _open();
    try {
      await _purge(db, DateTime.now().millisecondsSinceEpoch);
      final rows = await db.query(_table, orderBy: 'received_at DESC');
      return rows.map((e) => AppNotification.fromMap(e)).toList();
    } finally {
      await db.close();
    }
  }

  static Future<int> unreadCount() async {
    final db = await _open();
    try {
      final r =
          await db.rawQuery('SELECT COUNT(*) c FROM $_table WHERE is_read = 0');
      return Sqflite.firstIntValue(r) ?? 0;
    } finally {
      await db.close();
    }
  }

  static Future<void> markRead(String id) async {
    final db = await _open();
    try {
      await db.update(_table, {'is_read': 1}, where: 'id = ?', whereArgs: [id]);
    } finally {
      await db.close();
    }
  }

  static Future<void> markAllRead() async {
    final db = await _open();
    try {
      await db.update(_table, {'is_read': 1}, where: 'is_read = 0');
    } finally {
      await db.close();
    }
  }

  static Future<void> delete(String id) async {
    final db = await _open();
    try {
      await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    } finally {
      await db.close();
    }
  }

  static Future<void> clearAll() async {
    final db = await _open();
    try {
      await db.delete(_table);
    } finally {
      await db.close();
    }
  }

  /// Delete the entire store file — used on logout (clear-on-logout policy).
  static Future<void> deleteStore() async {
    try {
      await deleteDatabase(await _path());
    } catch (_) {}
  }
}
