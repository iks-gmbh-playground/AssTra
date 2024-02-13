import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:flutter/material.dart';

import '../asstra.constants.dart';

class AssTraDialogUtil {
  static showInfoBox(BuildContext context, String title, String text) {
    showInfoBoxWithCallback(context, title, text, () {});
  }

  static showInfoBoxWithCallback(BuildContext context, String title, String text, Function onClick) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Row(children: <Widget>[const Icon(infoIcon, color: infoIconColor), Expanded(child: Text('  $title', overflow: TextOverflow.ellipsis))]),
      content: SingleChildScrollView(child: AssTraStringUtil.markdownStringToSizedText16(text)),
      actions: [TextButton(
        child: const Text("Close", style: TextStyle(fontSize: 18, color: infoIconColor)),
        onPressed: () => {Navigator.pop(context), onClick()},
      )],
    ));
  }

  static showProblemBox(BuildContext context, String title, String text) {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Row(children: <Widget>[const Icon(infoIcon, color: problemIconColor), Expanded(child: Text('  $title', overflow: TextOverflow.ellipsis))]),
      content: AssTraStringUtil.markdownStringToSizedText16(text),
      actions: [TextButton(
        child: const Text("Close", style: TextStyle(fontSize: 18, color: problemIconColor)),
        onPressed: () => {Navigator.pop(context)},
      )],
    ));
  }

  static Future<bool> showDecisionBox(BuildContext context, String title, String text) async {
    bool toReturn = await showDialog(context: context, builder: (context) => AlertDialog(
      title: Row(children: <Widget>[const Icon(warningIcon, color: warningIconColor), Expanded(child: Text('  $title', overflow: TextOverflow.ellipsis))]),
      content: AssTraStringUtil.markdownStringToSizedText16(text),
      actions: [TextButton(
        child: Container(decoration: const BoxDecoration(color: warningIconColor), width: 110, alignment: Alignment.center, child: const Text("Yes, do it!", style: TextStyle(fontSize: 18, color: Colors.white))),
        onPressed: () => {Navigator.pop(context, true)},
      ), TextButton(
        child: const Text("No, cancel.", style: TextStyle(fontSize: 18, color: infoIconColor)),
        onPressed: () => {Navigator.pop(context, false)},
      )],
    ));
    return toReturn;
  }

}