import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/utils/konstants.dart';

class TodoListBackButton extends StatelessWidget {
  const TodoListBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 40.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
            child: SvgPicture.asset(
              'images/left_arrow.svg',
              width: 30,
              height: 30,
              color: defaultDark,
            ),
            onTap: () {
              Navigator.of(context).pop();
            }),
      ),
    );
  }
}
