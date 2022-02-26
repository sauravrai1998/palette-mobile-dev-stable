import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/utils/konstants.dart';

class FilterButton extends StatelessWidget {
  final Color iconColor;
  final Color iconBackgroundColor;
  const FilterButton({
    Key? key,
    this.iconColor = pinkRed,
    this.iconBackgroundColor = white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 30,
      width: 30,
      decoration: BoxDecoration(
          color: iconBackgroundColor,
          borderRadius: BorderRadius.circular(500),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ]),
      child: SvgPicture.asset(
        "images/filter.svg",
        color: iconColor,
        height: 14,
        width: 14,
      ),
    );
  }
}
