import 'package:flutter/services.dart';
import 'package:quiz/model/quiz.dart';

Future<List<Map>> getCsvData(String path) async {
  List<Map> quizList = [];
  String csv = await rootBundle.loadString(path);
  for (String line in csv.split("\n")) {
    if (quizList.length + 1 == csv.split("\n").length) {
      break;
    }
    List rows = line.split(',');
    Quiz quiz = Quiz(
      rows[0],
      int.parse(rows[1]),
      rows[2],
      rows[3],
      rows[4],
      rows[5],
    );

    quizList.add(quiz.toMap());
  }
  return quizList;
}
