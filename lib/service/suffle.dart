import 'dart:math';

import 'package:quiz/model/quiz.dart';

List<Quiz> shuffle(List<Quiz> items) {
  var random = Random();
  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}
