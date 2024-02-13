import 'package:asstra/2.manage.knowledge.base/text.manage.knowledge.base.dart';
import 'package:asstra/2.manage.knowledge.base/view.manage.overview.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.dialog.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/common/widgets/AssTraAppBar.dart';
import 'package:asstra/common/widgets/FieldDisplay.dart';
import 'package:asstra/common/widgets/StringInput.dart';
import 'package:asstra/main.dart';
import 'package:asstra/text.main.dart';
import 'package:flutter/material.dart';

import 'do.manage.knowledge.base.dart';

class AssTraImportView extends StatelessWidget {
  late KnowledgeField knowledgeField;
  late AsstraStringInput areaNameInput;
  late AsstraStringInput keyNameInput;
  late AsstraStringInput valueNameInput;
  late AsstraStringInput forwardQuestionInput;
  late AsstraStringInput backwardQuestionInput;

  AssTraImportView(this.knowledgeField, {super.key}) {
    setKnowledgeField(knowledgeField);
  }

  setKnowledgeField(KnowledgeField aKnowledgeField) {
    knowledgeField = aKnowledgeField;
    areaNameInput = AsstraStringInput(name: 'Key Name', initValue: knowledgeField.knowledgeArea);
    keyNameInput = AsstraStringInput(name: 'Key Name', initValue: knowledgeField.keyName);
    valueNameInput = AsstraStringInput(name: 'Value Name', initValue: knowledgeField.valueName);
    forwardQuestionInput = AsstraStringInput(name: 'Forwards Question', initValue: knowledgeField.questionTemplateForward);
    backwardQuestionInput = AsstraStringInput(name: 'Backwards Question', initValue: knowledgeField.questionTemplateBackwards);
  }

  @override
  Widget build(BuildContext context) {
    String errorText = checkErrorText();
    if (errorText.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            AssTraManageKnowledgeView(libraryData: appRuntimeData.knowledgeFields)));
      });
    }


    return Scaffold(
        appBar: AssTraAppBar(mainTitle: textMainAppTitle, subTitle: '', subTitleSubLine: '', withFlowControlIcon: false),
        body: Scaffold(
            appBar: AssTraAppBar(mainTitle: '', subTitle: textManageKnowledgeTitle, subTitleSubLine: textImportSubtitle, withFlowControlIcon: true),
            body: SingleChildScrollView(child: Column(children: [
              const SizedBox(height: 20),
              AssTraStringUtil.markdownStringToSizedText22("Check Import data:"),
              const SizedBox(height: 20),
              keyNameInput,
              const SizedBox(height: 20),
              valueNameInput,
              const SizedBox(height: 20),
              forwardQuestionInput,
              const SizedBox(height: 20),
              Visibility(
                visible: knowledgeField.questionTemplateBackwards.isNotEmpty,
                  child: backwardQuestionInput
              ),
              const SizedBox(height: 10),
              Row(children: [
                Expanded (flex: 80, child: FieldDisplay('Type:', knowledgeField.type, standardTextStyle, 170, 30, Colors.white10, '')),
                Expanded (flex: 20, child: Icon(knowledgeField.getIcon())),
                ]),
              const SizedBox(height: 20),
              FieldDisplay('# Associations:', knowledgeField.keyValuePairs.length.toString(), standardTextStyle, 170, 30, Colors.white10, ''),
              const SizedBox(height: 30),
              Visibility(
                visible: knowledgeField.validate() == ValidationResult.ok,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(onPressed: () => onPressOk(context),
                    style: okButtonStyle,
                    child: const Text(textMainOkButtonText)
                  ),
                )
              ),
              Visibility(
                  visible: errorText != '-',
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(errorText, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 22)
                  ),
                )
              ),
              const SizedBox(height: 20)
            ],)
            )
        ));
  }

  String checkErrorText() {
    if (knowledgeField.keyValuePairs.isEmpty) return '';
    ValidationResult result = knowledgeField.validate();
    if (result == ValidationResult.inputError) {
      return knowledgeField.keyValuePairs['Error']!;
    }
    if (result == ValidationResult.tooFewElements) {
      return textImportTooViewAssociations;
    }
    return '-';
  }

  onPressOk(BuildContext context) {
    KnowledgeField newKnowledgeField = KnowledgeField(areaNameInput.value,
                                                      keyNameInput.value, valueNameInput.value,
                                                      knowledgeField.type,
                                                      forwardQuestionInput.value, backwardQuestionInput.value);
    knowledgeField.keyValuePairs.forEach((key, value) {newKnowledgeField.addKeyValuePair(key, value);});
    bool isNew = appRuntimeData.isKnowledgeFieldNew(newKnowledgeField);
    if (! isNew) {
      String message = textDialogNewKnowledgeFieldOverwritten.replaceFirst("<XY>", newKnowledgeField.getName());
      AssTraDialogUtil.showDecisionBox(context, textDialogOverwriteTitle, message).then((ok) {
        if (ok) {
          appRuntimeData.deleteKnowledgeField(newKnowledgeField.getName(), context, false);
          appRuntimeData.saveKnowledgeField(newKnowledgeField);
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => appMainPage.getDefaultPage()));
      });
    } else {
      appRuntimeData.saveKnowledgeField(newKnowledgeField);
      Navigator.push(context, MaterialPageRoute(builder: (context) => appMainPage.getDefaultPage()));
    }
  }

}
