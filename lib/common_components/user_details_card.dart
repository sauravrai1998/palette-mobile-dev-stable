import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class UserDetailsCard extends StatefulWidget {
  @override
  _UserDetailsCardState createState() => _UserDetailsCardState();
}

class _UserDetailsCardState extends State<UserDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: defaultDark,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),
            SizedBox(
              width: 16,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Richard Burke",
                      style: kalamTextStyle.copyWith(
                          fontSize: 24, fontWeight: FontWeight.w700)),
                  Text("Professor of physics",
                      style: kalamTextStyle.copyWith(
                          fontSize: 12, fontWeight: FontWeight.w700)),
                  Text("Your mentor",
                      style: kalamTextStyle.copyWith(
                          fontSize: 10, fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.message,
                        color: defaultDark,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Icon(
                        Icons.navigate_next_rounded,
                        color: defaultDark,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
