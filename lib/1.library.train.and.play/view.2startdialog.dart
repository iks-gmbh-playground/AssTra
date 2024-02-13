import 'package:asstra/1.library.train.and.play/texts/text.startdialog.dart';
import 'package:asstra/1.library.train.and.play/view.3execution.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.dialog.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/common/widgets/IntegerInput.dart';
import 'package:asstra/main.dart';
import 'package:asstra/text.main.dart';
import 'package:flutter/material.dart';

import '../2.manage.knowledge.base/do.manage.knowledge.base.dart';
import '../common/widgets/AssTraAppBar.dart';
import 'do.train_and_play.dart';

class AssTraStartDialog extends StatefulWidget {
  final List<KnowledgeField> knowledgeFields;
  var trainingButtonPressed = false;
  var playingButtonPressed = false;
  var forwardButtonPressed = true;
  var backwardButtonPressed = false;
  var mixedButtonPressed = false;
  var muchButtonPressed = false;
  var someButtonPressed = true;
  var littleButtonPressed = false;
  var matchButtonPressed = true;
  var raceButtonPressed = false;
  var choicesComplete = false;

  AssTraStartDialog( {required this.knowledgeFields,super.key}) {
    choicesComplete = isAreaMode();
    playingButtonPressed = isAreaMode();
    matchButtonPressed = isAreaMode();
  }

  @override
  State<AssTraStartDialog> createState() => _AssTraStartDialogState();

  bool isAreaMode() {
    return knowledgeFields.length > 1;
  }
}

class _AssTraStartDialogState extends State<AssTraStartDialog>{
  _AssTraStartDialogState();

  IntegerInput inputIntegerMinutesInRace = IntegerInput(magnitude: 1, initValue: 1, buttonColor: Colors.black, minValue: 0, maxValue: 1);
  IntegerInput inputIntegerQuestsInMatch = IntegerInput(magnitude: 1, initValue: 1, buttonColor: Colors.black, minValue: 0, maxValue: 1);

  @override
  Widget build(BuildContext context) {
    inputIntegerMinutesInRace = IntegerInput(initValue: appRuntimeData.lastValueSetting.getLastNumberOfMinutesToPlayInRace(),
                                             magnitude: 2, buttonColor: Theme.of(context).colorScheme.secondary, minValue: 1, maxValue: maxMinutesToPlayAllowed);
    inputIntegerQuestsInMatch = IntegerInput(initValue: appRuntimeData.lastValueSetting.getLastNumberOfQuestsToPlayInMatch(),
                                             magnitude: 3, buttonColor: Theme.of(context).colorScheme.secondary, minValue: 1, maxValue: maxQuestToPlayAllowed);

    return Scaffold(
        appBar: AssTraAppBar(mainTitle: textMainAppTitle, subTitle: '', subTitleSubLine: '', withFlowControlIcon: true),
        body: getInternalScaffold()
    );
  }

  Scaffold getInternalScaffold() {
    String subTitle = widget.knowledgeFields.elementAt(0).getName();
    bool isTwoWay = widget.knowledgeFields.elementAt(0).type == KnowledgeFieldType.twoWay.name;

    if (widget.isAreaMode()) {
      subTitle = widget.knowledgeFields.elementAt(0).knowledgeArea;
      isTwoWay = ! doesAreaContainOneWayField();
    }

    String currentKnowledgeText = textStartdialogInfoCurrentKnowledge.replaceFirst('x1', appRuntimeData.appConfigData.getNumberOfSubgroupsForMuchKnowledge().toString())
                                                          .replaceFirst('x2', appRuntimeData.appConfigData.getNumberOfSubgroupsForSomeKnowledge().toString())
                                                          .replaceFirst('x3', appRuntimeData.appConfigData.getNumberOfSubgroupsForLittleKnowledge().toString());
    return Scaffold(
        appBar: AssTraAppBar(mainTitle: '', subTitle: subTitle, subTitleSubLine: textStartdialogStartButton, withFlowControlIcon: false),
        body: Align(
          alignment: Alignment.topLeft,
          child: Padding(padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(child: Column(
                children: <Widget>[
                    Visibility(visible: ! widget.isAreaMode(), child: Row(children: <Widget>[
                      // first choice
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text(textStartdialogStartModeQuestion, style: standardTextStyle)
                      ),
                      IconButton(onPressed: () => AssTraDialogUtil.showInfoBox(context, textStartdialogStartModeText, textStartdialogInfoStartMode),
                          icon: const Icon(infoIcon, color: infoIconColor))
                  ])),

                  Visibility(visible: ! widget.isAreaMode(), child: Row (
                      children: <Widget>[
                        ElevatedButton(
                            onPressed: () { onPressStartMode(StartMode.training.name); },
                            style: widget.trainingButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                            child: Text(StartMode.training.displayValue)),
                        const SizedBox(width: 50),
                        ElevatedButton(
                            onPressed: () { onPressStartMode(StartMode.playing.name); },
                            style: widget.playingButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                            child: Text(StartMode.playing.displayValue)),
                      ]
                  )),

                  // second choice
                  Visibility(visible: isTwoWay ? true : false, child: const SizedBox(height: 30)),
                  Visibility(visible: isTwoWay ? true : false, child: Row( children: <Widget>[
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(textStartdialogDirectionQuestion, style: standardTextStyle)
                    ),
                    IconButton(onPressed: () => AssTraDialogUtil.showInfoBox(context, textStartdialogDirectionText, textStartdialogInfoDirectionTypes),
                        icon: const Icon(infoIcon, color: infoIconColor))
                  ])),
                  Visibility(visible: isTwoWay ? true : false, child: const SizedBox(height: 10)),
                  Visibility(visible: isTwoWay ? true : false, child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row (
                      children: <Widget>[
                        ElevatedButton(onPressed: () { onPressDirectionMode(DirectionMode.forwards.name); },
                            style: widget.forwardButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                            child: Text(DirectionMode.forwards.displayValue)),
                        const SizedBox(width: 25),
                        ElevatedButton(onPressed: () { onPressDirectionMode(DirectionMode.backwards.name); },
                            style: widget.backwardButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                            child: Text(DirectionMode.backwards.displayValue)),
                        const SizedBox(width: 25),
                        ElevatedButton(onPressed: () { onPressDirectionMode(DirectionMode.mixed.name); },
                            style: widget.mixedButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                            child: Text(DirectionMode.mixed.displayValue)),
                      ]
                  ))),

                  // third choice a
                  Visibility(visible: widget.trainingButtonPressed ? true : false, child: const SizedBox(height: 30)),
                  Visibility(visible: widget.trainingButtonPressed ? true : false, child: Row( children: <Widget>[
                    const Align(
                        alignment: Alignment.topLeft,
                        child: Text(textStartdialogKnowledgeQuestion, overflow: TextOverflow.ellipsis, style: standardTextStyle)
                    ),
                    IconButton(onPressed: () => AssTraDialogUtil.showInfoBox(context, textStartdialogKnowledgeText, currentKnowledgeText),
                        icon: const Icon(infoIcon, color: infoIconColor))
                  ])),
                  Visibility(visible: widget.trainingButtonPressed ? true : false, child: const SizedBox(height: 10)),
                  Visibility(visible: widget.trainingButtonPressed ? true : false, child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row (
                        children: <Widget>[
                          ElevatedButton(onPressed: () { onPressTrainingMode(TrainingMode.muchKnowledge.name); },
                              style: widget.muchButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                              child: Text(TrainingMode.muchKnowledge.displayValue)),
                          const SizedBox(width: 25),
                          ElevatedButton(onPressed: () { onPressTrainingMode(TrainingMode.someKnowledge.name); },
                              style: widget.someButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                              child: Text(TrainingMode.someKnowledge.displayValue)),
                          const SizedBox(width: 25),
                          ElevatedButton(onPressed: () { onPressTrainingMode(TrainingMode.littleToNoKnowledge.name); },
                              style: widget.littleButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                              child: Text(TrainingMode.littleToNoKnowledge.displayValue)),
                        ]
                  ))),

                  // third choice b
                  Visibility(visible: showGameChoice(), child: const SizedBox(height: 30)),
                  Visibility(visible: showGameChoice(), child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(children: <Widget>[const Text(textStartdialogGameTypeQuestion, style: standardTextStyle),
                        IconButton(onPressed: () => AssTraDialogUtil.showInfoBox(context, textStartdialogGameTypeText, textStartdialogInfoGameType),
                            icon: const Icon(infoIcon, color: infoIconColor))
                      ])
                  )),
                  Visibility(visible: showGameChoice(), child: const SizedBox(height: 10)),
                  Visibility(visible: showGameChoice(), child: Row (
                      children: <Widget>[
                        ElevatedButton(onPressed: () { onPressPlayingMode(PlayingMode.match.name); },
                            style: widget.matchButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                            child: Text(PlayingMode.match.displayValue)),
                        const SizedBox(width: 25),
                        ElevatedButton(onPressed: () { onPressPlayingMode(PlayingMode.race.name); },
                            style: widget.raceButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                            child: Text(PlayingMode.race.displayValue)),
                      ]
                  )),

                  // fourth choice a
                  Visibility(visible: widget.matchButtonPressed && widget.playingButtonPressed ? true : false, child: const SizedBox(height: 30)),
                  Visibility(visible: widget.matchButtonPressed && widget.playingButtonPressed ? true : false,
                             child: const Align(
                                alignment: Alignment.topLeft,
                                child: Text(textStartdialogQuestNumberQuestions, style: standardTextStyle)
                             )
                  ),
                  Visibility(visible: widget.matchButtonPressed && widget.playingButtonPressed ? true : false,
                             child: const SizedBox(height: 10)
                  ),
                  Visibility(visible: widget.matchButtonPressed && widget.playingButtonPressed ? true : false,
                             child: inputIntegerQuestsInMatch
                  ),

                  // fourth choice b
                  Visibility(visible: widget.raceButtonPressed && widget.playingButtonPressed ? true : false, child: const SizedBox(height: 30)),
                  Visibility(visible: widget.raceButtonPressed && widget.playingButtonPressed ? true : false,
                      child: const Align(
                          alignment: Alignment.topLeft,
                          child: Text(textStartdialogMinutesNumberQuestions, style: standardTextStyle)
                      )
                  ),
                  Visibility(visible: widget.raceButtonPressed && widget.playingButtonPressed ? true : false,
                      child: const SizedBox(height: 10)
                  ),
                  Visibility(visible: widget.raceButtonPressed && widget.playingButtonPressed ? true : false,
                      child: inputIntegerMinutesInRace
                  ),

                  // Bottom Line
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(onPressed: widget.choicesComplete ? () => onPressStart() : null,
                        style: okButtonStyle,
                        child: const Text(textStartdialogStartButton)
                    ),
                  )
                ]
            )),
          ),
        )
    );
  }

  bool showGameChoice() => widget.playingButtonPressed || widget.isAreaMode() ? true : false;

  void onPressStartMode(String buttonName) {
    if (buttonName == StartMode.training.name) {
      widget.trainingButtonPressed = ! widget.trainingButtonPressed;
      if (widget.playingButtonPressed) widget.playingButtonPressed = false;
    }
    if (buttonName == StartMode.playing.name) {
      widget.playingButtonPressed = ! widget.playingButtonPressed;
      if (widget.trainingButtonPressed) widget.trainingButtonPressed = false;
    }
    setState(() {});
    widget.choicesComplete = areChoicesComplete();
  }

  void onPressDirectionMode(String buttonName) {
    if (buttonName == DirectionMode.forwards.name) {
      widget.forwardButtonPressed = ! widget.forwardButtonPressed;
      if (widget.forwardButtonPressed) {
        widget.backwardButtonPressed = false;
        widget.mixedButtonPressed = false;
      }
    }
    if (buttonName == DirectionMode.backwards.name) {
      widget.backwardButtonPressed = ! widget.backwardButtonPressed;
      if (widget.backwardButtonPressed) {
        widget.forwardButtonPressed = false;
        widget.mixedButtonPressed = false;
      }
    }
    if (buttonName == DirectionMode.mixed.name) {
      widget.mixedButtonPressed = ! widget.mixedButtonPressed;
      if (widget.mixedButtonPressed) {
        widget.forwardButtonPressed = false;
        widget.backwardButtonPressed = false;
      }
    }
    setState(() {});
    widget.choicesComplete = areChoicesComplete();
  }

  void onPressTrainingMode(String buttonName) {
    if (buttonName == TrainingMode.muchKnowledge.name) {
      widget.muchButtonPressed = ! widget.muchButtonPressed;
      if (widget.muchButtonPressed) {
        widget.someButtonPressed = false;
        widget.littleButtonPressed = false;
      }
    }
    if (buttonName == TrainingMode.someKnowledge.name) {
      widget.someButtonPressed = ! widget.someButtonPressed;
      if (widget.someButtonPressed) {
        widget.muchButtonPressed = false;
        widget.littleButtonPressed = false;
      }
    }
    if (buttonName == TrainingMode.littleToNoKnowledge.name) {
      widget.littleButtonPressed = ! widget.littleButtonPressed;
      if (widget.littleButtonPressed) {
        widget.muchButtonPressed = false;
        widget.someButtonPressed = false;
      }
    }
    setState(() {});
    widget.choicesComplete = areChoicesComplete();
  }

  void onPressPlayingMode(String buttonName) {
    if (buttonName == PlayingMode.race.name) {
      widget.raceButtonPressed = ! widget.raceButtonPressed;
      if (widget.raceButtonPressed) widget.matchButtonPressed = false;
    }
    if (buttonName == PlayingMode.match.name) {
      widget.matchButtonPressed = ! widget.matchButtonPressed;
      if (widget.matchButtonPressed) widget.raceButtonPressed = false;
    }
    setState(() {});
    widget.choicesComplete = areChoicesComplete();
  }

  bool areChoicesComplete() {
    if (widget.isAreaMode()) return true;
    if (! widget.playingButtonPressed && ! widget.trainingButtonPressed) return false;
    if (widget.playingButtonPressed) {
      if (! widget.raceButtonPressed && ! widget.matchButtonPressed) return false;
    } else {
      if (! widget.muchButtonPressed && ! widget.someButtonPressed && ! widget.littleButtonPressed) return false;
    }

    if (! doesAreaContainOneWayField()) {
      if (! widget.forwardButtonPressed && ! widget.backwardButtonPressed && ! widget.mixedButtonPressed) return false;
    }
    return true;
  }

  void onPressStart() {
    ExecConfig execConfig;
    DirectionMode directionMode;

    if (widget.forwardButtonPressed) {
      directionMode = DirectionMode.forwards;
    } else if (widget.backwardButtonPressed) {
      directionMode = DirectionMode.backwards;
    } else {
      directionMode = DirectionMode.mixed;
    }

    if (widget.playingButtonPressed) {
      PlayingMode playingMode;
      int duration = -1;
      if (widget.matchButtonPressed) {
        playingMode = PlayingMode.match;
        duration = inputIntegerQuestsInMatch.getValue();
      } else {
        playingMode = PlayingMode.race;
        duration = inputIntegerMinutesInRace.getValue();
      }
      execConfig = PlayingConfig(directionMode, playingMode, duration);
    } else {
      TrainingMode trainingMode;
      if (widget.muchButtonPressed) {
        trainingMode = TrainingMode.muchKnowledge;
      } else if (widget.someButtonPressed) {
        trainingMode = TrainingMode.someKnowledge;
      } else {
        trainingMode = TrainingMode.littleToNoKnowledge;
      }
      execConfig = TrainingConfig(directionMode, trainingMode);
    }

    updateLastSettings();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssTraExecutionView(knowledgeFields: widget.knowledgeFields, execConfig: execConfig)),
    );
  }

  void updateLastUsageOrder() {
    if (widget.knowledgeFields.length == 1) {
      var knowledgeField = widget.knowledgeFields.elementAt(0);

      var list = appRuntimeData.lastValueSetting.getLastKnowledgeUsageOrderAsList();
      if (list.contains(knowledgeField.getName())) {
        list.remove(knowledgeField.getName());
      }
      String order = knowledgeField.getName() + toListSeparator + AssTraStringUtil.listToString(list, toListSeparator);
      appRuntimeData.lastValueSetting.setLastKnowledgeUsageOrder(order);
    }
  }

  bool doesAreaContainOneWayField() {
    return widget.knowledgeFields.map((kf) => kf.type).contains(KnowledgeFieldType.oneWay.name);
  }

  void updateLastSettings() {
    updateLastUsageOrder();
    appRuntimeData.lastValueSetting.setLastNumberOfMinutesToPlayInRace(inputIntegerMinutesInRace.getValue().toString());
    appRuntimeData.lastValueSetting.setLastNumberOfQuestsToPlayInMatch(inputIntegerQuestsInMatch.getValue().toString());
    appRuntimeData.saveLastValueSetting(appRuntimeData.lastValueSetting);
  }


}
