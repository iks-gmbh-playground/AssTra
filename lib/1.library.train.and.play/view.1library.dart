import 'package:asstra/1.library.train.and.play/texts/text.library.dart';
import 'package:asstra/1.library.train.and.play/view.2startdialog.dart';
import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:asstra/common/widgets/KnowledgeFieldSelection.dart';
import 'package:asstra/text.main.dart';
import 'package:flutter/material.dart';

import '../2.manage.knowledge.base/do.manage.knowledge.base.dart';
import '../common/widgets/AssTraAppBar.dart';
import '../common/widgets/StringInput.dart';
import '../main.dart';

enum LibraryListMode {area, field}

/// introducing view for "train and play"
class AssTraLibrary extends StatefulWidget {
  final String title = textMainPageTitle;
  final List<KnowledgeField> libraryData;
  LibraryListMode libraryListMode = LibraryListMode.area;
  SortMode knowledgeAreaSortMode = SortMode.standard;
  final List<String> knowledgeAreaToDisplay = List.empty(growable: true);

  AssTraLibrary( {required this.libraryData, super.key}) {
    knowledgeAreaToDisplay.addAll(appRuntimeData.getKnowledgeAreas());
  }

  @override
  State<AssTraLibrary> createState() => _AssTraLibraryState();
}

class _AssTraLibraryState extends State<AssTraLibrary> {
  _AssTraLibraryState();

  @override
  Widget build(BuildContext context) {
    checkKnowledgeAreaToDisplay();
    Widget body;
    if (widget.libraryListMode == LibraryListMode.area) {
      body = createKnowledgeAreaSelection();
    } else {
      body = KnowledgeFieldSelection(onSelect: (KnowledgeField knowledgeField) { onTabKnowledgeField(knowledgeField); },
                                     headline: const Text(''),
                                     headRow: getListModeRow());
    }

    String subTitle = textMainPageTitleSub;
    if (widget.libraryListMode == LibraryListMode.area) subTitle = textMainPageTitleSub2;
    return Scaffold(
        appBar: AssTraAppBar(mainTitle: '', subTitle: widget.title, subTitleSubLine: subTitle, withFlowControlIcon: false),
        body: body
    );
  }

  Row getListModeRow() {
    String text = textLibraryListKnowledgeArea;
    if (widget.libraryListMode == LibraryListMode.field) text = textLibraryListKnowledgeField;
    return Row(children: [
      const SizedBox(width: 5),
      Center(child: AssTraStringUtil.markdownStringToSizedText22(text)),
      const Expanded(child: SizedBox(width: 10,)),
      Center(child: IconButton(onPressed: () => onListModeChange(), icon: getViewModeIcon()))
    ]);
  }


  void onTabKnowledgeField(KnowledgeField knowledgeField) {
    List<KnowledgeField> fields = [knowledgeField];
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssTraStartDialog(knowledgeFields: fields)),
    );
  }

  void onTabKnowledgeArea(String knowledgeArea) {
    List<KnowledgeField> fields = appRuntimeData.getKnowledgeFieldNames(knowledgeArea).map((name) => appRuntimeData.getKnowledgeField(name)).toList();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AssTraStartDialog(knowledgeFields: fields)),
    );
  }


  Widget createKnowledgeAreaSelection() {
    bool showSearchField = appRuntimeData.getKnowledgeAreas().length > appRuntimeData.appConfigData.getMinListSizeToShowSearchField();

    return Column(children: <Widget>[
      const SizedBox(height: 5),
      getListModeRow(),
      const SizedBox(height: 5),
      Visibility(visible: showSearchField, child: const SizedBox(height: 10)),
      Visibility(visible: showSearchField, child: Row(children: [
        const SizedBox(width: 5),
        const Icon(searchIcon, size: 44),
        const SizedBox(width: 5),
        Expanded(child: AsstraStringInput(name: textKeyOrValue, initValue: '', onChanged: (value) => {applySearchFilter(value, context)})),
        Center(child: IconButton(onPressed: () => onSort(), icon: getSortModeIcon()))
      ])),
      Visibility(visible: showSearchField, child: const SizedBox(height: 10)),

      Expanded(child: Align(
          alignment: Alignment.topCenter,
          child: ListView.builder(
              itemCount: widget.knowledgeAreaToDisplay.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    height: 80,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(220, 220, 220, 100),
                        border: Border.all(
                            color: Colors.purple,
                            width: 1
                        )
                    ),
                    child: InkWell(
                        onTap: () {
                         onTabKnowledgeArea(widget.knowledgeAreaToDisplay.elementAt(index));
                        },
                        splashColor: const Color.fromRGBO(0, 255, 0, 100),
                        radius: 25,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                                child: Text(getListDisplayTextForArea(widget.knowledgeAreaToDisplay[index]),
                                            overflow: TextOverflow.ellipsis,
                                            style: standardTextStyle)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(getFieldsInAreaAsString(widget.knowledgeAreaToDisplay[index]),
                                            overflow: TextOverflow.ellipsis,
                                            style: smallTextStyle))
                            ],
                        )
                    )
                );
              }
          )
      ))]);
  }

  applySearchFilter(value, BuildContext context) {
    widget.knowledgeAreaToDisplay.clear();
    if (value.trim().isEmpty) {
      widget.knowledgeAreaToDisplay.addAll(appRuntimeData.getKnowledgeAreas());
    } else {
      var matches = appRuntimeData.knowledgeFields.map((kf) => kf.knowledgeArea).where((area) => area.contains(value)).toList();
      widget.knowledgeAreaToDisplay.addAll(matches);
    }
    setState(() {});
  }

  Icon getSortModeIcon() {
    if (widget.knowledgeAreaSortMode == SortMode.abc) return const Icon(abcSortIcon, size: 44);
    if (widget.knowledgeAreaSortMode == SortMode.zxy) return const Icon(zxySortIcon, size: 44);
    return const Icon(standardSortIcon, size: 44);
  }

  onSort() {
    if (widget.knowledgeAreaSortMode == SortMode.abc) {
      widget.knowledgeAreaSortMode = SortMode.zxy;
    } else if (widget.knowledgeAreaSortMode == SortMode.zxy) {
      widget.knowledgeAreaSortMode = SortMode.standard;
    } else {
      widget.knowledgeAreaSortMode = SortMode.abc;
    }

    setState(() {});
  }

  Icon getViewModeIcon() {
    if (widget.libraryListMode == LibraryListMode.field) return const Icon(libraryFilterAreaIcon, size: 44);
    return const Icon(libraryFilterFieldIcon, size: 44);
  }

  onListModeChange() {
    if (widget.libraryListMode == LibraryListMode.area) {
      widget.libraryListMode = LibraryListMode.field;
    } else {
      widget.libraryListMode = LibraryListMode.area;
    }
    appRuntimeData.lastValueSetting.setLastKnowledgeFieldAction(widget.libraryListMode.name);

    appRuntimeData.saveLastValueSetting(appRuntimeData.lastValueSetting);
    setState(() {});
  }

  String getFieldsInAreaAsString(String knowledgeArea) {
    var knowledgeFieldNames = appRuntimeData.getKnowledgeFieldNames(knowledgeArea);
    AssTraStringUtil.abcSort(knowledgeFieldNames);
    return AssTraStringUtil.listToString(knowledgeFieldNames, "  |  ");
  }

  String getListDisplayTextForArea(String knowledgeArea) {
    return "$knowledgeArea (${appRuntimeData.getKnowledgeFieldNames(knowledgeArea).length})";
  }

  void checkKnowledgeAreaToDisplay() {
    widget.knowledgeAreaToDisplay.clear();
    widget.knowledgeAreaToDisplay.addAll(appRuntimeData.getKnowledgeAreas());
  }

}
