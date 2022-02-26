import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/utils/konstants.dart';

class ShareOppBulkEditButton extends StatelessWidget {
  const ShareOppBulkEditButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Share',
              style: robotoTextStyle.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SvgPicture.asset(
              'images/share_icon.svg',
              color: white,
              height: 18,
              width: 18,
            ),
          ],
        ),
      ),
    );
  }
}
