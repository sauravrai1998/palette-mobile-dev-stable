import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class FilterClearButton extends StatelessWidget {
  const FilterClearButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 34,
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: todoListActiveTab,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          )),
      child: Text(
        'CLEAR ALL',
        textAlign: TextAlign.center,
        style: darkTextFieldStyle.copyWith(
          color: todoListActiveTab,
          fontWeight: FontWeight.bold,
        ),
        semanticsLabel: "Clear filter",
      ),
    );
  }
}
