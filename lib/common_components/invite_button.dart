import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'invite_user_screen.dart';

class InviteButton extends StatelessWidget {
  const InviteButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final route = MaterialPageRoute(
            builder: (_) =>
                InviteUserScreen());
        Navigator.push(context, route);
      },
      child: Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: SvgPicture.asset('images/invite.svg',color: Color(0xFF545454),),
      ),
    );
  }
}