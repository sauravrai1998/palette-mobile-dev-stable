import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/utils/konstants.dart';

class BottomButton extends StatelessWidget {
  final Function()? onPressed;

  BottomButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Profile view accessed",
      button: true,
      child: InkWell(
          onTap: onPressed,
          child: Container(
              height: 40,
              width: 50,
              decoration: BoxDecoration(
                color: white.withOpacity(0.5),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(14)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'images/dropdown_inverted.svg',
                  height: 20,
                  width: 20,
                  color: defaultLight,
                ),
              ))),
    );
  }
}
