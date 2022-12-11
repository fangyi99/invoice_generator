import 'package:flutter/material.dart';

class RadioGroup extends StatelessWidget {

  String display;
  int radioIndex, selectedIndex;
  dynamic onChange;

  RadioGroup({
    required this.display,
    required this.radioIndex,
    required this.selectedIndex,
    required this.onChange
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: OutlinedButton(
        onPressed: onChange,
        child: Text(
          display,
          style: TextStyle(
            color: (selectedIndex == radioIndex) ? Colors.cyan : Colors.grey,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

}