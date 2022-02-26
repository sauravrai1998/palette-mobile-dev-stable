import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class WorkDetailsWidget extends StatelessWidget {
  final Widget icon;
  final String text;
  final String opaqueText;
  final TextStyle opaqueTextStyle;
  final TextStyle? textStyle;

  WorkDetailsWidget(
      {required this.icon,
      required this.text,
      required this.opaqueText,
      required this.opaqueTextStyle,
      this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        SizedBox(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: textStyle != null
                    ? textStyle
                    : kalamTextStyleSmall.copyWith(
                        fontSize: 18,
                        color: defaultDark,
                      ),
              ),
              Text(opaqueText, style: opaqueTextStyle),
            ],
          ),
        ),
        SizedBox(width: 14),
      ],
    );
  }
}
