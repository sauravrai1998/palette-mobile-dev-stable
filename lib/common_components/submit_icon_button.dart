import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class SubmitIconButton extends StatefulWidget {
  final Function()? clickFunction;

  SubmitIconButton({this.clickFunction});
  @override
  _SubmitIconButtonState createState() => _SubmitIconButtonState();
}

class _SubmitIconButtonState extends State<SubmitIconButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: defaultDark,
        shape: CircleBorder(),
      ),
      width: 40,
      height: 40,
      child: IconButton(
        icon: Icon(
          Icons.done_all,
          color: white,
          semanticLabel: "Submit button",
        ),
        iconSize: 20.0,
        onPressed: widget.clickFunction,
      ),
    );
  }
}
