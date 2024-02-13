import 'package:flutter/material.dart';

class HallOfFameEntryDisplay extends StatelessWidget {
  final int place;
  final String value;
  final String name;
  final String date;
  final TextStyle textStyle;

  const HallOfFameEntryDisplay(this.place, this.value, this.name, this.date,
                               this.textStyle, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          SizedBox(width: 20, height: 20,
              child: Container(
                  padding: const EdgeInsets.only(left: 5),
                  decoration: const BoxDecoration(color: Colors.green),
                  alignment: Alignment.centerLeft,
                  child: Text(place.toString(), style: textStyle)
            )
          ),
          SizedBox(width: 20, height: 20,
              child: Container(
                  decoration: const BoxDecoration(color: Colors.green),
                  alignment: Alignment.centerLeft,
                  child: Text(value, style: TextStyle(fontSize: textStyle.fontSize, fontWeight: FontWeight.bold))
              )
          ),
      ]
    );}
}
