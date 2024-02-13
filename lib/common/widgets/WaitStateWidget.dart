import 'package:asstra/common/asstra.constants.dart';
import 'package:flutter/material.dart';

import '../../text.main.dart';

class WaitStateWidget extends StatefulWidget {
  final Future<dynamic> future;
  final Widget targetWidget;
  late String waitStateText;
  late String errorText;
  late Image waitStateImage;
  late ValueChanged<dynamic> callBackFunction;

  WaitStateWidget({required this.future, required this.targetWidget,
                   aWaitStateText, anErrorText, aWaitStateImage, aCallBackFunction,
                   super.key}) {
    waitStateText = aWaitStateText ?? textDefaultWaitStateText;
    errorText = anErrorText ?? textDefaultErrorText;
    waitStateImage = aWaitStateImage ?? noImage;
    callBackFunction = aCallBackFunction ?? (value) {};
  }

  @override State<WaitStateWidget> createState() => _WaitStateState();

  static Scaffold createWaitStateScaffold(Image image, String message, Color aTextColor) {
    var style = TextStyle(color: aTextColor, fontWeight: FontWeight.bold, fontSize: 30);
    List<Widget> children = List.of({
      Visibility(visible: image != noImage, child: image),
      Container(alignment: Alignment.center, child: Text(message, style: style, textAlign: TextAlign.center))
    });

    return Scaffold(body:Container(
      color: Colors.black,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children
      ),
    ));
  }
}

class _WaitStateState extends State<WaitStateWidget> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: widget.future, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            widget.callBackFunction.call(snapshot.data);
            return widget.targetWidget;
          }
          if (snapshot.hasError) {
            Image image = widget.waitStateImage;
            if (MediaQuery.of(context).size.height < 500) {
              image = noImage;
            }
            return WaitStateWidget.createWaitStateScaffold(image, widget.errorText, Colors.red);
          }
          return WaitStateWidget.createWaitStateScaffold(widget.waitStateImage, widget.waitStateText, Colors.green);
        });
  }

}
