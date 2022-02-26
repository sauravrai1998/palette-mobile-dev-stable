import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class HeaderRowText extends StatelessWidget {
  final String leftText;
  Widget topTextRow(){
    return Padding(padding: EdgeInsets.only(left: 28, right: 28),
      child: Text(leftText, style: kalamLight.copyWith(color: defaultDark, fontSize: 24),),
    );
  }

  HeaderRowText({required this.leftText});
  @override
  Widget build(BuildContext context) {
    return topTextRow();
  }
}
