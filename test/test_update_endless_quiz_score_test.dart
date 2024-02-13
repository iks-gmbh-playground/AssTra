import 'package:asstra/1.library.train.and.play/view.3execution.dart';
import 'package:asstra/3.endless.quiz/do.endlessquiz.dart';
import 'package:asstra/3.endless.quiz/view.quizExecution.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('increase seriesScore and totalScore from 0', () {
    // arrange
    EndlessQuizProperties endlessQuizProperties = createTestEndlessQuizProperties(0,0);
    bool questOk = true;

    // act
    var result = AssTraEndlessQuizView.updatedEndlessQuizData(endlessQuizProperties, questOk);

    // assert
    expect(result.getLastSeriesScore(), 1);
    expect(result.getLastTotalScore(), 1);
  });

  test('decrease seriesScore and totalScore from 0', () {
    // arrange
    EndlessQuizProperties endlessQuizProperties = createTestEndlessQuizProperties(0,0);
    bool questOk = false;

    // act
    var result = AssTraEndlessQuizView.updatedEndlessQuizData(endlessQuizProperties, questOk);

    // assert
    expect(result.getLastSeriesScore(), -1);
    expect(result.getLastTotalScore(), -1);
  });

  test('increase totalScore without bonus from 0', () {
    // arrange
    EndlessQuizProperties endlessQuizProperties = createTestEndlessQuizProperties(1,0);
    bool questOk = true;

    // act 1
    var result1 = AssTraEndlessQuizView.updatedEndlessQuizData(endlessQuizProperties, questOk);

    // assert 1
    expect(result1.getLastSeriesScore(), 2);
    expect(result1.getLastTotalScore(), 1);

    // act 2
    result1 = AssTraEndlessQuizView.updatedEndlessQuizData(result1, questOk);
    var result2 = AssTraEndlessQuizView.updatedEndlessQuizData(result1, questOk);

    // assert
    expect(result2.getLastSeriesScore(), 4);
    expect(result2.getLastTotalScore(), 3);
  });

  test('decrease totalScore without bonus from 0', () {
    // arrange
    EndlessQuizProperties endlessQuizProperties = createTestEndlessQuizProperties(-1,0);
    bool questOk = false;

    // act 1
    var result1 = AssTraEndlessQuizView.updatedEndlessQuizData(endlessQuizProperties, questOk);

    // assert 1
    expect(result1.getLastSeriesScore(), -2);
    expect(result1.getLastTotalScore(), -1);

    // act 2
    result1 = AssTraEndlessQuizView.updatedEndlessQuizData(result1, questOk);
    var result2 = AssTraEndlessQuizView.updatedEndlessQuizData(result1, questOk);

    // assert 2
    expect(result2.getLastSeriesScore(), -4);
    expect(result2.getLastTotalScore(), -3);
  });

  test('increase seriesScore with bonus of 4', () {
    // arrange
    EndlessQuizProperties endlessQuizProperties = createTestEndlessQuizProperties(19,0);
    bool questOk = true;

    // act
    var result = AssTraEndlessQuizView.updatedEndlessQuizData(endlessQuizProperties, questOk);

    // assert
    expect(result.getLastSeriesScore(), 20);
    expect(result.getLastTotalScore(), 5);
  });

  test('decrease seriesScore with malus of 4', () {
    // arrange
    EndlessQuizProperties endlessQuizProperties = createTestEndlessQuizProperties(-19,0);
    bool questOk = false;

    // act
    var result = AssTraEndlessQuizView.updatedEndlessQuizData(endlessQuizProperties, questOk);

    // assert
    expect(result.getLastSeriesScore(), -20);
    expect(result.getLastTotalScore(), -5);
  });

}

EndlessQuizProperties createTestEndlessQuizProperties(int seriesScore, int totalScore) {
  String propString = EndlessQuizProperties.lastSeriesScore + "=" + seriesScore.toString()
                      + propertySeparator +
                      EndlessQuizProperties.lastTotalScore + "=" + totalScore.toString();
  return EndlessQuizProperties.fromString(propString);
}
