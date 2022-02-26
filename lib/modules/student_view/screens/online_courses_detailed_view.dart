import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/mentors_info_online_classes.dart';
import 'package:palette/common_components/student_view_components/objectives_widget.dart';
import 'package:palette/common_components/student_view_components/project_modal_sheet.dart';
import 'package:palette/common_components/wave_widget.dart';
import 'package:palette/icons/imported_icons.dart';

class OnlineCoursesDetailedView extends StatelessWidget {
  final Widget udemyWidget = Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Text(
              'GO TO UDEMY',
              style: TextStyle(color: defaultDark, fontWeight: FontWeight.w700),
            ),
            SizedBox(
              width: 15,
            ),
            Container(
              alignment: FractionalOffset.topCenter,
              transform: new Matrix4.identity()..rotateZ(90 * 3.1415927 / 180),
              child: Icon(Imported.subtract, color: defaultDark, size: 7),
            )
          ],
        ),
      ));

  getAnimation(keyboardOpen, height, width) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuad,
      top: keyboardOpen ? -(height - height * 0.25) / 3.7 : height * 0.25,
      child: WaveWidget(
        size: Size(width, height - height * 0.25),
        yOffset: (height - height * 0.25) / 9.0,
        decoration: BoxDecoration(color: Color.fromRGBO(172, 213, 250, 0.4)),
      ),
    );
  }

  getProjects(height, width, context) {
    return Container(
      height: height * 0.22,
      child: Padding(
        padding: const EdgeInsets.only(left: 00, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Projects',
                    style: kalamTextStyle.copyWith(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: false,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                          ),
                          isDismissible: true,
                          builder: (BuildContext bc) {
                            return ProjectModalSheet();
                          },
                        );
                      },
                      child: Text(
                        'View All',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: defaultDark,
                            fontSize: 14),
                      )),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20, top: 0, bottom: 0),
                  child: Container(
                    width: width * 0.45,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 10, left: 22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Project Title',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: defaultDark,
                                      fontSize: 14),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Project Subtitle',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: defaultDark,
                                        fontSize: 12),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            'Completed',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: greenDefault,
                                fontSize: 10),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;

    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios_sharp,
          color: defaultDark,
        ),
        actions: [
          PopupMenuButton(
            padding: EdgeInsets.all(0),
            shape: bottomRightCurvedShape,
            color: Colors.white,
            icon: Icon(
              Icons.expand_more,
              color: defaultLight,
            ),
            elevation: 0,
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 100,
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(3),
                                topLeft: Radius.circular(3),
                                bottomLeft: Radius.circular(3),
                                bottomRight: Radius.circular(3))),
                        height: 100,
                        width: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Text(
                              "Give FeedBack",
                              style: roboto700.copyWith(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                value: 0,
              ),
            ],
          )
        ],
      ),
      body: Stack(
        children: [
          getAnimation(keyboardOpen, height, width),
          ListView(
            children: [
              Stack(
                children: [
                  Container(
                    height: height * 0.25,
                    color: Colors.grey,
                  ),
                  udemyWidget
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    MentorsInformationForOnlineCourses(height: height * 0.18),
                    SizedBox(
                      height: 30,
                    ),
                    GetObjectivesAndPreRequisites(
                      title: "Objectives",
                    ),
                    getProjects(height, width, context)
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
