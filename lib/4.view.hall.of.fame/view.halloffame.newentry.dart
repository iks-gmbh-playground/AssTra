import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:asstra/4.view.hall.of.fame/text.halloffame.dart';
import 'package:asstra/4.view.hall.of.fame/view.halloffame.highscores.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/text.main.dart';
import 'package:asstra/common/widgets/StringInput.dart';
import 'package:flutter/material.dart';

import '../1.library.train.and.play/do.train_and_play.dart';
import '../common/widgets/AssTraAppBar.dart';
import '../main.dart';
import 'do.halloffame.dart';

class AssTraHallOfFameNewEntryView extends StatefulWidget {
  final ExecResult execResult;

  String newEntryFor = 'Me';
  bool navigateToHallOfFame = true;

  AssTraHallOfFameNewEntryView( {
    required this.execResult,
    super.key
  });

  @override
  State<AssTraHallOfFameNewEntryView> createState() => _AssTraHallOfFameNewEntryViewState();
}

class _AssTraHallOfFameNewEntryViewState extends State<AssTraHallOfFameNewEntryView> {
  _AssTraHallOfFameNewEntryViewState();

  @override
  Widget build(BuildContext context) {
    int place = 1 + HallOfFameEntry.findIndex(appRuntimeData.appHallOfFameData[getHallOfFameName()]!, widget.execResult.questsOk, widget.execResult.durationInMillis);

    return Scaffold(appBar: AssTraAppBar(mainTitle: textMainAppTitle, subTitle: '', subTitleSubLine: '', withFlowControlIcon: false),
                    body: Scaffold(
        appBar: AssTraAppBar(mainTitle: '', subTitle: textHallOfFameTitle, subTitleSubLine: getHallOfFameName(), withFlowControlIcon: false),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      WavyAnimatedText(textHallOfFameCongratsText, textStyle: animatedTextStyle),
                      ColorizeAnimatedText(textHallOfFameQualifiedText, textStyle: animatedTextStyle, colors: animatedColors)
                    ],
                    isRepeatingAnimation: false,
                  ),
              ),
              const SizedBox(height: 30),
              Align(
                  alignment: Alignment.topLeft,
                  child: AssTraStringUtil.markdownStringToSizedText22(textHallOfFameNewentryPlace.replaceFirst('XY', place.toString()))
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.topLeft,
                child: AssTraStringUtil.markdownStringToSizedText22(textHallOfFameNewentryScore.replaceFirst('XY', widget.execResult.questsOk.toString()))
              ),
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.topLeft,
                  child: AssTraStringUtil.markdownStringToSizedText22(textHallOfFameNewentryTimeNeeded.replaceFirst('XY', AssTraStringUtil.millisToDurationString(widget.execResult.durationInMillis)))
              ),
              const SizedBox(height: 40),
              AsstraStringInput(
                      name: textHallOfFameInputLabel,
                      initValue: widget.newEntryFor,
                      onChanged: (value) => onChanged(value)
              ),
              const SizedBox(height: 40),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed:() => onPressSkipHighScores(context),
                      style: widget.navigateToHallOfFame ?
                                    ElevatedButton.styleFrom(foregroundColor: Colors.black,
                                                             backgroundColor: Colors.grey) :
                                    ElevatedButton.styleFrom(foregroundColor: Colors.white,
                                               backgroundColor: Colors.orange),
                      child: const Text(textToHallOfFameToggleButtonText, style: TextStyle(fontSize: 18))
                  )
              ),
              const SizedBox(height: 20),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed:() => onPressOK(context),
                      style: Theme.of(context).textTheme.bodyLarge != null && widget.newEntryFor.isEmpty ? deactivatedButtonStyle : okButtonStyle,
                      child: const Text(textMainOkButtonText)
                  )
              )
            ],
          ),
        ))
    );
  }

  onPressOK(BuildContext context) {
    String newEntryName = getHallOfFameName();
    List<HallOfFameEntry>? currentHighscores = appRuntimeData.appHallOfFameData[newEntryName];
    if (currentHighscores == null) return;

    while (currentHighscores.length >= appRuntimeData.appConfigData.getNumberOfEntriesInHighscoreList()) {
      currentHighscores.remove(currentHighscores.elementAt(currentHighscores.length-1));
    }

    HallOfFameEntry newEntry = HallOfFameEntry(widget.execResult.questsOk, widget.newEntryFor, AssTraStringUtil.createTimestampAsString(), widget.execResult.durationInMillis, widget.execResult.execConfig.directionMode.name);
    currentHighscores.add(newEntry);
    appRuntimeData.saveHallOfFameHighscoreList(newEntryName, currentHighscores);

    if (widget.navigateToHallOfFame) {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AssTraHallOfFameHighScoreView(highScoreListName: newEntryName, withBackButton: false))
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => appMainPage.getDefaultPage())
      );
    }
  }

  onChanged(String value) {
    widget.newEntryFor = value;
    setState(() {});
  }

  onPressSkipHighScores(BuildContext context) {
    widget.navigateToHallOfFame = ! widget.navigateToHallOfFame;
    setState(() {});
  }

  String getHallOfFameName() {
    if (widget.execResult.knowledgeFields.length > 1) return widget.execResult.knowledgeFields.elementAt(0).knowledgeArea;
    return widget.execResult.knowledgeFields.elementAt(0).getName();
  }

}