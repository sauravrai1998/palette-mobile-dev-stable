import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NextButton extends StatefulWidget {
  final Function()? clickFunction;

  NextButton({this.clickFunction});
  @override
  _NextButtonState createState() => _NextButtonState();
}

class _NextButtonState extends State<NextButton> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Next Button",
      child: IconButton(
        icon: SvgPicture.asset(
          'images/prev.svg',
          semanticsLabel: "Next Button",
        ),
        iconSize: 24.0,
        onPressed: widget.clickFunction,
      ),
    );
  }
}
