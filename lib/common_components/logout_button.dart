import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class LogoutButton extends StatefulWidget {
  final Function()? clickFunction;

  LogoutButton({this.clickFunction});
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Logout Button',
      button: true,
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              splashRadius: 1,
              icon: SvgPicture.asset(
                'images/logout.svg',
                color: defaultLight,
                width: 22,
                height: 22,
                semanticsLabel: "Logout button",
              ),
              iconSize: 20.0,
              onPressed: () async {
                print('logout');
                await Helper.logout(context: context);
              },
            ),
            InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                print('logout');
                await Helper.logout(context: context);
              },
              child: Text(
                'Log out',
                style: kalamLight.copyWith(
                  height: 1,
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14,
                ),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
