import 'package:flutter/material.dart';
import 'package:quizzler/question.dart';

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

Icon getScoreIcon({required Color color}) {
  IconData icon;
  if (color == Colors.green) {
    icon = Icons.check;
  } else {
    icon = Icons.close;
  }
  return Icon(
    icon,
    color: color,
  );
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreCard = [];

  List<Question> questionBank = [
    Question('You can lead a cow down stairs but not up stairs.', false),
    Question('Approximately one quarter of human bones are in the feet.', true),
    Question('A slug\'s blood is green.', true),
  ];

  int questionNumber = 0;

  Expanded getButton({required String type}) {
    Color color;
    if (type == 'True') {
      color = Colors.green;
    } else {
      color = Colors.red;
    }

    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextButton(
          style: TextButton.styleFrom(backgroundColor: color),
          onPressed: () {
            // The user clicked
            setState(() {
              if (type == 'True') {
                // user clicked on 'True' button
                questionBank[questionNumber].questionAnswer
                    ? scoreCard.add(getScoreIcon(color: Colors.green))
                    : scoreCard.add(getScoreIcon(color: Colors.red));
              } else {
                // user clicked on 'False' button
                questionBank[questionNumber].questionAnswer
                    ? scoreCard.add(getScoreIcon(color: Colors.red))
                    : scoreCard.add(getScoreIcon(color: Colors.green));
              }
              questionNumber = (questionNumber + 1) % 3;
            });
          },
          child: Text(
            type,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                questionBank[questionNumber].questionText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        getButton(type: 'True'),
        getButton(type: 'False'),
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: SizedBox(
            height: 24.0,
            child: Row(
              children: scoreCard,
            ),
          ),
        )
      ],
    );
  }
}

/*
question1: 'You can lead a cow down stairs but not up stairs.', false,
question2: 'Approximately one quarter of human bones are in the feet.', true,
question3: 'A slug\'s blood is green.', true,
*/
