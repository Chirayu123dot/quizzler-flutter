import 'package:flutter/material.dart';
import 'quiz_brain.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

QuizBrain quizBrain = QuizBrain();

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

  Expanded getButton({required String type, required BuildContext context}) {
    Color color;
    if (type == 'True') {
      color = Colors.green;
    } else {
      color = Colors.red;
    }

    var alertStyle = AlertStyle(
      isCloseButton: false,
    );

    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: TextButton(
          style: TextButton.styleFrom(backgroundColor: color),
          onPressed: () {
            // The user has clicked on a button
            setState(() {
              if (type == 'True') {
                // user clicked on 'True' button
                quizBrain.getQuestionAnswer()
                    ? scoreCard.add(getScoreIcon(color: Colors.green))
                    : scoreCard.add(getScoreIcon(color: Colors.red));
              } else {
                // user clicked on 'False' button
                quizBrain.getQuestionAnswer()
                    ? scoreCard.add(getScoreIcon(color: Colors.red))
                    : scoreCard.add(getScoreIcon(color: Colors.green));
              }

              // Check whether the quiz has ended or not
              if (quizBrain.quizFinished()) {
                // Display alert dialog
                Alert(
                  context: context,
                  style: alertStyle,
                  type: AlertType.success,
                  title: 'Finished!',
                  desc: 'You\'ve reached the end of the quiz',
                  buttons: [
                    DialogButton(
                      child: Text(
                        'RESET',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          scoreCard.clear();
                          quizBrain.resetQuiz();
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ).show();
              } else {
                // Quiz has not ended
                // Move to the next question
                quizBrain.nextQuestion();
              }
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
                quizBrain.getQuestionText(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        getButton(type: 'True', context: context),
        getButton(type: 'False', context: context),
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
