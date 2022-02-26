import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/common_components_link.dart';

GestureDetector callButton({
  double width = 45,
   double heigth = 45,
  required Function onTap,
}) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
      width: width,
      height: heigth,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: SvgPicture.asset(
            "images/call_icon.svg",
            color: defaultDark,
            height: 20,
            width: 20,
          ),
        ),
      ),
    ),
  );
}
