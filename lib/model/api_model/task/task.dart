import 'dart:convert';

class Task {
  Task(
      {required this.taskId,
      required this.userId,
      required this.taskStatus,
      required this.taskType,
      required this.taskText,
      required this.taskUrl,
      required this.taskPoint,
      required this.taskStartDate,
      required this.taskEndDate,
      this.taskPriority,
        this.taskCategory,
      this.isExpired = false});

  final String taskId;
  final String userId;
  final String taskStatus;
  final String taskType;
  final String taskText;
  final String taskUrl;
  final String taskPoint;
  final DateTime taskStartDate;
  final DateTime taskEndDate;
  final bool isExpired;
  final String? taskPriority;
  final String? taskCategory;

  Task copyWith({
    String? taskId,
    String? userId,
    String? taskStatus,
    String? taskType,
    String? taskText,
    String? taskUrl,
    String? taskPoint,
    DateTime? taskStartDate,
    DateTime? taskEndDate,
  }) =>
      Task(
        taskId: taskId ?? this.taskId,
        userId: userId ?? this.userId,
        taskStatus: taskStatus ?? this.taskStatus,
        taskType: taskType ?? this.taskType,
        taskText: taskText ?? this.taskText,
        taskUrl: taskUrl ?? this.taskUrl,
        taskPoint: taskPoint ?? this.taskPoint,
        taskStartDate: taskStartDate ?? this.taskStartDate,
        taskEndDate: taskEndDate ?? this.taskEndDate,
      );

  factory Task.fromRawJson(String str) => Task.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Task.fromJson(Map<String, dynamic> json) => Task(
      taskId: json["TASK_ID"],
      userId: json["USER_ID"],
      taskStatus: json["TASK_STATUS"],
      taskType: json["TASK_TYPE"],
      taskText: json["TASK_TEXT"],
      taskUrl: json["TASK_URL"],
      taskPoint: json["TASK_POINT"],
      taskStartDate: DateTime.parse(json["TASK_START_DATE"]),
      taskEndDate: DateTime.parse(json["TASK_END_DATE"]),
      taskPriority: json["TASK_PRIORITY"],
      taskCategory: json["TASK_CATEGORY"],
      isExpired:
          DateTime.parse(json["TASK_END_DATE"]).isBefore(DateTime.now().subtract(Duration(days: 1)))
  );

  Map<String, dynamic> toJson() => {
        "TASK_ID": taskId,
        "USER_ID": userId,
        "TASK_STATUS": taskStatus,
        "TASK_TYPE": taskType,
        "TASK_TEXT": taskText,
        "TASK_URL": taskUrl,
        "TASK_POINT": taskPoint,
        "TASK_START_DATE":
            "${taskStartDate.year.toString().padLeft(4, '0')}-${taskStartDate.month.toString().padLeft(2, '0')}-${taskStartDate.day.toString().padLeft(2, '0')}",
        "TASK_END_DATE":
            "${taskEndDate.year.toString().padLeft(4, '0')}-${taskEndDate.month.toString().padLeft(2, '0')}-${taskEndDate.day.toString().padLeft(2, '0')}",
      };
}
