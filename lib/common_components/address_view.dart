import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class AddressView extends StatelessWidget {
  final String topText;
  final String bottomText;
  final String opaqueText;
  final Widget? topIcon;
  final Widget? bottomIcon;
  final TextStyle normalTextStyle;
  final TextStyle? opaqueTextStyle;

  AddressView({
    Key? key,
    required this.topText,
    required this.bottomText,
    required this.opaqueText,
    this.topIcon,
    this.bottomIcon,
    this.normalTextStyle = addressTextStyle,
    this.opaqueTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topIcon ?? Container(),
              SizedBox(width: 20),
              Text(
                topText,
                style: normalTextStyle,
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              bottomIcon ?? Container(),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bottomText,
                    style: normalTextStyle,
                  ),
                  Text(
                    opaqueText,
                    style: opaqueTextStyle ??
                        addressTextStyle.copyWith(
                            color: defaultDark.withOpacity(0.5)),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
