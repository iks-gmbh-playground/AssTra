import 'package:asstra/4.view.hall.of.fame/text.halloffame.dart';
import 'package:asstra/4.view.hall.of.fame/view.halloffame.highscores.dart';
import 'package:asstra/4.view.hall.of.fame/view.halloffame.newentry.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/common/widgets/AssTraAppBar.dart';
import 'package:asstra/main.dart';
import 'package:flutter/material.dart';

import '../1.library.train.and.play/do.train_and_play.dart';
import '../common/widgets/StringInput.dart';
import '../text.main.dart';

/// Entry point for all subviews of this component
class AssTraHallOfFameView extends StatefulWidget {
  final String highScoreListName;
  final String newEntryFor;
  final ExecResult execResult;

  List<String> highScoreListList = List.empty(growable: true);
  List<String> currentDisplayList = List.empty(growable: true);


  AssTraHallOfFameView( {required this.highScoreListName,
                         required this.newEntryFor,
                         required this.execResult,
                         super.key}) {
    var fieldList = appRuntimeData.getAllKnowledgeFields().map((field) => field.getName()).toList(growable: true);
    highScoreListList.addAll(fieldList);
    highScoreListList.addAll(appRuntimeData.getKnowledgeAreas());
    AssTraStringUtil.abcSort(highScoreListList);
    currentDisplayList.addAll(highScoreListList);

  }

  @override
  State<AssTraHallOfFameView> createState() => _AssTraHallOfFameViewState();
}

class _AssTraHallOfFameViewState extends State<AssTraHallOfFameView> {
  _AssTraHallOfFameViewState();

  @override
  Widget build(BuildContext context) {
    Widget internalScaffhold;
    if (widget.highScoreListName != '') {
      if (widget.newEntryFor == '') {
        internalScaffhold = AssTraHallOfFameNewEntryView(execResult: widget.execResult);
      } else {
        internalScaffhold = AssTraHallOfFameHighScoreView(highScoreListName: widget.highScoreListName, withBackButton: true);
      }
    } else {
      internalScaffhold = getInternalScaffoldChooseKnowledgeField(context);
    }

    return Scaffold(
        body: Center(child: internalScaffhold)
    );
  }

  Scaffold getInternalScaffoldChooseKnowledgeField(BuildContext context) {

    bool showSearchField = widget.highScoreListList.length > appRuntimeData.appConfigData.getMinListSizeToShowSearchField();

    return Scaffold(
        appBar: AssTraAppBar(mainTitle: '', subTitle: textHallOfFameTitle, subTitleSubLine: '', withFlowControlIcon: true),
        body: Column(children: <Widget>[
          Visibility(visible: showSearchField, child: const SizedBox(height: 10)),
          Visibility(visible: showSearchField, child: Row(children: [
            const SizedBox(width: 5),
            const Icon(searchIcon, size: 44),
            const SizedBox(width: 5),
            Expanded(child: AsstraStringInput(name: textKeyOrValue, initValue: '', onChanged: (value) => {applySearchFilter(value, context)})),
            const SizedBox(width: 10),
          ])),
          Visibility(visible: showSearchField, child: const SizedBox(height: 10)),

          Expanded(child: Align(
              alignment: Alignment.topCenter,
              child: ListView.builder(
                  itemCount: widget.currentDisplayList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(220, 220, 220, 100),
                            border: Border.all(
                                color: Colors.purple,
                                width: 1
                            )
                        ),
                        child: InkWell(
                            onTap: () {
                              onChangedPressed(context, widget.currentDisplayList.elementAt(index));
                            },
                            splashColor: const Color.fromRGBO(0, 255, 0, 100),
                            radius: 25,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(child: Center(
                                    child: Text(widget.currentDisplayList.elementAt(index),
                                        overflow: TextOverflow.ellipsis,
                                        style: standardTextStyle))),
                              ],
                            )
                        )
                    );
                  }
              )
          ))
        ])
    );
  }

  void onChangedPressed(BuildContext context, String highScoreListName) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AssTraHallOfFameHighScoreView(highScoreListName: highScoreListName, withBackButton: true))
    );
  }

  applySearchFilter(value, BuildContext context) {
    widget.currentDisplayList.clear();
    if (value.trim().isEmpty) {
      widget.currentDisplayList.addAll(widget.highScoreListList);
    } else {
      var matches = widget.highScoreListList.where((e) => e.contains(value)).toList();
      widget.currentDisplayList.addAll(matches);
    }
    setState(() {});
  }

}