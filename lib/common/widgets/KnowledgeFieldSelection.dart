import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/main.dart';
import 'package:flutter/material.dart';

import '../../2.manage.knowledge.base/do.manage.knowledge.base.dart';
import '../../text.main.dart';
import 'StringInput.dart';

const Row noRow = Row();

class KnowledgeFieldSelection extends StatefulWidget {
  final ValueChanged<KnowledgeField> onSelect;
  final Text headline;
  final List<String> knowledgeFieldsToDisplay = List.empty(growable: true);
  SortMode sortMode = SortMode.standard;
  Row headRow = noRow;

  KnowledgeFieldSelection({super.key, required this.onSelect, required this.headline, headRow}) {
    if (headRow != null) this.headRow = headRow;
    appRuntimeData.knowledgeFields.map((kf) => kf.getName()).forEach((e) => knowledgeFieldsToDisplay.add(e));
  }

  @override
  State<KnowledgeFieldSelection> createState() => _KnowledgeFieldSelectionState();
}


class _KnowledgeFieldSelectionState extends State<KnowledgeFieldSelection> {
  _KnowledgeFieldSelectionState();

  @override
  Widget build(BuildContext context) {
    bool showSearchField = appRuntimeData.knowledgeFields.length > appRuntimeData.appConfigData.getMinListSizeToShowSearchField();

    if (widget.sortMode == SortMode.zxy) {
      widget.knowledgeFieldsToDisplay.sort((a, b) => a.compareTo(b));
    } else if (widget.sortMode == SortMode.abc) {
      widget.knowledgeFieldsToDisplay.sort((a, b) => b.compareTo(a));
    } else {
      widget.knowledgeFieldsToDisplay.sort((a, b) => getUsageIndexOf(a).compareTo(getUsageIndexOf(b)));
    }

    return Column(children: <Widget>[
      Visibility(visible: widget.headRow != noRow,
                 child: const SizedBox(height: 5)),
      Visibility(visible: widget.headRow != noRow,
                 child: widget.headRow),
      Visibility(visible: widget.headRow != noRow,
          child: const SizedBox(height: 10)),

      Visibility(visible: widget.headline.data!.isNotEmpty,
                 child: const SizedBox(height: 20)),
      Visibility(visible: widget.headline.data!.isNotEmpty,
                 child: widget.headline),
      Visibility(visible: widget.headline.data!.isNotEmpty,
                 child: const SizedBox(height: 20)),

      Visibility(visible: showSearchField, child: const SizedBox(height: 10)),
      Visibility(visible: showSearchField, child: Row(children: [
        const SizedBox(width: 5),
        const Icon(searchIcon, size: 44),
        const SizedBox(width: 5),
        Expanded(child: AsstraStringInput(name: textKeyOrValue, initValue: '', onChanged: (value) => {applySearchFilter(value, context)})),
        Center(child: IconButton(onPressed: () => onSort(), icon: getSortModeIcon()))
      ],)),
      Visibility(visible: showSearchField, child: const SizedBox(height: 10)),

      Expanded(child: Align(
        alignment: Alignment.topCenter,
        child: ListView.builder(
            itemCount: widget.knowledgeFieldsToDisplay.length,
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
                        widget.onSelect(appRuntimeData.getKnowledgeField(widget.knowledgeFieldsToDisplay.elementAt(index)));
                      },
                      splashColor: const Color.fromRGBO(0, 255, 0, 100),
                      radius: 25,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Center(child: Text(appRuntimeData.getKnowledgeField(widget.knowledgeFieldsToDisplay.elementAt(index)).knowledgeArea.substring(0,3))),
                          const Center(child: Text(' ', style: standardTextStyle)),
                          Expanded(child: Center(
                              child: Text("${widget.knowledgeFieldsToDisplay[index]} (${appRuntimeData.getKnowledgeField(widget.knowledgeFieldsToDisplay.elementAt(index)).keyValuePairs.length})",
                                          overflow: TextOverflow.ellipsis,
                                          style: standardTextStyle))),
                          const Center(child: Text(' ', style: standardTextStyle)),
                          Center(child: Icon(appRuntimeData.getKnowledgeField(widget.knowledgeFieldsToDisplay.elementAt(index)).getIcon())),
                        ],
                      )
                  )
              );
            }
        )
      ))]);
  }

  applySearchFilter(value, BuildContext context) {
    widget.knowledgeFieldsToDisplay.clear();
    if (value.trim().isEmpty) {
      appRuntimeData.knowledgeFields.map((kf) => kf.getName()).forEach((e) => widget.knowledgeFieldsToDisplay.add(e));
    } else {
      var matches = appRuntimeData.knowledgeFields.map((kf) => kf.getName()).where((e) => e.contains(value)).toList();
      widget.knowledgeFieldsToDisplay.addAll(matches);
    }
    setState(() {});
  }

  onSort() {
    if (widget.sortMode == SortMode.abc) {
      widget.sortMode = SortMode.zxy;
    } else if (widget.sortMode == SortMode.zxy) {
      widget.sortMode = SortMode.standard;
    } else {
      widget.sortMode = SortMode.abc;
    }

    setState(() {});
  }

  Icon getSortModeIcon() {
    if (widget.sortMode == SortMode.abc) return const Icon(abcSortIcon, size: 44);
    if (widget.sortMode == SortMode.zxy) return const Icon(zxySortIcon, size: 44);
    return const Icon(standardSortIcon, size: 44);
  }

  int getUsageIndexOf(String knowledgeFieldName) {
    return appRuntimeData.lastValueSetting.getLastKnowledgeUsageOrderAsList().indexWhere((field) => field == knowledgeFieldName);
  }
}