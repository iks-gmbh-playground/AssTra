import 'package:asstra/1.library.train.and.play/do.train_and_play.dart';
import 'package:asstra/1.library.train.and.play/view.3execution.dart';
import 'package:asstra/main.dart';
import 'package:flutter/material.dart';

import '../common/asstra.constants.dart';
import 'do.endlessquiz.dart';

/// introducing view for "train and play"
class AssTraEndlessQuizView extends StatelessWidget {

  static const int obsoleteLimitInMillis = 1000 * 60 * 30;  // half an hour
  static const int limitBonusMalus = 5;

  const AssTraEndlessQuizView( {super.key});

  @override
  Widget build(BuildContext context) {
    checkAgeOfQuizData();
    return AssTraExecutionView(knowledgeFields: appRuntimeData.knowledgeFields,
                               execConfig: PlayingConfig(DirectionMode.mixed, PlayingMode.endlessQuiz, -1));
  }

  static EndlessQuizProperties updatedEndlessQuizData(EndlessQuizProperties quizData, bool answerOk) {
    checkSeriesScore(quizData, answerOk);
    checkTotalScore(quizData);
    checkBonusMalus(quizData, limitBonusMalus);
    return quizData;
  }

  static void checkSeriesScore(EndlessQuizProperties quizData, bool answerOk) {
    if (answerOk) {
      if (quizData.getLastSeriesScore() < 0) {
        quizData.setLastSeriesScore(0); // reset
      } else {
        quizData.setLastSeriesScore(quizData.getLastSeriesScore() + 1);
      }
    } else {
      if (quizData.getLastSeriesScore() > 0) {
        quizData.setLastSeriesScore(0); // reset
      } else {
        quizData.setLastSeriesScore(quizData.getLastSeriesScore() - 1);
      }
    }
  }

  static void checkTotalScore(EndlessQuizProperties quizData) {
    if (quizData.getLastSeriesScore() > 0) {
      quizData.setLastTotalScore(quizData.getLastTotalScore() + 1);
    }
    if (quizData.getLastSeriesScore() < 0) {
      quizData.setLastTotalScore(quizData.getLastTotalScore() - 1);
    }
  }

  static void checkBonusMalus(EndlessQuizProperties quizData, int bonusLimit) {
    int score = quizData.getLastSeriesScore();
    while (score > 0 && score >= bonusLimit) {
      quizData.setLastTotalScore(quizData.getLastTotalScore() + 1);
      score = score - bonusLimit;
    }

    score = quizData.getLastSeriesScore();
    while (score < 0 && score <= -bonusLimit) {
      quizData.setLastTotalScore(quizData.getLastTotalScore() - 1);
      score = score + bonusLimit;
    }
  }

  void checkAgeOfQuizData() {
    var now = DateTime.now().millisecond;
    if (now - appRuntimeData.endlessQuizData.getLastQuestTimestamp() > obsoleteLimitInMillis ) {
      appRuntimeData.endlessQuizData.setLastQuestTimestamp(now);
      appRuntimeData.endlessQuizData.setLastSeriesScore(0);
    }
  }

}
