import 'package:flutter/material.dart';
import 'package:quiz/view/quiz_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void goToQuizApp(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => QuizApp()));
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
            Text(
              '$_counter',
            ),
            ElevatedButton(
                onPressed: () {
                  goToQuizApp(context); //クイズアプリへ遷移するQuizApp関数がよばれる
                },
                child: const Text('クイズアプリへ')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //右下の丸いボタン
        onPressed: _incrementCounter, //_incrementCounter関数がよばれる
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
