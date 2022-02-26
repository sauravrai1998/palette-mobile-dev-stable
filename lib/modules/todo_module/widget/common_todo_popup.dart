import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/common_components_link.dart';

class TodoAlertPopup extends StatelessWidget {
  final TodoAlertsType type;
  final String title;
  final String body;
  final Function cancelTap;
  final Function yesTap;

  const TodoAlertPopup({
    Key? key,
    required this.type,
    required this.title,
    required this.body,
    required this.cancelTap,
    required this.yesTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Text _alertTypeHeading() {
      late String title;
      late Color color;
      switch (type) {
        case TodoAlertsType.create:
          title = 'Creating...';
          color = neoGreen;
          break;
        case TodoAlertsType.save:
          title = 'Saving...';
          color = defaultDark;
          break;
        case TodoAlertsType.publish:
          title = 'Publishing...';
          color = neoGreen;
          break;
      }
      return Text(
        title,
        style: robotoTextStyle.copyWith(
          fontSize: 14,
          color: color,
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 28, 20, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 5,
                            offset: Offset(0, 1),
                          ),
                        ]),
                    child: SvgPicture.asset(
                      "images/done_enrolled.svg",
                      color: uploadIconButtonColor,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _alertTypeHeading(),
                      Text(
                        title,
                        style: robotoTextStyle.copyWith(fontSize: 19),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                body,
                style: robotoTextStyle.copyWith(
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 46,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        cancelTap();
                      },
                      child: Container(
                        height: 46,
                        child: Center(
                          child: Text(
                            'CANCEL',
                            style: robotoTextStyle.copyWith(
                              fontSize: 18,
                              color: redColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        yesTap();
                      },
                      child: Container(
                        height: 46,
                        child: Center(
                          child: Text(
                            'YES',
                            style: robotoTextStyle.copyWith(
                              fontSize: 18,
                              color: neoGreen,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
enum TodoAlertsType { create, save, publish}


