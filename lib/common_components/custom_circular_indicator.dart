import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class CustomCircularIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final devWidth = MediaQuery.of(context).size.width;
    return Container(
      height: 22,
      width: 22,
      margin: EdgeInsets.only(right: devWidth * 0.03),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: defaultDark),
        ),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          backgroundColor: white,
        ),
      ),
    );
  }
}
