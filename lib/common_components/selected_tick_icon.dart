import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class SelectedTickMarkIcon extends StatelessWidget {
  const SelectedTickMarkIcon({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: uploadIconButtonColor,
      child: Icon(
        Icons.check,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}