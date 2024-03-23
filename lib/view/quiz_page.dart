import 'package:flutter/material.dart';
import 'package:quiz/view/result_page.dart';

class QuizPage extends StatefulWidget {
  QuizPage(this.quizList, {Key? key}) : super(key: key);
  List<Map> quizList;

  @override
  State<QuizPage> createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  late List<Map> quizList;
  int index = 0;
  int result = 0;
  bool isSelectNow = true; //答えをボタンを押す前がtrue

  @override
  void initState() {
    quizList = widget.quizList;
    super.initState();
  }

  Future<void> updateQuiz(BuildContext context, int selectAnswer) async {
    setState(() {
      isSelectNow = false;
    });
    if (quizList[index]["answer"] == selectAnswer) {
      result++;
    }

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isSelectNow = true;
      index++;
    });
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
          ? CustomScrollView(
              slivers: <Widget>[
                SliverList(
                    delegate: SliverChildListDelegate([
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3)),
                  Text(
                    quizList[index]['question'],
                    textAlign: TextAlign.center,
                  ),
                ])),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (context, key) {
                    return TextButton(
                        onPressed: () async {
                          if (!isSelectNow) return;
                          await updateQuiz(context, key);
                        },
                        child: isSelectNow
                            ? Text(quizList[index]
                                ["select$key"]) //isSelectNowがtrueなら
                            : quizList[index]["answer"] == key
                                ? Text(quizList[index]["select$key"] +
                                    "○") //isSelectNowがfalseで答えと一緒なら
                                : Text(quizList[index]["select$key"] +
                                    "×")); //isSelectNowがfalseで答えと違うなら
                  },
                  childCount: 4,
                )),
              ],
            )
          : Container(),
    );
  }
}
