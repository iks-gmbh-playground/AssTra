import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:asstra/1.library.train.and.play/texts/text.resultview.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/text.main.dart';
import 'package:asstra/common/utils/asstra.util.dialog.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/common/widgets/FieldDisplay.dart';
import 'package:flutter/material.dart';
import 'package:asstra/main.dart';

import '../2.manage.knowledge.base/do.manage.knowledge.base.dart';
import '../4.view.hall.of.fame/do.halloffame.dart';
import '../4.view.hall.of.fame/view.halloffame.dart';
import '../common/widgets/AssTraAppBar.dart';
import 'do.train_and_play.dart';


class AssTraExecResultView extends StatelessWidget {
  static const nameWidth = 160.0;
  static const fieldHeight = 50.0;
  static const style = TextStyle(fontSize: 22);
  static const bkColor1 = Colors.white;
  static const bkColor2 = Color.fromRGBO(222, 222, 222, 100);

  final ExecResult execResult;

  const AssTraExecResultView( {required this.execResult, super.key});

  @override
  Widget build(BuildContext context) {
    Widget scaffold;
    if (isDoneWithTraining(execResult)) {
      scaffold = getInternalTrainingDoneScaffold(context, execResult);
    } else {
      scaffold = getInternalStandardScaffold(context, execResult);
    }

    return Scaffold(
        appBar: AssTraAppBar(mainTitle: textMainAppTitle, subTitle: '', subTitleSubLine: '', withFlowControlIcon: false),
        body: Center(
            child: scaffold
        )
    );
  }

  bool isDoneWithTraining(ExecResult execResult) {
    if (execResult.execConfig.startMode != StartMode.training) return false;
    KnowledgeField trainedKnowledgeField = execResult.knowledgeFields.elementAt(0);
    List<String>? learnedForwards = appRuntimeData.associationsLearned.forwardsLearned[trainedKnowledgeField.getName()];
    learnedForwards ??= List.empty();
    List<String>? learnedBackwards = appRuntimeData.associationsLearned.backwardsLearned[trainedKnowledgeField.getName()];
    learnedBackwards ??= List.empty();
    if (execResult.execConfig.directionMode == DirectionMode.forwards) {
      return learnedForwards.length == trainedKnowledgeField.keyValuePairs.length;
    }

    if (execResult.execConfig.directionMode == DirectionMode.backwards) {
      return learnedBackwards.length == trainedKnowledgeField.keyValuePairs.length;
    }

    List<String> learnedMixed = List.empty(growable: true);
    for (var e in learnedForwards) {
      learnedMixed.add(e);
    }
    learnedBackwards.where((e) => !learnedMixed.contains(e)).forEach((e) => learnedMixed.add(e));

    return learnedMixed.length == trainedKnowledgeField.keyValuePairs.length;
  }

  Widget getInternalTrainingDoneScaffold(BuildContext context, ExecResult execResult) {
    var knowledgeFieldName = execResult.knowledgeFields.elementAt(0).getName();
    String numForward = "0";
    List<String>? list = appRuntimeData.associationsLearned.forwardsLearned[knowledgeFieldName];
    if (list != null) numForward = list!.length.toString();
    String numBackward = "0";
    list = appRuntimeData.associationsLearned.backwardsLearned[knowledgeFieldName];
    if (list != null) numBackward = list!.length.toString();

    return Scaffold(
        appBar: AssTraAppBar(mainTitle: '', subTitle: textResultviewSubtitleLine2, subTitleSubLine: '', withFlowControlIcon: false),
        body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: <Widget>[
          AssTraStringUtil.markdownStringToSizedText22('Knowledge Field:'),
          AssTraStringUtil.markdownStringToSizedText22('*' + knowledgeFieldName + '*'),
          const SizedBox(height: 20),
          FieldDisplay(textResultviewFieldDisplayMode, buildModeString(execResult),
          style, nameWidth, fieldHeight, bkColor2, ''
          ),
          FieldDisplay(textResultviewFieldDirection, execResult.execConfig.directionMode.displayValue,
          style, nameWidth, fieldHeight, bkColor1, ''
          ),
          const FieldDisplay(textResultviewFieldTrained, ' ',
              style, nameWidth, fieldHeight, bkColor2, ''
          ),
          FieldDisplay(textResultviewFieldTrainedForward, numForward, style, nameWidth, fieldHeight, bkColor1, ''
          ),
          FieldDisplay(textResultviewFieldTrainedBackward, numBackward, style, nameWidth, fieldHeight, bkColor1, ''
          ),
          const SizedBox(height: 20),
          AssTraStringUtil.markdownStringToSizedText18("Great, your done with training! To continue training, reset your training result. To do so, see main menu *Manage Knowledge Base -> View/Modify*."),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed:() => onPressOK(context),
              style: okButtonStyle,
              child: const Text(textMainOkButtonText)
            )
          ),
          const SizedBox(height: 10)
        ]
      ))
    );

  }

  Widget getInternalStandardScaffold(BuildContext context, ExecResult execResult) {
    var score = execResult.questsDone == 0 ? '-' : getErrorRateAsString();

    return Scaffold(
        appBar: AssTraAppBar(mainTitle: '', subTitle: textResultviewSubtitleLine1, subTitleSubLine: '', withFlowControlIcon: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
              children: <Widget>[
                FieldDisplay(textResultviewFieldDisplayMode, buildModeString(execResult),
                             style, nameWidth, fieldHeight, bkColor2, ''
                ),
                FieldDisplay(textResultviewFieldDirection, execResult.execConfig.directionMode.displayValue,
                    style, nameWidth, fieldHeight, bkColor1, ''
                ),
                FieldDisplay(textResultviewFieldTimeSpent, AssTraStringUtil.millisToDurationString(execResult.durationInMillis),
                    style, nameWidth, fieldHeight, bkColor2, ''
                ),
                FieldDisplay(textResultviewFieldQuestsDone, execResult.questsDone.toString(),
                    style, nameWidth, fieldHeight, bkColor1, ''
                ),
                FieldDisplay(textResultviewFieldQuestsOK, execResult.questsOk.toString(),
                    style, nameWidth, fieldHeight, bkColor2, ''
                ),
                Visibility(visible: execResult.execConfig.startMode == StartMode.playing,
                           child: FieldDisplay(textResultviewFieldScore, score, style, nameWidth, fieldHeight, bkColor1, '')
                ),
                Visibility(visible: execResult.execConfig.startMode == StartMode.training,
                           child: FieldDisplay(textResultviewFieldAssTotal, execResult.associationsTotal.toString(),
                                               style, nameWidth, fieldHeight, bkColor1, '')
                ),
                Visibility(visible: execResult.execConfig.startMode == StartMode.training,
                           child: FieldDisplay(textResultviewFieldLearned, execResult.associationsLearned.toString(),
                                               style, nameWidth, fieldHeight, bkColor2, '')
                ),
                IconButton(onPressed: () => AssTraDialogUtil.showInfoBox(context, textResultviewInfoTextTitle, getInfoText(execResult.execConfig.startMode)),
                    icon: const Icon(infoIcon, color: infoIconColor)),

                const SizedBox(height: 20),
                Visibility(
                  visible: isNewHighscore(),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        WavyAnimatedText(textResultviewCongratsText, textStyle: animatedTextStyle),
                        ColorizeAnimatedText(textResultviewQualifiedText, textStyle: animatedTextStyle, colors: animatedColors)
                      ],
                      isRepeatingAnimation: true,
                      repeatForever: true,
                    )
                  )
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed:() => onPressOK(context),
                      style: okButtonStyle,
                      child: const Text(textMainOkButtonText)
                  )
                ),
                const SizedBox(height: 10)
              ]
          )
        )
    );
  }

  String buildModeString(ExecResult execResult) {
     if (execResult.execConfig.startMode == StartMode.playing) {
       PlayingConfig playingConfig = execResult.execConfig as PlayingConfig;
       return playingConfig.playingMode.displayValue;
       } else {
        return StartMode.training.displayValue;
     }
  }

  onPressOK(BuildContext context) {
    String highScoreListName = execResult.knowledgeFields.elementAt(0).getName();
    if (isAreaMode()) {
      highScoreListName = execResult.knowledgeFields.elementAt(0).knowledgeArea;
    }

    if (isNewHighscore()) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AssTraHallOfFameView(highScoreListName: highScoreListName,
                                                                       newEntryFor: '',
                                                                       execResult: execResult))
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => appMainPage.getDefaultPage())
      );
    }
  }

  bool isNewHighscore() {
    if (execResult.execConfig.startMode == StartMode.training) return false;
    String hallOfFameName = execResult.knowledgeFields.elementAt(0).getName();
    if (isAreaMode()) {
      hallOfFameName = execResult.knowledgeFields.elementAt(0).knowledgeArea;
    }
    if (getErrorRateAsString() != '0 %') return false;
    var pos = 1 + HallOfFameEntry.findIndex(appRuntimeData.appHallOfFameData[hallOfFameName]!, execResult.questsDone, execResult.durationInMillis);
    return appRuntimeData.appConfigData.getNumberOfEntriesInHighscoreList() > pos;
  }

  String getInfoText(StartMode startMode) {
    if (startMode == StartMode.playing) return textResultviewInfoTextContentPlaying;
    return infoTextContentTraining.replaceFirst('xx', appRuntimeData.appConfigData.getNumberOfCorrectAnswersToJudgeLearned().toString());
  }

  getErrorRateAsString() {
    double score = 100 - ((execResult.questsOk/execResult.questsDone)*100);
    String toReturn = score.toStringAsFixed(2);
    if (toReturn.endsWith('0')) toReturn = toReturn.substring(0, toReturn.length-1);
    if (toReturn.endsWith('0')) toReturn = toReturn.substring(0, toReturn.length-2);
    return '$toReturn %';
  }

  bool isAreaMode() {
    return execResult.knowledgeFields.length > 1;
  }

}