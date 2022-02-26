import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShareDrawerBackButton extends StatelessWidget {
  const ShareDrawerBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (Platform.isIOS){
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              exit(0);
            }
          }
          else {
            Navigator.pop(context);
          }
        },
        icon: SvgPicture.asset('images/left_arrow.svg', height: 20));
  }
}
