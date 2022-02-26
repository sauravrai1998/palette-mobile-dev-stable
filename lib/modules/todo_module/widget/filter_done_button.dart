import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class FilterDoneButton extends StatelessWidget {
  const FilterDoneButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 34,
      decoration: BoxDecoration(
          color: todoListActiveTab,
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          )),
      child: Text(
        'DONE',
        style: darkTextFieldStyle.copyWith(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
