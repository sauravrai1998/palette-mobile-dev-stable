import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class CareerStudentDashboard extends StatefulWidget {
  final String view;

  CareerStudentDashboard({required this.view});

  @override
  _CareerStudentDashboardState createState() => _CareerStudentDashboardState();
}

class _CareerStudentDashboardState extends State<CareerStudentDashboard> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Scaffold(
        body: Stack(
          children: [
            SvgPicture.asset(
              'images/student_small_splash.svg',
              height: 130,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: SvgPicture.asset(
                      'images/chat_icon.svg',
                    ),
                    onPressed: () {
                      Helper.navigateToChatSection(context);
                    },
                  ),
                ],
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  'Palette',
                  style: kalamLight.copyWith(color: defaultDark, fontSize: 24),
                ),
                leading: IconButton(
                  color: Colors.transparent,
                  icon: Icon(Icons.backspace_outlined),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Expanded(
                        child: Center(
                            child: Text(widget.view == 'profile'
                                ? "Career Screen"
                                : "Career Explore Screen")))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
