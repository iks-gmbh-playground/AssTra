import 'package:asstra/common/asstra.constants.dart';
import 'package:asstra/common/utils/asstra.util.dialog.dart';
import 'package:flutter/material.dart';


class FieldDisplay extends StatelessWidget {
  final String fieldName;
  final String value;
  final TextStyle textStyle;
  final double nameWidth;
  final double height;
  final Color bkColor;
  final String helpText;

  const FieldDisplay(this.fieldName, this.value, this.textStyle, this.nameWidth,
                     this.height, this.bkColor, this.helpText, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = nameWidth;
    if (width > MediaQuery.of(context).size.width) {
      width = MediaQuery.of(context).size.width - 30;
    }
    return Row(
        children: <Widget>[
          SizedBox(width: width, height: height,
              child: Container(
                  padding: const EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(color: bkColor),
                  alignment: Alignment.centerLeft,
                  child: Text(fieldName,overflow: TextOverflow.ellipsis, style: textStyle)
            )
          ),
          Visibility(
            visible: value.isNotEmpty,
            child: Expanded(child: SizedBox(height: height,
              child: Container(
                  decoration: BoxDecoration(color: bkColor),
                  alignment: Alignment.centerLeft,
                  child: Text(value, style: TextStyle(fontSize: textStyle.fontSize, fontWeight: FontWeight.bold))
              )
            )
          )),
          Visibility(
              visible: helpText.trim().isNotEmpty,
              child: IconButton(onPressed: () => AssTraDialogUtil.showInfoBox(context, fieldName, helpText),
              icon: const Icon(infoIcon, color: infoIconColor))
          ),
      ]
    );}
}
