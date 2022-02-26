import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/mentors_info_online_classes.dart';
import 'package:palette/common_components/student_view_components/objectives_widget.dart';
import 'package:palette/icons/imported_icons.dart';

class OnlineCoursesDetails extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.only(left: 20, top: 0),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_sharp,
                      color: defaultDark,
                      size: 27,
                    )),
              ],
            ),
          ),
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
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                MentorsInformationForOnlineCourses(height: height * 0.18),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
                  child: Text(
                      "Learn the fundamentals of Data Analytics and gain an understanding of the data ecosystem, the process and lifecycle of data analytics, career opportunities, and the different learning paths you can take to be a Data Analyst.",
                      style: kalamTextStyle.copyWith(
                          fontSize: 14, fontWeight: FontWeight.w400)),
                ),
                SizedBox(
                  height: 10,
                ),
                GetObjectivesAndPreRequisites(
                  title: "Objectives",
                ),
                GetObjectivesAndPreRequisites(
                  title: "Pre-Requisites",
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
