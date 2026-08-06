import 'dart:convert';

/// A push notification persisted locally so users can see their notification
/// history even after the OS notification is dismissed.
class AppNotification {
  final String id;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final String type;
  final int receivedAt; // epoch millis
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.data,
    required this.type,
    required this.receivedAt,
    required this.isRead,
  });

  factory AppNotification.fromMap(Map<String, dynamic> m) {
    Map<String, dynamic> parsedData = {};
    try {
      final raw = m['data'];
      if (raw is String && raw.isNotEmpty) {
        parsedData = Map<String, dynamic>.from(jsonDecode(raw));
      }
    } catch (_) {}
    return AppNotification(
      id: (m['id'] ?? '').toString(),
      title: (m['title'] ?? '').toString(),
      body: (m['body'] ?? '').toString(),
      data: parsedData,
      type: (m['type'] ?? '').toString(),
      receivedAt: m['received_at'] is int
          ? m['received_at'] as int
          : int.tryParse('${m['received_at']}') ?? 0,
      isRead: (m['is_read'] is int
              ? m['is_read'] as int
              : int.tryParse('${m['is_read']}') ?? 0) ==
          1,
    );
  }

  DateTime get receivedDateTime =>
      DateTime.fromMillisecondsSinceEpoch(receivedAt);
}
