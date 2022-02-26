import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mailto/mailto.dart';
import 'package:palette/common_components/logout_button.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/todo_module/widget/file_resource_card_button.dart';
import 'package:palette/utils/konstants.dart';

// ignore: must_be_immutable
class HamburgerMenu extends StatefulWidget {
  bool isVisible;
  String userRole;
  String userName;
  String userEmail;
  String userId;
  HamburgerMenu(
      {required this.isVisible,
      required this.userName,
      required this.userEmail,
      required this.userRole,
      required this.userId});

  @override
  _HamburgerMenuState createState() => _HamburgerMenuState();
}

class _HamburgerMenuState extends State<HamburgerMenu> {
  bool isToDelete = false;
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.isVisible,
      child: Scaffold(
        backgroundColor: Colors.black12.withOpacity(0.6),
        body: Align(
          alignment: Alignment.topRight,
          child: TextScaleFactorClamper(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.horizontal(left: Radius.circular(10)),
              ),
              color: pinkRed,
              child: Container(
                  padding: EdgeInsets.fromLTRB(8, 12, 5, 8),
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: isToDelete ? confirmToDelete() : settings()),
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmToDelete() {
    return Container(
      padding: EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Clear Account Data',
              semanticsLabel: 'Clear Account Data',
              style: montserratNormal.copyWith(
                  height: 1, color: Colors.white, fontSize: 16),
            ),
          ),
          Divider(
            color: Colors.white.withOpacity(0.85),
            thickness: 3,
            indent: 60,
            endIndent: 60,
          ),
          Text(
            'Are you sure you want clear your account data?',
            style: montserratNormal.copyWith(
                height: 1, color: Colors.white, fontSize: 12),
          ),
          SizedBox(height: 10),
          Text(
            'If yes, you are required to send an email to admnpalette@gmail.com to get your data cleared.',
            style: montserratNormal.copyWith(
                height: 1, color: Colors.white.withOpacity(0.85), fontSize: 12),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    // side: MaterialStateProperty.all(
                    //     BorderSide(color: Colors.white, width: 4)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: 4),
                        borderRadius: BorderRadius.circular(10)))),
                child: Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.red[400]),
                ),
                onPressed: () => setState(() => isToDelete = false),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(pinkRed),
                    side: MaterialStateProperty.all(
                        BorderSide(color: Colors.white, width: 3)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                child: Text('CONFIRM'),
                onPressed: () {
                 // ProfilePendoRepo.trackClearAccountData(sfuuid: widget.userId, role: widget.userRole);
                  sendMail();
                },
              )
            ],
          )
        ],
      ),
    );
  }

  void sendMail() async {
    final mailtoLink = Mailto(
      to: ['admnpalette@gmail.com'],
      subject: ' Delete Account Data - regarding',
      body:
          'Dear Admin,\n\n requesting account data deletion for ${widget.userRole} - ${widget.userEmail}.\n\nThanks & Regards\n${widget.userName}',
    );
    await launchURL('$mailtoLink');
  }

  Widget settings() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'SETTINGS',
            semanticsLabel: 'Settings',
            style: montserratNormal.copyWith(
                height: 1, color: Colors.white.withOpacity(0.85), fontSize: 16),
          ),
          Divider(
            color: Colors.white.withOpacity(0.85),
            thickness: 3,
            indent: 60,
            endIndent: 60,
          ),
          LogoutButton(),
          deleteAccountButton(),
        ],
      ),
    );
  }

  Widget deleteAccountButton() {
    return Semantics(
      label: 'Clear Account Data Button',
      button: true,
      child: InkWell(
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => setState(() => isToDelete = true),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Clear Account Data',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: montserratNormal.copyWith(
                color: Colors.white.withOpacity(0.85),
                fontSize: 14,
              ),
            ),
            Spacer(),
            IconButton(
              icon: SvgPicture.asset(
                'images/trash-2.svg',
                color: defaultLight,
                width: 22,
                height: 22,
                semanticsLabel: "Delete Account button",
              ),
              iconSize: 20.0,
              onPressed: () => setState(() => isToDelete = true),
            ),
          ],
        ),
      ),
    );
  }
}
