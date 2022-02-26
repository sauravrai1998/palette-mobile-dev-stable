import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class TwoSidedRadiusButton extends StatelessWidget {
  final Function()? onPressed;
  final double height;
  final double? width;
  final String buttonTitle;
  final TextStyle textStyle;

  TwoSidedRadiusButton({
    Key? key,
    this.width,
    this.height = 40,
    this.onPressed,
    this.textStyle = robotoTextStyle,
    required this.buttonTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: defaultDark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            buttonTitle,
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
