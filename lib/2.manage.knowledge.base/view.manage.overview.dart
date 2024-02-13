import 'dart:io';

import 'package:asstra/2.manage.knowledge.base/text.manage.knowledge.base.dart';
import 'package:asstra/2.manage.knowledge.base/view.importKnowledgeField.dart';
import 'package:asstra/2.manage.knowledge.base/view.viewKnowledgeField.dart';
import 'package:asstra/common/utils/asstra.util.io.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/common/widgets/AssTraAppBar.dart';
import 'package:asstra/main.dart';
import 'package:asstra/text.main.dart';
import 'package:flutter/material.dart';

import '../common/asstra.constants.dart';
import '../common/utils/asstra.util.dialog.dart';
import '../common/widgets/KnowledgeFieldSelection.dart';
import '../common/widgets/WaitStateWidget.dart';
import 'do.manage.knowledge.base.dart';


enum KnowledgeBaseManagementAction { import('Import'), export('Export'), delete('Delete'), viewModify('View / Modify');
  const KnowledgeBaseManagementAction(this.displayValue);
  final String displayValue;
  static KnowledgeBaseManagementAction fromDisplayValue(String aDisplayValue) {
    try {
      return KnowledgeBaseManagementAction.values.where((element) => element.displayValue == aDisplayValue).first;
    } catch (exception) {
    return KnowledgeBaseManagementAction.import;
    }
  }
}


/// main entry point into management of knowledge base
class AssTraManageKnowledgeView extends StatefulWidget {
  final List<KnowledgeField> libraryData;
  final List<String> knowledgeFieldNames = List<String>.empty(growable: true);
  final TextStyle textStyle =  const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black);

  DropdownButton dropdown = DropdownButton(items: List.empty(), onChanged: (value) {});
  KnowledgeBaseManagementAction selectedAction = KnowledgeBaseManagementAction.fromDisplayValue(appRuntimeData.lastValueSetting.getLastKnowledgeFieldAction());
  KnowledgeField? selectedKnowledgeField;
  bool readyToSelectKnowledgeField = false;

  AssTraManageKnowledgeView( {required this.libraryData, super.key});

  @override
  State<AssTraManageKnowledgeView> createState() => _AssTraManageKnowledgeViewState();
}

class _AssTraManageKnowledgeViewState extends State<AssTraManageKnowledgeView> {
  _AssTraManageKnowledgeViewState();

  @override
  Widget build(BuildContext context) {

    if (widget.readyToSelectKnowledgeField) {

      if (widget.selectedAction == KnowledgeBaseManagementAction.export) {
        return Scaffold(
                appBar: AssTraAppBar(mainTitle: '', subTitle: textManageKnowledgeTitle, subTitleSubLine: textExportSubtitle,
                                     withFlowControlIcon: true, backFunction: getBackFunction()),
                body: KnowledgeFieldSelection(onSelect: (value) {onKnowledgeFieldSelected(context,value);},
                                              headline: const Text(textExportSelection, style: TextStyle(fontFamily: 'Bold', fontSize: 20.0)))
        );
      }


      if (widget.selectedAction == KnowledgeBaseManagementAction.delete) {
        return Scaffold(
                appBar: AssTraAppBar(mainTitle: '', subTitle: textManageKnowledgeTitle, subTitleSubLine: textDeleteSubtitle,
                                     withFlowControlIcon: true, backFunction: getBackFunction()),
                body: KnowledgeFieldSelection(onSelect: (value) {onKnowledgeFieldSelected(context,value);},
                    headline: const Text(textDeleteSelection, style: TextStyle(fontFamily: 'Bold', fontSize: 20.0)))
        );
      }

      if (widget.selectedAction == KnowledgeBaseManagementAction.viewModify) {
        return Scaffold(
                appBar: AssTraAppBar(mainTitle: '', subTitle: textManageKnowledgeTitle, subTitleSubLine: textViewModifySubtitle,
                                     withFlowControlIcon: true, backFunction: getBackFunction()),
                body: KnowledgeFieldSelection(onSelect: (value) {onKnowledgeFieldSelected(context,value);},
                    headline: const Text(textViewModifySelection, style: TextStyle(fontFamily: 'Bold', fontSize: 20.0)))
        );
      }
    }

    widget.dropdown = DropdownButton(
      //style: widget.textStyle,
      value: widget.selectedAction.displayValue,
      isExpanded: true,
      items: getKnowledgeFieldActionsAsDropdownItems(widget.textStyle),
      onChanged: (value) {onActionChangedPressed(context,value);},
      dropdownColor: Theme.of(context).colorScheme.secondary,
    );

    // default / overview / action selection
    return createActionSelectScaffold();
  }

  List<DropdownMenuItem> getKnowledgeFieldActionsAsDropdownItems(TextStyle textStyle) {
    List<String> itemNames = KnowledgeBaseManagementAction.values.map((e) => e.displayValue).toList();
    return itemNames.map((item) => DropdownMenuItem(value: item, child: Center(child:Text(item, style: textStyle)))).toList();
  }


  Widget createActionSelectScaffold() {
    return Scaffold(
        appBar: AssTraAppBar(mainTitle: '', subTitle: textManageKnowledgeTitle, subTitleSubLine: '', withFlowControlIcon: false),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AssTraStringUtil.markdownStringToSizedText22(textOverviewDescription),
                const SizedBox(height: 40),
                Container(
                    height: 50,
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
                    alignment: Alignment.topCenter,
                    child: widget.dropdown
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(onPressed: () => onPressOk(context),
                      style: okButtonStyle,
                      child: const Text(textMainOkButtonText)
                  ),
                )
              ],
            )
        )
    );
  }

  VoidCallback getBackFunction() {
    return () {
      widget.selectedKnowledgeField = null;
      widget.readyToSelectKnowledgeField = false;
      setState(() {});
    };
  }

  void onActionChangedPressed(BuildContext context, Object value) {
    widget.selectedAction = KnowledgeBaseManagementAction.fromDisplayValue(value.toString());
    setState(() {});
    appRuntimeData.lastValueSetting.setLastKnowledgeFieldAction(widget.selectedAction.displayValue);
    appRuntimeData.saveLastValueSetting(appRuntimeData.lastValueSetting);
  }

  void onKnowledgeFieldSelected(BuildContext context, KnowledgeField value) {
    widget.selectedKnowledgeField = value;
    onPressOk(context);
  }

  onPressOk(BuildContext context) {
    if (widget.selectedAction == KnowledgeBaseManagementAction.import) {
      doImport(context);
    } else {
      if (widget.readyToSelectKnowledgeField) {
        if (widget.selectedAction == KnowledgeBaseManagementAction.export) {
          if (widget.selectedKnowledgeField != null) doExport(context, widget.selectedKnowledgeField);
        } else if (widget.selectedAction == KnowledgeBaseManagementAction.delete) {
          if (widget.selectedKnowledgeField != null) doDelete(context, widget.selectedKnowledgeField);
        } else if (widget.selectedAction == KnowledgeBaseManagementAction.viewModify) {
          if (widget.selectedKnowledgeField != null) doView(context, widget.selectedKnowledgeField);
        }
      } else {
        widget.readyToSelectKnowledgeField = true;
      }
    }
    setState(() {});
  }

  void doImport(BuildContext context) {
    KnowledgeField toImport = KnowledgeField.empty();
    AssTraImportView target = AssTraImportView(toImport);
    callBackFunction(data) {
      toImport = data! as KnowledgeField;
      if (toImport.keyValuePairs.isNotEmpty) {
        target.setKnowledgeField(toImport);
        target.build(context);
      }
    }
    WaitStateWidget widget = WaitStateWidget(future: readKnowledgeFieldFromFile(), targetWidget: target, aCallBackFunction: callBackFunction);
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
  }

  Future<KnowledgeField> readKnowledgeFieldFromFile() async {
    try {
      File? file = await AssTraIoUtil.pickFile();
      if (file == null) {
        KnowledgeField toReturn = KnowledgeField.empty();
        toReturn.addKeyValuePair("Error", "Cannot access file!");
        return Future.value(toReturn);      }
      String fileContent = await file.readAsString();
      return Future.value(KnowledgeField.formString(fileContent));
    } catch (exception) {
      KnowledgeField toReturn = KnowledgeField.empty();
      toReturn.addKeyValuePair("Error", "Invalid file format!");
      return Future.value(toReturn);
    }
  }

  void doExport(BuildContext context, KnowledgeField? knowledgeField) {
    var filename = 'AssTra_${knowledgeField?.getName().replaceFirst(' - ', '_')}.txt';
    var future = AssTraIoUtil.saveFile(filename, knowledgeField.toString());
    Navigator.push(context, MaterialPageRoute(builder: (context) => WaitStateWidget(
        future: future,
        targetWidget: appMainPage.getDefaultPage(),
        aCallBackFunction: (value) {
          WidgetsBinding.instance.addPostFrameCallback((_){
            AssTraDialogUtil.showInfoBox(context, textExportOkDialogTitle, textExportOkDialogMessage.replaceFirst('<XY>', filename));
          });
        })
    ));
  }

  void doDelete(BuildContext context, KnowledgeField? knowledgeField) {
    AssTraDialogUtil.showDecisionBox(context, textDeleteQuestionDialogTitle, 'Knowledge Field *${knowledgeField?.getName()}*').then((ok) {
      if (ok) {
        appRuntimeData.deleteKnowledgeField(knowledgeField!.getName(), context, true);
        Navigator.push(context, MaterialPageRoute(builder: (context) => appMainPage.getDefaultPage()));
      }
    });
  }

  void doView(BuildContext context, KnowledgeField? knowledgeField) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AssTraViewKnowledgeFieldView(knowledgeField!)));
  }

}
