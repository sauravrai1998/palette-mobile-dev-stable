import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class InvertedBorderRadiusContainer extends StatelessWidget {
  final Color mainColor;
  final Color backColor;
  final height;
  final Widget? child;

  InvertedBorderRadiusContainer({
    Key? key,
    this.mainColor = defaultDark,
    required this.backColor,
    this.height,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            Container(
              height: height,
              color: mainColor,
              child: child,
            ),
          ],
        ),
      ],
    );
  }
}
