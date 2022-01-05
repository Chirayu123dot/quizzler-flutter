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

  void isAnswerCorrect(bool val) {
    if (val) {
      scoreCard.add(getScoreIcon(color: Colors.green));
      quizBrain.increaseScore();
    } else {
      scoreCard.add(getScoreIcon(color: Colors.red));
    }
  }

  Alert getAlertDialog(BuildContext context) {
    var alertStyle = AlertStyle(
      isCloseButton: false,
    );

    quizBrain.quizFinishedAlertDisplayed = true;

    return Alert(
      context: context,
      style: alertStyle,
      title: '${quizBrain.getScore()}/${quizBrain.getTotalScore()}',
      desc: 'Quiz Finished!',
      buttons: [
        DialogButton(
          child: Text(
            'RESET',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          onPressed: () {
            setState(() {
              scoreCard.clear();
              quizBrain.resetQuiz();
              Navigator.pop(context);
            });
          },
        )
      ],
    );
  }

  Expanded getButton({required String type, required BuildContext context}) {
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
            // The user has clicked on a button
            setState(() {
              if (!quizBrain.quizFinishedAlertDisplayed) {
                if (type == 'True') {
                  // user clicked on 'True' button
                  quizBrain.getQuestionAnswer()
                      ? isAnswerCorrect(true)
                      : isAnswerCorrect(false);
                } else {
                  // user clicked on 'False' button
                  quizBrain.getQuestionAnswer()
                      ? isAnswerCorrect(false)
                      : isAnswerCorrect(true);
                }
              }

              // Check whether the quiz has ended or not
              if (quizBrain.quizFinished()) {
                // Display alert dialog
                getAlertDialog(context).show();
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
