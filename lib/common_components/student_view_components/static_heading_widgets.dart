import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class HeaderCenterText extends StatelessWidget {
  final String leftText;
  Widget topTextRow(){
    return Center(child: Text(leftText, style: kalamLight.copyWith(color: defaultDark, fontSize: 25),));
  }

  HeaderCenterText({required this.leftText});
  @override
  Widget build(BuildContext context) {
    return topTextRow();
  }
}
