import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class PlusButton extends StatelessWidget {
  final Function()? onPressed;
  final double width;
  final double height;
  final double iconSize;
  final double borderRadius;

  PlusButton({
    Key? key,
    required this.onPressed,
    required this.width,
    required this.height,
    this.iconSize = 24,
    this.borderRadius = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Press to add',
      button: true,
      child: InkWell(
        onTap: onPressed,
        child: Container(
            height: width,
            width: height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.add,
                size: iconSize,
                color: defaultDark,
              ),
            )),
      ),
    );
  }
}
