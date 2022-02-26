import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/utils/konstants.dart';

class ConsiderBulkEditButton extends StatelessWidget {
  const ConsiderBulkEditButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Consider',
            style: robotoTextStyle.copyWith(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SvgPicture.asset(
            "images/recommended_by_icon.svg",
            height: 12,
            width: 12,
            color: white,
          ),
        ],
      ),
    );
  }
}
