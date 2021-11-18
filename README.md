# クイズアプリ

Flutterアプリのチュートリアルに最適だと思い,4択のクイズアプリを実装したのでメモ



# 実装

```shell

$ flutter create quiz  

$ cd quiz

$ flutter run

```

# 依存パッケージ

```pubspec.yaml
flutter:
  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true
  assets:
    - assets/
```

クイズの問題はcsvファイルをassetsフォルダ内に入れ,そこから読み込むため．

## 最初に呼び出すページ

```dart:main.dart
//main.dart

import 'package:flutter/material.dart';
import 'package:quiz/view/quiz_app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: QuizApp());
  }
}

```
エラーが出ると思いますが，気にしないでください．

最初に`main`関数を呼び出し，`MyApp`を呼び出します．そこでは`QuizApp`を返します．

次にこのアプリのメイン.クイズのスタートページである`QuizApp`を実装します．

```dart:view/quiz_app.dart

//view/quiz_app.dart

import 'package:flutter/material.dart';
import 'package:quiz/service/load_csv.dart';
import 'package:quiz/service/suffle.dart';
import 'package:quiz/view/quiz_page.dart';

class QuizApp extends StatelessWidget {
  QuizApp({Key? key}) : super(key: key);
  late List<Map> quizList;

  Future<void> goToQuizApp(BuildContext context) async {
    quizList = shuffle(await getCsvData('assets/quiz1.csv'));
    for (Map row in quizList) {
      debugPrint(row["question"]);
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

```
`goToQuizApp`関数ではクイズアプリのメイン画面であるクイズを解く画面`quizPage`へ移動します．

しかし，その関数の中では，このアプリで最も重要と言っても過言ではない関数 `getCsvData`関数と`shuffle`関数がよばれています．

`getCsvData`関数ではcsvファイルから問題を取り出して，Quizクラス(問題や選択し，回答が含まれたクラス)を作成し，Quizクラスをmapに変換し,

quizListというリストにそのmapを追加していきます．

```dart:model/quiz.dart

//model/quiz.dart

class Quiz {
  String question;
  int answer;
  String select0;
  String select1;
  String select2;
  String select3;

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'answer': answer,
      'select0': select0,
      'select1': select1,
      'select2': select2,
      'select3': select3,
    };
  }

  Quiz(
    this.question,
    this.answer,
    this.select0,
    this.select1,
    this.select2,
    this.select3,
  );
}

```

```dart:service/load_csv.dart

//service/load_csv.dart

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


```
`shuffle`関数では，`getCsvData`で得られたリスト`quizList`の並びをシャッフルすることで，毎回違う順番でクイズの問題が出ることになります．



```dart:service/suffle.dart

import 'dart:math';

List<Map> shuffle(List<Map> items) {
  var random = Random();
  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}

```

`goToQuizApp`関数ではクイズアプリのメイン画面であるクイズを解く画面`quizPage`へ移動します．

`quizPage`では，上記で解説したQuizListを渡しています．

次にその`quizPage`の実装をします

```dart:view/quiz_page.dart

//view/quiz_page.dart

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
    if (quizList[index]["answer"] == selectAnswer) {
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
                            ? Text(quizList[index]["select$key"])
                            : quizList[index]["answer"] == key
                                ? Text(quizList[index]["select$key"] + "○")
                                : Text(quizList[index]["select$key"] + "×"));
                  },
                  childCount: 4,
                )),
              ],
            )
          : Container(),
    );
  }
}

```

選択肢を押すと，`updateQuiz`関数がよばれ，isSelectNowがfalseになります

1秒間選択肢ボタンを押しても何も起こらなくなり，その間はその答えが○か×か表示されます

クイズの数は`index`で管理しています．

indexがquizList.lengthと同じになると，`goToQuizApp`関数がよばれ，result画面である`resultPage`へ移動します．

次にその`resultPage`の実装をします

```dart:view/result_page.dart
import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  Result(this.result, this.quizNumber, {Key? key}) : super(key: key);
  int result;
  int quizNumber;
  late String comment;

  Future<void> goToTop(BuildContext context) async {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    switch (result.round() * 100 ~/ quizNumber) {
      case 60:
        comment = "まあまあ";
        break;
      case 70:
        comment = "まあまあ";
        break;
      case 80:
        comment = "いいね";
        break;
      case 90:
        comment = "すごい";
        break;
      case 100:
        comment = "よくできました";
        break;
      default:
        comment = "頑張りましょう";
        break;
    }
    print("${result / quizNumber * 100}");

    return Scaffold(
      body: Center(
        child: Column(
          //Columnの中に入れたものは縦に並べられる．Rowだと横に並べられる
          mainAxisAlignment: MainAxisAlignment.center, //Coloumの中身を真ん中に配置
          children: <Widget>[
            Text(comment),
            Text('正答数$result'),
            Text('正答率${result / quizNumber * 100}%'),
            ElevatedButton(
                onPressed: () async {
                  await goToTop(context);
                },
                child: const Text('トップへ戻る')),
          ],
        ),
      ),
    );
  }
}

```

```csv:assets/quiz1.csv

//assets/quiz1.csv

実際に北海道に存在する川はどれ？,2,イトオシイ川,クルオシイ川,ヤリキレナイ川,チョウシデナイ川
天空の城ラピュタのムスカ大佐の年齢はいくつでしょう？,0,28歳,32歳,58歳,62歳
サザエさんに出てくるアナゴさんの年齢は？,0,28歳,32歳,58歳,62歳
ドラゴンボールのべジータは何ｃｍでしょう？,1,159cm,164cm,179cm,184cm
世界で最も歌われている曲は次のうちどれ？,0,ハッピーバースデートゥーユー,きらきら星,ジングルベル,アメージンググレイス
俳句の季語として認定されていないものはどれ？,1,サザン,チューブ,ユーミン,山下達郎
黄色のカーネーションの花言葉は次のうちどれ?,3,家族愛,感謝,嫉妬,軽蔑
マジ？という言葉は一体いつからあったでしょう？,0,江戸時代,明治時代,昭和,平成

```

csvファイルは，上記のように最後の行に改行を入れてください.

頭は詰めてかいてください．


