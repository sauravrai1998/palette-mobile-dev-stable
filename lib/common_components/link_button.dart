import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';

GestureDetector openLinkButton(
  {
  double width = 45,
  double height = 45,
  required Function onTap,
  }
) {
  return GestureDetector(
    onTap: () {
      onTap();
    },
    child: Container(
        width: width,
        height: height,
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
          child: Icon(
            Icons.launch,
            color: defaultDark,
            size: 25,
          ),
        )),
  );
}
