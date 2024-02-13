import 'package:asstra/2.manage.knowledge.base/text.manage.knowledge.base.dart';
import 'package:asstra/common/utils/asstra.util.dialog.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/common/widgets/AssTraAppBar.dart';
import 'package:asstra/common/widgets/StringInput.dart';
import 'package:asstra/main.dart';
import 'package:asstra/text.main.dart';
import 'package:flutter/material.dart';

import '../1.library.train.and.play/texts/text.startdialog.dart';
import '../common/asstra.constants.dart';
import 'do.manage.knowledge.base.dart';

class AssTraViewKnowledgeFieldView extends StatefulWidget {
  final KnowledgeField knowledgeField;
  final List<String> associationsToDisplayTextFilter = List.empty(growable: true);
  final List<String> associationsToDisplay = List.empty(growable: true);
  bool isDeleteModeActive = false;
  bool isAddModeActive = false;
  bool isOkAllowed = false;
  String enteredKey = '';
  String enteredValue = '';
  bool forwardsButtonPressed = false;
  bool backwardsButtonPressed = false;

  AssTraViewKnowledgeFieldView(this.knowledgeField, {super.key}) {
    initAssociationsToDisplay();
  }

  void initAssociationsToDisplay() {
    for (int i = 0; i < knowledgeField.keyValuePairs.length; i++) {
      associationsToDisplay.add(knowledgeField.getAssociationAsString(i));
      associationsToDisplayTextFilter.add(knowledgeField.getAssociationAsString(i));
    }
  }

  @override
  State<AssTraViewKnowledgeFieldView> createState() => _AssTraViewKnowledgeFieldViewState();
}

class _AssTraViewKnowledgeFieldViewState extends State<AssTraViewKnowledgeFieldView>{
  _AssTraViewKnowledgeFieldViewState();

  var inputFieldKey = AsstraStringInput(name: '', initValue: '');
  var inputFieldValue = AsstraStringInput(name: '', initValue: '');

  @override
  Widget build(BuildContext context) {
    if (widget.isAddModeActive) {

      inputFieldKey = AsstraStringInput(name: 'Key', initValue: widget.enteredKey, onChanged: (value) => {checkOkAllowed()});
      inputFieldValue = AsstraStringInput(name: 'Value', initValue: widget.enteredValue, onChanged: (value) => {checkOkAllowed()});
      return Scaffold(
          appBar: AssTraAppBar(mainTitle: textMainAppTitle, subTitle: '', subTitleSubLine: '', withFlowControlIcon: false),
          body: Scaffold(
              appBar: AssTraAppBar(mainTitle: '', subTitle: textManageKnowledgeTitle, subTitleSubLine: textViewModifySubtitle, withFlowControlIcon: true),
              body: Column(children: [
                  const SizedBox(height: 20),
                  Center(child: AssTraStringUtil.markdownStringToSizedText22(textNewAssociation)),
                  Center(child: AssTraStringUtil.markdownStringToSizedText22('*${widget.knowledgeField.getName()}*')),
                  const SizedBox(height: 20),
                  inputFieldKey,
                  const SizedBox(height: 20),
                  inputFieldValue,
                  const SizedBox(height: 20),
                  Row(children: [
                    const Spacer(),
                    ElevatedButton(
                        onPressed: widget.isOkAllowed ? () => onPressOk(context) : null,
                        style: okButtonStyle,
                        child: const Text(textMainOkButtonText)
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () => onPressCancel(context),
                        style: cancelButtonStyle,
                        child: const Text(textMainCancelButtonText)
                    ),
                    const Spacer()
                  ])
              ])
          ));
    }

    bool hideResetButton = ! anythingLearned() || widget.forwardsButtonPressed || widget.backwardsButtonPressed || isTextFilterActive();
    bool showLearnNumber = widget.forwardsButtonPressed || widget.backwardsButtonPressed || isTextFilterActive();

    return Scaffold(
        appBar: AssTraAppBar(mainTitle: textMainAppTitle, subTitle: '', subTitleSubLine: '', withFlowControlIcon: false),
        body: Scaffold(
            appBar: AssTraAppBar(mainTitle: '', subTitle: textManageKnowledgeTitle, subTitleSubLine: textViewModifySubtitle, withFlowControlIcon: true),
            body: Column(children: [
              const SizedBox(height: 20),
              Center(child: AssTraStringUtil.markdownStringToSizedText22('*${widget.knowledgeField.getName()}*')),
              Center(child: AssTraStringUtil.markdownStringToSizedText22('(${widget.knowledgeField.keyValuePairs.length.toString()} associations)')),
              const SizedBox(height: 20),
              Row(children: [
                const SizedBox(width: 10), const Icon(searchIcon, size: 44), const SizedBox(width: 10),
                Expanded(child: AsstraStringInput(name: textKeyOrValue, initValue: '', onChanged: (value) => {applyTextFilter(value, context)})),
                const SizedBox(width: 10),
                Visibility(visible: ! widget.isDeleteModeActive, child: IconButton(icon: const Icon(addIcon, size: 44), onPressed: () => { onAddNewPressed(context) })),
                Visibility(visible: widget.isDeleteModeActive, child: IconButton(icon: const Icon(deleteIcon, size: 44), onPressed: () => { onDeletePressed(context) })),
              ],),
              const SizedBox(height: 20),
              Align(alignment: Alignment.centerLeft, child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(children: [
                    const SizedBox(width: 10), const Icon(collegeHatIcon, size: 44), const SizedBox(width: 15),
                    ElevatedButton(onPressed: () { applyLearnedFilter(textStartdialogForwards); },
                        style: widget.forwardsButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                        child: const Text(textStartdialogForwards)),
                    const SizedBox(width: 15),
                    ElevatedButton(onPressed: () { applyLearnedFilter(textStartdialogBackwards); },
                        style: widget.backwardsButtonPressed ? pressedButtonStyle : neutralButtonStyle,
                        child: const Text(textStartdialogBackwards)),
                    const SizedBox(width: 15),
                    Visibility(visible:showLearnNumber, child: AssTraStringUtil.markdownStringToSizedText18(getNumberLearnedAssociationsString())),
                    Visibility(visible: ! hideResetButton, child:  ElevatedButton(onPressed: () { resetLearnedResults(); },
                               style: okButtonStyle, child: const Text(textStartdialogReset)))
                  ],))),
              const SizedBox(height: 20),
              Expanded(child: ListView.builder(
                  itemCount: widget.associationsToDisplay.length,
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
                        child: createListRowCenter(widget.associationsToDisplay.elementAt(index))
                    );
                  }
              )),
            ])
        ));
  }

  bool anythingLearned() {
    List<String>? forwardsLearned = appRuntimeData.associationsLearned.forwardsLearned[widget.knowledgeField.getName()];
    if (forwardsLearned != null && forwardsLearned.isNotEmpty) {
      return true;
    }
    List<String>? backwardsLearned = appRuntimeData.associationsLearned.backwardsLearned[widget.knowledgeField.getName()];
    if (backwardsLearned != null && backwardsLearned.isNotEmpty) {
      return true;
    }
    return false;
  }

  void applyLearnedFilter(String type) {
    if (type == textStartdialogForwards) {
      widget.forwardsButtonPressed = ! widget.forwardsButtonPressed;
    } else {
      widget.backwardsButtonPressed = ! widget.backwardsButtonPressed;
    }
    filterForwardsBackwards();
  }

  void filterForwardsBackwards() {
    List<String> toRemove = List.empty(growable: true);
    widget.associationsToDisplay.clear();
    for (var element in widget.associationsToDisplayTextFilter) {widget.associationsToDisplay.add(element);}
    List<String>? forwardsLearned = appRuntimeData.associationsLearned.forwardsLearned[widget.knowledgeField.getName()];
    List<String>? backwardsLearned = appRuntimeData.associationsLearned.backwardsLearned[widget.knowledgeField.getName()];

    if (widget.forwardsButtonPressed && !widget.backwardsButtonPressed) {
        filterElementsToDisplay(widget.associationsToDisplay, forwardsLearned, toRemove);
    }

    if ( ! widget.forwardsButtonPressed && widget.backwardsButtonPressed) {
      filterElementsToDisplay(widget.associationsToDisplay, backwardsLearned, toRemove);
    }

    if (widget.forwardsButtonPressed && widget.backwardsButtonPressed) {
      List<String> learned = List.empty(growable: true);
      if (forwardsLearned != null) learned.addAll(forwardsLearned);
      if (backwardsLearned != null) {
        backwardsLearned.where((element) => ! learned.contains(element))
                        .forEach((element) {learned.add(element);});
      }
      filterElementsToDisplay(widget.associationsToDisplay, learned, toRemove);
    }

    for (var element in toRemove) {widget.associationsToDisplay.remove(element);}
    setState(() {});
  }


  void filterElementsToDisplay(
      List<String> displayCandidates,
      List<String>? filterCriteria,
      List<String> toRemove)
  {
    if (filterCriteria == null) {
      for (var e in displayCandidates) {toRemove.add(e);}
    } else {
      for (var element in displayCandidates) {
        String key = keyFromAssociation(element);
        if (! filterCriteria.contains(key) && ! toRemove.contains(element)) {
          toRemove.add(element);
        }
      }
    }
  }

  String keyFromAssociation(String element) => element.split("-")[0].trim();

  void applyTextFilter(String text, BuildContext context) {
    widget.associationsToDisplay.clear();
    widget.associationsToDisplayTextFilter.clear();

    if (text.isEmpty) {
      widget.initAssociationsToDisplay();
      widget.isDeleteModeActive = false;
    } else {
      var splitResult = text.split(" - ");
      var keyMatches = widget.knowledgeField.getKeyMatches(splitResult.elementAt(0));
      var valueMatches = widget.knowledgeField.getValueMatches(splitResult.elementAt(0));
      widget.associationsToDisplay.addAll(keyMatches);
      valueMatches.where((element) => ! widget.associationsToDisplay.contains(element))
                  .forEach((element) { widget.associationsToDisplay.add(element); });
      widget.isDeleteModeActive = widget.associationsToDisplay.length == 1;

      for (var element in widget.associationsToDisplay) { widget.associationsToDisplayTextFilter.add(element);}
    }

    filterForwardsBackwards();
    setState(() {});
  }

  void onAddNewPressed(BuildContext context) {
    widget.isAddModeActive = true;
    widget.enteredKey = '';
    widget.enteredValue = '';
    setState(() {});
  }

  void onDeletePressed(BuildContext context) {
    if (appRuntimeData.appConfigData.getNumberOfAnswersInQuest() == widget.knowledgeField.keyValuePairs.length-1) {
      AssTraDialogUtil.showProblemBox(context, textDeleteProblemDialogTitle, textDeleteProblemDialogMessage);
      return;
    }
    String toDelete = widget.associationsToDisplay.elementAt(0);
    AssTraDialogUtil.showDecisionBox(context, textDeleteQuestionDialogTitle, 'Association: *$toDelete*')
                    .then((ok) {
                      if (ok) {
                        widget.knowledgeField.deleteKeyValuePair(widget.associationsToDisplay.elementAt(0));
                        appRuntimeData.saveKnowledgeField(widget.knowledgeField);
                        String keyToDelete = toDelete.split("-").elementAt(0).trim();
                        appRuntimeData.deleteAssociationLearned(widget.knowledgeField.getName(), keyToDelete);
                        widget.associationsToDisplay.remove(toDelete);
                        setState(() {});
                      }
                    });
  }

  onPressOk(BuildContext context) {
    String enteredKey = inputFieldKey.getValue();
    var keyExists = widget.knowledgeField.doesKeyExist(enteredKey);
    if (keyExists) {
      String? oldValue = widget.knowledgeField.keyValuePairs[enteredKey];
      AssTraDialogUtil.showDecisionBox(context, textOverwriteQuestionDialogTitle, textOverwriteQuestionDialogMessage.replaceFirst('<XY>', '$enteredKey - $oldValue'))
                      .then((ok) { if (ok) {onPressAdd2(context);} });
      return;
    }
    onPressAdd2(context);
  }

  void onPressAdd2(BuildContext context) {
    String enteredValue = inputFieldValue.getValue();
    var valueExists = widget.knowledgeField.doesValueExist(enteredValue);
    if (widget.knowledgeField.type == KnowledgeFieldType.twoWay && valueExists) {
      AssTraDialogUtil.showProblemBox(context, textInvalidValueProblemDialogTitle, textInvalidValueProblemDialogMessage.replaceFirst('<XY>', enteredValue));
      return;
    }
    widget.knowledgeField.addKeyValuePairAsFirst(inputFieldKey.value, inputFieldValue.value);
    appRuntimeData.saveKnowledgeField(widget.knowledgeField);
    widget.associationsToDisplay.clear();
    widget.initAssociationsToDisplay();
    widget.isAddModeActive = false;
    setState(() {});
  }

  onPressCancel(BuildContext context) {
    inputFieldKey.value = '';
    inputFieldValue.value = '';
    widget.isAddModeActive = false;
    setState(() {});
  }

  checkOkAllowed() {
    widget.enteredKey = inputFieldKey.getValue();
    widget.enteredValue = inputFieldValue.getValue();
    widget.isOkAllowed = widget.enteredKey.isNotEmpty && widget.enteredValue.isNotEmpty;
    setState(() {});
  }

  void resetLearnedResults() {
    bool b1 = widget.forwardsButtonPressed;
    bool b2 = widget.backwardsButtonPressed;
    widget.forwardsButtonPressed = true;
    int num = getNumberOfLearningSuccesses();
    widget.forwardsButtonPressed = false;
    widget.backwardsButtonPressed = true;
    num = num + getNumberOfLearningSuccesses();
    widget.forwardsButtonPressed = b1;
    widget.backwardsButtonPressed = b2;

    AssTraDialogUtil.showDecisionBox(context, textResetQuestionDialogTitle,
        textResetQuestionDialogText.replaceFirst("<X>", num.toString()))
        .then((ok) {
      if (ok) {
        appRuntimeData.deleteAllAssociationsLearned(widget.knowledgeField.getName());
        setState(() {
        });
      }
    });


  }

  String getNumberLearnedAssociationsString() {
    if (isTextFilterActive()) {
      return "";  // no info here
    }
    return "# *${getNumberOfLearningSuccesses()}*";
  }

  int getNumberOfLearningSuccesses() {
    List<String> learned = List.empty(growable: true);
    if (widget.forwardsButtonPressed) {
      var forwardsLearned = appRuntimeData.associationsLearned.forwardsLearned[widget.knowledgeField.getName()];
      if (forwardsLearned != null) learned.addAll(forwardsLearned);
      if (widget.backwardsButtonPressed) {
        var backwardsLearned = appRuntimeData.associationsLearned.backwardsLearned[widget.knowledgeField.getName()];
        if (backwardsLearned != null) {
          backwardsLearned.where((element) => ! learned.contains(element)).forEach((element) {learned.add(element);});
        }
      }
    } else {
      if (widget.backwardsButtonPressed) {
        var backwardsLearned = appRuntimeData.associationsLearned.backwardsLearned[widget.knowledgeField.getName()];
        if (backwardsLearned != null) learned.addAll(backwardsLearned);
      }
    }
    return learned.length;
  }

  bool isTextFilterActive() {
    return widget.associationsToDisplayTextFilter.length != widget.knowledgeField.keyValuePairs.length;
  }

  Row createListRowCenter(String association) {
    String learnedForward = " ";
    String learnedBackward = " ";
    String key = association.split("-").elementAt(0).trim();
    List<String>? forwardsLearned = appRuntimeData.associationsLearned.forwardsLearned[widget.knowledgeField.getName()];
    if (forwardsLearned != null && forwardsLearned.contains(key)) {
      learnedForward = "F ";
    }
    List<String>? backwardsLearned = appRuntimeData.associationsLearned.backwardsLearned[widget.knowledgeField.getName()];
    if (backwardsLearned != null && backwardsLearned.contains(key)) {
      learnedBackward = " B";
    }

    return Row(children: [
      Text(learnedBackward),
      const Spacer(),
      Text(association, style: standardTextStyle),
      const Spacer(),
      Text(learnedForward)
    ]);
  }

}
