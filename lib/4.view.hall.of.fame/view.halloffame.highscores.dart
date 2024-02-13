import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:asstra/4.view.hall.of.fame/text.halloffame.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.dialog.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/common/widgets/AssTraAppBar.dart';
import 'package:asstra/text.main.dart';
import 'package:flutter/material.dart';
import 'package:asstra/main.dart';

import 'do.halloffame.dart';


class AssTraHallOfFameHighScoreView extends StatelessWidget {
  final String highScoreListName;
  final bool withBackButton;
  static const List<Color> colors = [Color.fromRGBO(221, 0, 0, 100),
                                     Colors.orange,
                                     Color.fromRGBO(255, 170, 0, 100),
                                     Colors.yellow,
                                     Color.fromRGBO(238, 255, 65, 100),
                                     Color.fromRGBO(198, 255, 0, 100),
                                     Color.fromRGBO(100, 255, 0, 100),
                                     Color.fromRGBO(120, 255, 190, 100),
                                     Color.fromRGBO(0, 229, 255, 100),
                                     Color.fromRGBO(0, 114, 255, 100)];

  const AssTraHallOfFameHighScoreView( {required this.highScoreListName,
                                        required this.withBackButton,
                                        super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AssTraAppBar(mainTitle: textMainAppTitle, subTitle: '', subTitleSubLine: '', withFlowControlIcon: false),
        body: Center(child: getInternalScaffoldShowList(context))
    );
  }

  Scaffold getInternalScaffoldShowList(BuildContext context) {

    List<HallOfFameEntry>? highScoreList = appRuntimeData.appHallOfFameData[highScoreListName];

    if (highScoreList == null || highScoreList.isEmpty) {
      return Scaffold(
          appBar: AssTraAppBar(mainTitle: '', subTitle: textHallOfFameTitle, subTitleSubLine: highScoreListName, withFlowControlIcon: withBackButton),
          body: Container(
              alignment: Alignment.center,
              child: const Text(textHalloOfFameNoEntryYet, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
          ));
    }

    return Scaffold(
        appBar: AssTraAppBar(mainTitle: '', subTitle: textHallOfFameTitle, subTitleSubLine: highScoreListName, withFlowControlIcon: withBackButton),
        body: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                Table(
                  border: const TableBorder(),
                  columnWidths: const <int, TableColumnWidth>{
                    0: FixedColumnWidth(80),
                    1: IntrinsicColumnWidth(),
                    2: FlexColumnWidth()
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: createTableRows(highScoreList, context)
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.topCenter,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ColorizeAnimatedText(textHallOfFameCongratsText, textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32), colors: colors, speed: const Duration(milliseconds: 2000))
                    ],
                    isRepeatingAnimation: true,
                    repeatForever: true,
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed:() => onPressStart(context),
                      style: okButtonStyle,
                      child: const Text(textMainOkButtonText)
                  )
                ),
                const SizedBox(height: 20)
              ]
          )
        )
    );
  }

  List<TableRow> createTableRows(List<HallOfFameEntry> highScoreList, BuildContext context) {
    highScoreList = HallOfFameEntry.sort(highScoreList);
    List<TableRow> toReturn = List.empty(growable: true);
    toReturn.add(createHeaderRow(Theme.of(context).colorScheme.tertiary));
    double height = MediaQuery.of(context).size.height / 15;

    for (var i = 0; i < highScoreList.length; i++) {
      toReturn.add(createTableRow(highScoreList.elementAt(i), (i+1), colors.elementAt(i), context, height));
    }
    return toReturn;
  }

  TableRow createHeaderRow(Color bkColor) {
    return TableRow(
        children: <Widget>[
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                  alignment: Alignment.center,
                  color: bkColor,
                  child: AssTraStringUtil.markdownStringToSizedText22('Place')
              )
          ),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                  alignment: Alignment.center,
                  color: bkColor,
                  child: AssTraStringUtil.markdownStringToSizedText22('Score')
              )
          ),
          TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                  alignment: Alignment.center,
                  color: bkColor,
                  child: AssTraStringUtil.markdownStringToSizedText22('Name')
              )
          ),
        ]
    );
  }

  TableRow createTableRow(HallOfFameEntry hallOfFameEntry, int place, Color bkColor, BuildContext context, double height) {

    return TableRow(
        children: <Widget>[
          SizedBox(
              height: height,
              child: InkWell(
                  onTap: () {
                    showDetail(hallOfFameEntry, bkColor, place, context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: bkColor,
                    child: AssTraStringUtil.markdownStringToSizedText18('*$place*')
                )
              )
          ),
          SizedBox(
              height: height,
              child: InkWell(
                  onTap: () {
                    showDetail(hallOfFameEntry, bkColor, place, context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: bkColor,
                    child: AssTraStringUtil.markdownStringToSizedText18('*${hallOfFameEntry.numberOfOkQuestInSequence}*')
                )
              )
          ),
          SizedBox(
              height: height,
              child: InkWell(
                  onTap: () {
                    showDetail(hallOfFameEntry, bkColor, place, context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    color: bkColor,
                    child: AssTraStringUtil.markdownStringToSizedText18('*${hallOfFameEntry.name}*')
                )
              )
          ),
        ]
    );
  }

  onPressStart(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => appMainPage.getDefaultPage())
    );
  }

  void showDetail(HallOfFameEntry hallOfFameEntry, Color bkColor, int place, BuildContext context) {
    String text = detailsText.replaceFirst('<name>', hallOfFameEntry.name)
        .replaceFirst('<place>', place.toString())
        .replaceFirst('<numberOfOkQuestInSequence>', hallOfFameEntry.numberOfOkQuestInSequence.toString())
        .replaceFirst('<date>', hallOfFameEntry.timestamp)
        .replaceFirst('<duration>', AssTraStringUtil.millisToDurationString(hallOfFameEntry.millisNeeded))
        .replaceFirst('<direction>', hallOfFameEntry.direction);
    AssTraDialogUtil.showInfoBox(context, textHallOfFameTitle, text);
  }

}