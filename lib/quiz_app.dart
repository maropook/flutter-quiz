import 'package:flutter/material.dart';
import 'package:quiz/load_csv.dart';
import 'package:quiz/quiz.dart';
import 'package:quiz/suffle.dart';

class QuizApp extends StatelessWidget {
  const QuizApp({Key? key}) : super(key: key);
  void goToQuizApp(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MainQuizApp()));
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
  const MainQuizApp({Key? key}) : super(key: key);

  @override
  State<MainQuizApp> createState() => MainQuizAppState();
}

class MainQuizAppState extends State<MainQuizApp> {
  late List<Quiz> quizList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
        children: [
          ElevatedButton(
              onPressed: () async {
                quizList = shuffle(await getCsvData('assets/quiz1.csv'));
                for (Quiz row in quizList) {
                  debugPrint(row.question);
                }

                setState(() {});
              },
              child: Text('クイズ読み込み'))
        ],
      )),
    );
  }
}
