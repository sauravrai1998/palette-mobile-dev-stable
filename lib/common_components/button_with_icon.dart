import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';

class ButtonWithIcon extends StatelessWidget {
  final void Function() onPressed;
  final Text textWidget;
  final Icon icon;
  final double borderRadius;
  final double height;
  final double? width;

  ButtonWithIcon({
    Key? key,
    required this.onPressed,
    required this.textWidget,
    required this.icon,
    this.width,
    this.borderRadius = 12,
    this.height = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: defaultDark,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 12),
            textWidget,
          ],
        ),
      ),
    );
  }
}
