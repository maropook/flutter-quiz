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
