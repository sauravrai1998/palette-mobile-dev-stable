import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SortTodoButton extends StatelessWidget {
  final Color iconColor;
  final Color backgroundColor;
  const SortTodoButton({
    Key? key,
    required this.iconColor,
    required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3),
      height: 30,
      width: 30,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(500),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ]),
      child: SvgPicture.asset(
        "images/descending_order.svg",
        color: iconColor,
        height: 14,
        width: 14,
      ),
    );
  }
}
