import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NextButtonGroup extends StatefulWidget {
  final Function()? clickFunction;
  final bool? isEnable;

  NextButtonGroup({this.clickFunction,this.isEnable});
  @override
  _NextButtonGroupState createState() => _NextButtonGroupState();
}

class _NextButtonGroupState extends State<NextButtonGroup> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: widget.isEnable! ?SvgPicture.asset(
        'images/prev.svg',
        semanticsLabel: "Next Button",
      ):SvgPicture.asset(
        'images/Prevdisable.svg',
        semanticsLabel: "Next Button",
      ),
      iconSize: 45.0,
      onPressed: widget.clickFunction,
    );
  }
}
