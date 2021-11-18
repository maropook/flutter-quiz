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

  @override
  void initState() {
    quizList = widget.quizList;
    super.initState();
  }

  Future<void> updateQuiz(BuildContext context) async {
    index++;
    if (index == quizList.length) {
      await goToResult(context);
    }
    setState(() {});
  }

  Future<void> goToResult(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Result()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: index < quizList.length
          ? Container(
              child: Column(
              children: [
                Text(quizList[index].question),
                TextButton(
                    onPressed: () async {
                      updateQuiz(context);
                    },
                    child: Text(quizList[index].select1)),
                TextButton(
                    onPressed: () async {
                      updateQuiz(context);
                    },
                    child: Text(quizList[index].select2)),
                TextButton(
                    onPressed: () async {
                      updateQuiz(context);
                    },
                    child: Text(quizList[index].select3)),
                TextButton(
                    onPressed: () async {
                      updateQuiz(context);
                    },
                    child: Text(quizList[index].select4))
              ],
            ))
          : Container(),
    );
  }
}

class Result extends StatelessWidget {
  Result({Key? key}) : super(key: key);

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
                  //クイズアプリへ遷移するQuizApp関数がよばれる
                },
                child: const Text('リザルト')),
          ],
        ),
      ),
    );
  }
}
