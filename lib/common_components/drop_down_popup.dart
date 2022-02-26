import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/utils/konstants.dart';

class DropDownPopup extends StatelessWidget {
  final Function() onTap;
  final String title;
  final String placeholder;

  DropDownPopup(
      {required this.onTap, required this.title, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      onTapHint: 'Press to select $title',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: defaultBlueDark.withOpacity(0.4),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: robotoTextStyle.copyWith(
                    color: title == placeholder
                        ? defaultDark.withOpacity(0.6)
                        : defaultDark,
                  ),
                ),
              ),
              Transform.rotate(
                angle: pi / 2,
                child: SvgPicture.asset(
                  'images/dropdown_inverted.svg',
                  height: 14,
                  width: 16,
                  semanticsLabel: "dropdown",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
