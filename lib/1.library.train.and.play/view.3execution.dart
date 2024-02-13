import 'dart:async';
import 'dart:math';

import 'package:asstra/1.library.train.and.play/texts/text.execution.dart';
import 'package:asstra/1.library.train.and.play/view.4results.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/main.dart';
import 'package:asstra/text.main.dart';
import 'package:flutter/material.dart';

import '../2.manage.knowledge.base/do.manage.knowledge.base.dart';
import '../3.endless.quiz/do.endlessquiz.dart';
import '../3.endless.quiz/view.quizExecution.dart';
import '../common/utils/asstra.util.dialog.dart';
import '../common/widgets/AssTraAppBar.dart';
import 'do.train_and_play.dart';

class AssTraExecutionView extends StatefulWidget {
  final List<KnowledgeField> knowledgeFields;
  final ExecConfig execConfig;
  final random = Random();
  final Map<String,String> keyValueActiveSubgroup = {};
  final Map<String,String> keyValuePassiveSubgroup = {};
  final Map<String,int> wrongAnswered = {};
  final Map<String, int> keysNumberCorrectlyAnsweredInSequence = {};
  final Map<String, bool> keysNumberCorrectlyAnsweredDirection = {};
  final List<String> learnedAssociationKeysThisSession = List.empty(growable: true);
  bool isPlaying = false;
  bool isEndlessQuiz = false;
  QuestData questData = QuestData('', '', '', List.empty(), '', false);
  int activeSubgroupSize = -1;
  int startTimestamp = -1;
  int endTimestamp = -1;
  int questCounter = 0;
  int questOkCounter = 0;
  bool countNewStateCallAsNewQuest = true;
  late Timer countdownTimer;
  Duration timerDuration = const Duration(seconds: -1);
  String keyInLastQuest = "";

  AssTraExecutionView( {required this.knowledgeFields, required this.execConfig, super.key}) {
    reInitCollections();
    isPlaying = execConfig.startMode == StartMode.playing;
    keyValuePassiveSubgroup.addAll(findNotYetLearnedAssociations());
    startTimestamp = (DateTime.now()).millisecondsSinceEpoch;
    if (! isPlaying) {
      activeSubgroupSize = getActiveSubgroupSize(execConfig as TrainingConfig);
    } else {
      isEndlessQuiz = (execConfig as PlayingConfig).playingMode == PlayingMode.endlessQuiz;
    }
    fillUpActiveSubgroupIfNeeded();
  }

  @override
  State<AssTraExecutionView> createState() => _ExecutionState();

  int getActiveSubgroupSize(TrainingConfig trainingConfig) {
    if (trainingConfig.trainingMode == TrainingMode.muchKnowledge) {
      return appRuntimeData.appConfigData.getNumberOfSubgroupsForMuchKnowledge();
    } else if (trainingConfig.trainingMode == TrainingMode.someKnowledge) {
      return appRuntimeData.appConfigData.getNumberOfSubgroupsForSomeKnowledge();
    } else {
      return appRuntimeData.appConfigData.getNumberOfSubgroupsForLittleKnowledge();
    }
  }

  bool fillUpActiveSubgroupIfNeeded() {
    if (isPlaying) {
      if (keyValueActiveSubgroup.isEmpty) {
        keyValueActiveSubgroup.addAll(knowledgeFields.elementAt(0).keyValuePairs);
      }
    } else {
      if (keyValuePassiveSubgroup.isEmpty) return false;
      while (keyValueActiveSubgroup.length < activeSubgroupSize && keyValuePassiveSubgroup.isNotEmpty) {
        transferOneRandomEntryFromPassiveIntoActiveSubgroup();
      }
    }
    return true;
  }

  void transferOneRandomEntryFromPassiveIntoActiveSubgroup() {
    var randomIndex = random.nextInt(keyValuePassiveSubgroup.length);
    var key = keyValuePassiveSubgroup.keys.elementAt(randomIndex);
    var value = keyValuePassiveSubgroup.remove(key).toString();
    keyValueActiveSubgroup.addEntries({key:value}.entries);
  }

  void reInitCollections() {
    keyValueActiveSubgroup.clear();
    keyValuePassiveSubgroup.clear();
    wrongAnswered.clear();
    keysNumberCorrectlyAnsweredInSequence.clear();
    learnedAssociationKeysThisSession.clear();
    keysNumberCorrectlyAnsweredDirection.clear();
  }

  Map<String, String> findNotYetLearnedAssociations() {
    Map<String, String> toReturn = {};
    KnowledgeField knowledgeFieldToTrain = knowledgeFields.elementAt(0); // note areas cannot be trained !
    knowledgeFieldToTrain.keyValuePairs.forEach((key, value) => toReturn.addEntries({key:value}.entries));
    if (execConfig.directionMode == DirectionMode.forwards || execConfig.directionMode == DirectionMode.mixed) {
      var forwardsLearned = appRuntimeData.associationsLearned.forwardsLearned[knowledgeFieldToTrain.getName()];
      if (forwardsLearned != null) {
        for (var key in forwardsLearned) {
          toReturn.remove(key);
        }
      }
    }
    if (execConfig.directionMode == DirectionMode.backwards || execConfig.directionMode == DirectionMode.mixed) {
      var backwardsLearned = appRuntimeData.associationsLearned.backwardsLearned[knowledgeFieldToTrain.getName()];
      if (backwardsLearned != null) {
        for (var key in backwardsLearned) {
          toReturn.remove(key);
        }
      }
    }
    return toReturn;
  }

}

class _ExecutionState extends State<AssTraExecutionView> {
  _ExecutionState();

  @override
  Widget build(BuildContext context) {
    if (widget.keyValuePassiveSubgroup.isEmpty && widget.keyValueActiveSubgroup.isEmpty) {
      return createDoneWithTrainingView();
    }
    if (widget.questCounter == 0) widget.questData = getNextQuestData();
    if (widget.countNewStateCallAsNewQuest) {
      widget.questCounter++;
    }
    widget.countNewStateCallAsNewQuest = false;

    if (widget.timerDuration.inSeconds == -1 && widget.isPlaying
        && (widget.execConfig as PlayingConfig).playingMode == PlayingMode.race) {
      startTimer();
    }
    return Scaffold(
        appBar: widget.isEndlessQuiz ? null : AssTraAppBar(mainTitle: textMainAppTitle, subTitle: '', subTitleSubLine: '', withFlowControlIcon: true),
        body: getInternalScaffold()
    );
  }

  Scaffold getInternalScaffold() {
    double height = MediaQuery.of(context).size.height / 10;
    double fontSize = MediaQuery.of(context).size.height / 30;
    double yDiff = MediaQuery.of(context).size.height / 15;

    return Scaffold(
        body: SingleChildScrollView(child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(children: <Widget>[
                  AssTraStringUtil.markdownStringToSizedText22(widget.questData.question),
                  const SizedBox(height: 30),
                  ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.questData.possibleAnswers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, yDiff),
                            child: InkWell(
                                onTap: () {
                                  takeAnswer(widget.questData.possibleAnswers[index]);
                                },
                                splashColor: Colors.purple,
                                radius: 15,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: const Color.fromRGBO(220, 220, 220, 100),
                                      border: getBorderForAnswer(index)
                                  ),
                                  height: height,
                                  child: Center(
                                      child: Text(widget.questData.possibleAnswers[index],
                                          style: getTextStyleForAnswer(index, fontSize)
                                      )
                                  ),
                                ))
                            );
                      }
                  ),

                  createBottomRow(),
                ])
            )
        ))
    );
  }

  Row createBottomRow() {
    String type = widget.execConfig.startMode.displayValue;
    if (widget.isEndlessQuiz) {
      type = PlayingMode.endlessQuiz.displayValue;
    }
    return Row(children: [
      IconButton(onPressed: () => AssTraDialogUtil.showInfoBox(context, type, createInfoText()),
                 icon: const Icon(infoIcon, color: infoIconColor)),
      const Spacer(),
      AssTraStringUtil.markdownStringToSizedText22("${createProgressInfoString()}  "),
      const Spacer(),
      Visibility(visible: widget.isPlaying,
                 child: const SizedBox(height: 20, child: iksLogoOhneSchrift)),
      Visibility(visible: ! widget.isPlaying,
                 child: ElevatedButton(onPressed: () => onPressStop(),
                        style: okButtonStyle,
                        child: const Text(textExecutionStop)
                 ),
      )
    ]);
  }

  String createInfoText() {
    if (widget.isPlaying) {
      var playingConfig = widget.execConfig as PlayingConfig;
      String knowledgeString = "Knowledge Field *${widget.knowledgeFields.elementAt(0).getName()}*";
      if (widget.knowledgeFields.length > 1) {
        knowledgeString = "Knowledge Area *${widget.knowledgeFields.elementAt(0).knowledgeArea}*";
      }
      if (playingConfig.playingMode == PlayingMode.race) {
        return textInfoRace.replaceFirst("<X>", knowledgeString)
                           .replaceFirst("<Y>", playingConfig.duration.toString());
      } else if (playingConfig.playingMode == PlayingMode.match) {
        return textInfoMatch.replaceFirst("<X>", knowledgeString)
                            .replaceFirst("<Y>", (widget.questCounter-1).toString())
                            .replaceFirst("<Z>", playingConfig.duration.toString());
      } else {
        var numAssociations = widget.knowledgeFields.map((e) => e.keyValuePairs.length).reduce((a, b) => a + b);
        return textInfoEndlessQuiz.replaceFirst("<X>", numAssociations.toString())
                                  .replaceFirst("<Y>", widget.knowledgeFields.length.toString())
                                  .replaceFirst("<Z>", appRuntimeData.endlessQuizData.getLastTotalScore().toString());
      }
    } else {
      String mapKey = widget.questData.knowledgeFieldName;
      String numForward = "0";
      List<String>? list = appRuntimeData.associationsLearned.forwardsLearned[mapKey];
      if (list != null) numForward = list!.length.toString();
      String numBackward = "0";
      list = appRuntimeData.associationsLearned.backwardsLearned[mapKey];
      if (list != null) numBackward = list!.length.toString();

      return textInfoTraining.replaceFirst("<X>", widget.knowledgeFields.elementAt(0).getName())
                             .replaceFirst("<Y>", widget.knowledgeFields.elementAt(0).keyValuePairs.length.toString())
                             .replaceFirst("<Z>", numForward)
                             .replaceFirst("<V>", numBackward);
    }
  }

  String createProgressInfoString() {
    if (widget.isPlaying) {
      var playingConfig = widget.execConfig as PlayingConfig;
      if (playingConfig.playingMode == PlayingMode.race) {
        return AssTraStringUtil.durationToString(widget.timerDuration);
      } else if (playingConfig.playingMode == PlayingMode.match) {
        return '${widget.questCounter} / ${playingConfig.duration}';
      } else {
        return appRuntimeData.endlessQuizData.getLastTotalScore().toString();
      }
    } else {
      var knowledgeFieldName = widget.questData.knowledgeFieldName;
      List<String>? forwardsLearned = appRuntimeData.associationsLearned.forwardsLearned[knowledgeFieldName];
      int forward = 0;
      if (forwardsLearned != null) {
        forward = forwardsLearned.length;
      }
      List<String>? backwardsLearned = appRuntimeData.associationsLearned.backwardsLearned[knowledgeFieldName];
      int backward = 0;
      if (backwardsLearned != null) {
        backward = backwardsLearned.length;
      }

      return "${appRuntimeData.getKnowledgeField(knowledgeFieldName).keyValuePairs.length} | "
             "$forward | "
             "$backward";
    }
  }

  void navigateToResultPage() {
    int currentTimestamp = (DateTime.now()).millisecondsSinceEpoch;
    int duration = currentTimestamp-widget.startTimestamp;
    ExecResult result = ExecResult(widget.execConfig, widget.knowledgeFields,
                                   duration, widget.questCounter, widget.questOkCounter,
                                   getTotalAssNumber(), getLearnedAssNumber());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssTraExecResultView(execResult: result)),
    );
  }

  int getTotalAssNumber() {
    var keys = List.empty(growable: true);
    keys.addAll(widget.wrongAnswered.keys);
    widget.keysNumberCorrectlyAnsweredInSequence.keys.where((element) => !keys.contains(element)).forEach((element) {keys.add(element);});
    return keys.length + getLearnedAssNumber();
  }

  int getLearnedAssNumber() {
    return widget.learnedAssociationKeysThisSession.length;
  }

  Border getBorderForAnswer(int index) {
    if (widget.questData.actualAnswer == null) {
      return Border.all(color: Colors.purple, width: 2);
    }

    String? answerForIndex = widget.questData.possibleAnswers.elementAt(index);
    if (answerForIndex == widget.questData.correctAnswer) {
      if (answerForIndex == widget.questData.actualAnswer) {
        return Border.all(color: Colors.green.shade600, width: 5);
      } else {
        return Border.all(color: Colors.green.shade600, width: 8);
      }
    }

    if (answerForIndex == widget.questData.actualAnswer) {
      return Border.all(color: Colors.red.shade800, width: 8);
    }

    return Border.all(color: Colors.purple, width: 2);
  }

  TextStyle getTextStyleForAnswer(int index, double? fontSize) {
    if (widget.questData.actualAnswer == null) {
      return TextStyle(fontSize: fontSize);
    }

    String? answerForIndex = widget.questData.possibleAnswers.elementAt(index);
    if (answerForIndex == widget.questData.correctAnswer) {
      return TextStyle(color: Colors.white,
          backgroundColor: Colors.green,
          fontSize: fontSize);
    }

    if (answerForIndex == widget.questData.actualAnswer) {
      return TextStyle(color: Colors.white,
          backgroundColor: Colors.red,
          fontSize: fontSize);
    }

    return TextStyle(fontSize: fontSize);
  }

  void takeAnswer(String actualAnswer) {
    widget.keyInLastQuest = widget.questData.questKey;
    storeAnswer(actualAnswer);
    setState(() {});
    Future.delayed(Duration(milliseconds: appRuntimeData.appConfigData.getMillisToWaitForNewQuest()),() => startNewQuestOrExit());
  }

  void storeAnswer(String actualAnswer) {
    widget.questData.actualAnswer = actualAnswer;
    bool answerOk = widget.questData.correctAnswer == actualAnswer;
    if (answerOk) widget.questOkCounter++;
    if (widget.isEndlessQuiz) {
      saveEndlessQuizResult(answerOk);
    } else {
      storeTrainingResult(answerOk, actualAnswer);
    }
  }

  void saveEndlessQuizResult(bool answerOk) {
    EndlessQuizProperties quizData = appRuntimeData.endlessQuizData;
    quizData = AssTraEndlessQuizView.updatedEndlessQuizData(quizData, answerOk);
    appRuntimeData.saveEndlessQuizData(quizData);
  }

  void storeTrainingResult(bool answerOk, String actualAnswer) {
    String key = widget.questData.questKey;
    if (widget.questData.directionReversed) {
      key = widget.questData.correctAnswer;
    }

    if ( ! widget.keysNumberCorrectlyAnsweredDirection.containsKey(key)) {
      bool value = widget.questData.directionReversed;
      widget.keysNumberCorrectlyAnsweredDirection.addEntries({key:value}.entries);
    }

    if (answerOk) {
      increaseNumberInMap(widget.keysNumberCorrectlyAnsweredInSequence, key);
      checkLearnSuccess(key);
    } else {
      increaseNumberInMap(widget.wrongAnswered, key);
      resetNumberCorrectAnsweredInSequence(key);
    }
  }


  void startNewQuestOrExit() {
    bool doneWithExecution = false;
    if (widget.isPlaying) {
      var removed = widget.keyValueActiveSubgroup.remove(widget.questData.questKey);
      removed ??= widget.keyValueActiveSubgroup.remove(widget.questData.correctAnswer);
      doneWithExecution = checkPlayingDone();
    } else {
      doneWithExecution = widget.keyValueActiveSubgroup.isEmpty && widget.keyValuePassiveSubgroup.isEmpty;
    }

    if (doneWithExecution) {
      navigateToResultPage();
    } else {
      bool ok = widget.fillUpActiveSubgroupIfNeeded();
      if (! ok) doneWithExecution = true;
          widget.questData = getNextQuestData();
      widget.countNewStateCallAsNewQuest = true;
      setState((){});
    }
  }

  QuestData getNextQuestData() {
    var index = widget.random.nextInt(widget.knowledgeFields.length);
    KnowledgeField knowledgeField = widget.knowledgeFields.elementAt(index);
    Map<String,String> allKeyValuePairs = {};
    allKeyValuePairs.addEntries(knowledgeField.keyValuePairs.entries);
    var activeKeyValuePairs = widget.keyValueActiveSubgroup;
    if (widget.isEndlessQuiz) activeKeyValuePairs = knowledgeField.keyValuePairs;
    List<String> questAnswers = List.empty(growable: true);

    String questKey = widget.keyInLastQuest;
    if (activeKeyValuePairs.length == 1) {
      index = 0;
      questKey = activeKeyValuePairs.keys.elementAt(index);
    } else {
      while (questKey == widget.keyInLastQuest || questKey.isEmpty) {
        index = widget.random.nextInt(activeKeyValuePairs.length);
        questKey = activeKeyValuePairs.keys.elementAt(index);
      }
    }

    bool reversedDirection = isDirectionReversed(knowledgeField.type, questKey);
    if (reversedDirection) {
      allKeyValuePairs = allKeyValuePairs.map( (k, v) => MapEntry(v, k) );
      questKey = knowledgeField.keyValuePairs[questKey]!;
    }

    String questCorrectValue = allKeyValuePairs[questKey]!;
    questAnswers.add(questCorrectValue);
    var numberOfWrongAnswersNeeded = appRuntimeData.appConfigData.getNumberOfAnswersInQuest()-1;
    String value = questCorrectValue;

    for (var i=0; i<numberOfWrongAnswersNeeded; i++) {
      while (questAnswers.contains(value)) {
        index = widget.random.nextInt(allKeyValuePairs.length);
        String key = allKeyValuePairs.keys.elementAt(index);
        value = allKeyValuePairs[key]!;
      }
      questAnswers.add(value);
    }

    String question = knowledgeField.getForwardQuestion(questKey);
    if (reversedDirection) question = knowledgeField.getBackwardQuestion(questKey);

    questAnswers.shuffle(widget.random);
    return QuestData(knowledgeField.getName(), question, questKey,
                     questAnswers, questCorrectValue, reversedDirection);
  }

  bool isDirectionReversed(String type, String key) {
    if (type == KnowledgeFieldType.oneWay.name) return false;
    if (widget.keysNumberCorrectlyAnsweredDirection.containsKey(key)) return widget.keysNumberCorrectlyAnsweredDirection[key] as bool;
    if (widget.execConfig.directionMode == DirectionMode.mixed) return widget.random.nextBool();
    return widget.execConfig.directionMode == DirectionMode.backwards;
  }

  bool checkPlayingDone() {
    PlayingConfig playingConfig = widget.execConfig as PlayingConfig;
    if (widget.isEndlessQuiz) {
      return false;
    } else if (playingConfig.playingMode == PlayingMode.race) {
      return widget.timerDuration.inSeconds == 0;
    } else {
      return widget.questCounter >= playingConfig.duration;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    var durationInSeconds = (widget.execConfig as PlayingConfig).duration * 60;
    widget.timerDuration = Duration(seconds: durationInSeconds);
    widget.countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {setCountDown();});
  }

  setCountDown() {
    int secsToGo = widget.timerDuration.inSeconds;
    if (secsToGo == 0) {
      setState(() {
        widget.countdownTimer.cancel();
      });
    } else {
      setState(() {
        secsToGo--;
        widget.timerDuration = Duration(seconds: secsToGo);
      });
    }
  }

  onPressStop() {
    navigateToResultPage();
  }

  void increaseNumberInMap(Map<String, int> map, String key) {
    if (map.containsKey(key)) {
      int number = map[key] as int;
      number++;
      map.addEntries(({key:number}.entries));
    } else {
      map.addEntries(({key:1}.entries));
    }
  }

  void resetNumberCorrectAnsweredInSequence(String questKey) {
    if (widget.keysNumberCorrectlyAnsweredInSequence.containsKey(questKey)) {
      widget.keysNumberCorrectlyAnsweredInSequence.addEntries(({questKey:0}.entries));
    }
  }


  void checkLearnSuccess(String learnedAssociationKey) {
    int numberOfCorrectAnswersInSequence = widget.keysNumberCorrectlyAnsweredInSequence[learnedAssociationKey] as int;
/*
    print("-----------------");
    print(widget.questData.directionReversed);
    print(widget.questData);
    print(widget.keysNumberCorrectlyAnsweredInSequence);
    print(widget.keyValueActiveSubgroup);
    print("is " + numberOfCorrectAnswersInSequence.toString() + " == " + appRuntimeData.appConfigData.getNumberOfCorrectAnswersToJudgeLearned().toString());
    print("-----------------");
*/
    if (appRuntimeData.appConfigData.getNumberOfCorrectAnswersToJudgeLearned() == numberOfCorrectAnswersInSequence) {
      widget.learnedAssociationKeysThisSession.add(widget.questData.questKey);
      appRuntimeData.saveAssociationsLearned(widget.questData.knowledgeFieldName,
                                             widget.questData.directionReversed,
                                             learnedAssociationKey);
      widget.keyValueActiveSubgroup.remove(learnedAssociationKey);
      widget.keysNumberCorrectlyAnsweredInSequence.remove(learnedAssociationKey);
    }
  }

  AssTraExecResultView createDoneWithTrainingView() {
    ExecResult result = ExecResult(widget.execConfig, widget.knowledgeFields,
        0, widget.questCounter, widget.questOkCounter,
        getTotalAssNumber(), getLearnedAssNumber());

    return AssTraExecResultView(execResult: result);
  }

}
