//{"status":"SUCCESS","response":[{"id":"1","unicorn_id":"1575737405247","image_link":"https:\/\/pbs.twimg.com\/media\/Fd4kz2_WYAASkJL.jpg","question_1":"Do you think this is PRO congress?","question_1_
// type":"DD","question_1_ans":"YES,NO","question_2_ans":"MAYBE,DONT KNOW,BOTH","question_3_ans":"","question_4_ans":"","question_5_ans":"","question_2":"Do you think this image is offensive?","question_
// 2_type":"CB","question_3":"","question_3_type":"","question_4":"","question_4_type":"","question_5":"","question_5_type":"","module_enabled":"MEMBERSHIP,NOMINATION","requires_input":"Y","created_on":"
// 2023-02-11 06:00:29"}]}
import 'dart:convert';

class Question {
  Question({
    required this.id,
    required this.unicornId,
    required this.imageLink,
    required this.questionType,
    required this.question,
    required this.answers,
  });

  final String id;
  final String unicornId;
  final String imageLink;
  final String questionType;
  final String question;
  final List<String> answers;

  factory Question.fromRawJson(String str) =>
      Question.fromJson(json.decode(str));

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json["id"],
        unicornId: json["unicorn_id"],
        imageLink: json["image_link"],
        questionType: json["TASK_TYPE"],
        question: json["TASK_TEXT"],
        answers: json["TASK_URL"],
      );
}
