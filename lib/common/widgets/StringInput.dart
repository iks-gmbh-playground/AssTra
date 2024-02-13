import 'package:flutter/material.dart';
/*
  Allows input of integer numbers without text input
*/
class AsstraStringInput extends StatefulWidget {
  final String name;
  final String initValue;

  ValueChanged<String>? onChanged;
  String value = '';

  AsstraStringInput( {required this.name,
                      required this.initValue,
                      this.onChanged,
                      super.key} ) {
    value = initValue;
  }

  @override State<AsstraStringInput> createState() => _AsstraStringInputState();

  String getValue() {
    return value;
  }
}

class _AsstraStringInputState extends State<AsstraStringInput> {
  @override
  Widget build(BuildContext context) {

    return RawKeyboardListener(
        focusNode: FocusNode(),
        child: TextFormField(
            onChanged: (value) => {onChanged(value)},
            initialValue: widget.initValue,
            decoration: InputDecoration(
                labelText: widget.name,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(),
                )
            ),
            validator: (val) {
              if (widget.value.isEmpty) {
                return "Name cannot be empty";
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.text,
            style: const TextStyle(),
        )
    );
  }

  onChanged(String value) {
    widget.value = value;
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }
}