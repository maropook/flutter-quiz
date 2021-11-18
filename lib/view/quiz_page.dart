import 'package:flutter/material.dart';
import 'package:quiz/service/load_csv.dart';
import 'package:quiz/model/quiz.dart';
import 'package:quiz/service/suffle.dart';
import 'package:quiz/view/result_page.dart';

class QuizApp extends StatelessWidget {
  QuizApp({Key? key}) : super(key: key);
  late List<Quiz> quizList;

  Future<void> goToQuizApp(BuildContext context) async {
    quizList = shuffle(await getCsvData('assets/quiz1.csv'));
    for (Quiz row in quizList) {
      debugPrint(row.question);
    }

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => QuizPage(quizList)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          //Columnの中に入れたものは縦に並べられる．Rowだと横に並べられる
          mainAxisAlignment: MainAxisAlignment.center, //Coloumの中身を真ん中に配置
          children: <Widget>[
            const Text(
              'クイズ',
            ),
            ElevatedButton(
                onPressed: () {
                  goToQuizApp(context); //クイズアプリへ遷移するQuizApp関数がよばれる
                },
                child: const Text('スタート')),
          ],
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  QuizPage(this.quizList, {Key? key}) : super(key: key);
  List<Quiz> quizList;

  @override
  State<QuizPage> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  late List<Quiz> quizList;
  int index = 0;
  int result = 0;
  bool isSelectNow = true;

  @override
  void initState() {
    quizList = widget.quizList;
    super.initState();
  }

  Future<void> updateQuiz(BuildContext context, int selectAnswer) async {
    setState(() {
      isSelectNow = false;
    });
    if (quizList[index].answer == selectAnswer) {
      result++;
    }

    await Future.delayed(const Duration(seconds: 1));
    isSelectNow = true;
    setState(() {});
    index++;
    if (index == quizList.length) {
      await goToResult(context);
    }
    setState(() {});
  }

  Future<void> goToResult(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Result(result, quizList.length)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: index < quizList.length
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(quizList[index].question),
                TextButton(
                    onPressed: () async {
                      if (!isSelectNow) return;
                      await updateQuiz(context, 1);
                    },
                    child: isSelectNow
                        ? Text(quizList[index].select1)
                        : quizList[index].answer == 1
                            ? Text(quizList[index].select1 + "○")
                            : Text(quizList[index].select1 + "×")),
                TextButton(
                    onPressed: () async {
                      if (!isSelectNow) return;
                      await updateQuiz(context, 2);
                    },
                    child: isSelectNow
                        ? Text(quizList[index].select2)
                        : quizList[index].answer == 2
                            ? Text(quizList[index].select2 + "○")
                            : Text(quizList[index].select2 + "×")),
                TextButton(
                    onPressed: () async {
                      if (!isSelectNow) return;
                      await updateQuiz(context, 3);
                    },
                    child: isSelectNow
                        ? Text(quizList[index].select3)
                        : quizList[index].answer == 3
                            ? Text(quizList[index].select3 + "○")
                            : Text(quizList[index].select3 + "×")),
                TextButton(
                    onPressed: () async {
                      if (!isSelectNow) return;
                      await updateQuiz(context, 4);
                    },
                    child: isSelectNow
                        ? Text(quizList[index].select4)
                        : quizList[index].answer == 4
                            ? Text(quizList[index].select4 + "○")
                            : Text(quizList[index].select4 + "×")),
              ],
            ))
          : Container(),
    );
  }
}
