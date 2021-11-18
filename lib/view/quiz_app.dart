import 'package:flutter/material.dart';
import 'package:quiz/service/load_csv.dart';
import 'package:quiz/model/quiz.dart';
import 'package:quiz/service/suffle.dart';

class QuizApp extends StatelessWidget {
  QuizApp({Key? key}) : super(key: key);
  late List<Quiz> quizList;

  Future<void> goToQuizApp(BuildContext context) async {
    quizList = shuffle(await getCsvData('assets/quiz1.csv'));
    for (Quiz row in quizList) {
      debugPrint(row.question);
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MainQuizApp(quizList)));
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
              'ボタンを押せ',
            ),
            ElevatedButton(
                onPressed: () {
                  goToQuizApp(context); //クイズアプリへ遷移するQuizApp関数がよばれる
                },
                child: const Text('クイズアプリへ')),
          ],
        ),
      ),
    );
  }
}

class MainQuizApp extends StatefulWidget {
  MainQuizApp(this.quizList, {Key? key}) : super(key: key);
  List<Quiz> quizList;

  @override
  State<MainQuizApp> createState() => MainQuizAppState();
}

class MainQuizAppState extends State<MainQuizApp> {
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

class Result extends StatelessWidget {
  Result(this.result, this.quizNumber, {Key? key}) : super(key: key);
  int result;
  int quizNumber;
  late String comment;
  @override
  Widget build(BuildContext context) {
    switch (result * 10 ~/ quizNumber) {
      case 6:
        comment = "まあまあ";
        break;
      case 7:
        comment = "まあまあ";
        break;
      case 8:
        comment = "いいね";
        break;
      case 9:
        comment = "すごい";
        break;
      case 10:
        comment = "よくできました";
        break;
      default:
        comment = "頑張りましょう";
        break;
    }
    print("${result / quizNumber * 10}");

    return Scaffold(
      body: Center(
        child: Column(
          //Columnの中に入れたものは縦に並べられる．Rowだと横に並べられる
          mainAxisAlignment: MainAxisAlignment.center, //Coloumの中身を真ん中に配置
          children: <Widget>[
            Text(
              comment,
            ),
            ElevatedButton(
                onPressed: () {
                  //クイズアプリへ遷移するQuizApp関数がよばれる
                },
                child: Text('$result')),
          ],
        ),
      ),
    );
  }
}
