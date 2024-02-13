import 'dart:math';

import 'package:asstra/common/utils/asstra.util.string.dart';
import 'package:flutter/material.dart';
/*
  Allows input of integer numbers without text input
*/
class IntegerInput extends StatefulWidget {
  final int initValue;
  final int magnitude;
  final Color buttonColor;
  final int maxValue;
  final int minValue;

  int value = 0;
  int scaleMaxValue = 0;

  IntegerInput( {required this.magnitude, required this.initValue,
                 required this.buttonColor, required this.minValue, required this.maxValue,
                 super.key}) {
    value = initValue;
    if (maxValue.toString().startsWith("1")) {
      scaleMaxValue = maxValue.toString().length - 2;
    } else {
      scaleMaxValue = maxValue.toString().length - 1;
    }

    if (magnitude > 3) throw Exception("Magnitude values larger than 3 not supported");
    if (magnitude < 1) throw Exception("Magnitude values lower than 1 not supported");

  }

  @override State<IntegerInput> createState() => _IntegerInputState();

  int getValue() {
    return value;
  }
}

class _IntegerInputState extends State<IntegerInput> {
  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black
    );

    ButtonStyle buttonStyle = ButtonStyle(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        minimumSize: MaterialStateProperty.all(const Size(40, 10)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
          )),
      backgroundColor: MaterialStateProperty.all(widget.buttonColor)
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: <Widget>[
        Visibility(
          visible: widget.magnitude == 3,
            child: TextButton(
              onPressed: () {addToValue(getDimensionButton3());},
              style: buttonStyle,
              child: Text('+++', style: textStyle)
            )
          ),
        Visibility(
          visible: widget.magnitude >= 2,
          child: TextButton(
              onPressed: () {addToValue(getDimensionButton2());},
              style: buttonStyle,
              child: Text('++', style: textStyle)
          )
        ),
          TextButton(
                  onPressed: () {addToValue(getDimensionButton1());},
                  style: buttonStyle,
                  child: Text('+', style: textStyle)),
          const SizedBox(width: 15),
          AssTraStringUtil.markdownStringToSizedText16('*${widget.value}*'),
          const SizedBox(width: 15),
          TextButton(
              onPressed: () {addToValue(-1 * getDimensionButton1());},
                  style: buttonStyle,
                  child: Text('-', style: textStyle)),
        Visibility(
          visible: widget.magnitude >= 2,
          child: TextButton(
              onPressed: () {addToValue(-1 * getDimensionButton2());},
              style: buttonStyle,
              child: Text('--', style: textStyle)
          )
        ),
          Visibility(
            visible: widget.magnitude == 3,
            child: TextButton(
              onPressed: () {addToValue(-1 * getDimensionButton3());},
              style: buttonStyle,
              child: Text('---', style: textStyle)),
          )
        ]
      ));
  }

  addToValue(int addValue) {
    int newValue = widget.value + addValue;
    if (newValue < widget.minValue) {
      newValue = widget.minValue;
    } else if (widget.minValue < widget.maxValue && newValue > widget.maxValue) {
      newValue = widget.maxValue;
    }
    widget.value = newValue;
    setState((){});
  }

  int getDimensionButton1() {
    if (widget.magnitude == 1) {
      return pow(10, widget.scaleMaxValue).toInt();
    }
    if (widget.magnitude == 2) {
      return pow(10, widget.scaleMaxValue-1).toInt();
    }
    return pow(10, widget.scaleMaxValue-2).toInt();
  }

  int getDimensionButton2() {
    if (widget.magnitude == 2) {
      return pow(10, widget.scaleMaxValue).toInt();
    }
    return pow(10, widget.scaleMaxValue-1).toInt();
  }

  int getDimensionButton3() {
    return pow(10, widget.scaleMaxValue).toInt();
  }

}