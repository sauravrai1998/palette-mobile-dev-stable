import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/utils/konstants.dart';

class AddTodoBulkEditButton extends StatelessWidget {
  const AddTodoBulkEditButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Add to Todo',
            style: robotoTextStyle.copyWith(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          SvgPicture.asset(
            "images/done_enrolled.svg",
            height: 12,
            width: 12,
            color: white,
          ),
        ],
      ),
    );
  }
}
