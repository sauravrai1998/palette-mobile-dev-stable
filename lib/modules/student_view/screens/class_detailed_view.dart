import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/feedback_modal_sheet.dart';
import 'package:palette/common_components/student_view_components/mentors_information.dart';
import 'package:palette/common_components/student_view_components/resources_gridview.dart';
import 'package:palette/common_components/wave_widget.dart';

class DetailedClassView extends StatefulWidget {
  @override
  _DetailedClassViewState createState() => _DetailedClassViewState();
}

class _DetailedClassViewState extends State<DetailedClassView> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;

    final size = MediaQuery.of(context).size;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: defaultDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          PopupMenuButton(
            padding: EdgeInsets.all(0),
            shape: bottomRightCurvedShape,
            color: defaultLight,
            icon: Icon(
              Icons.expand_more,
              color: defaultLight,
            ),
            elevation: 0,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Container(
                  child: Column(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(3),
                                  topLeft: Radius.circular(3),
                                  bottomLeft: Radius.circular(3),
                                  bottomRight: Radius.circular(3))),
                          height: 100,
                          width: 120,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
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
                                          return FeedBackModalSheet();
                                        },
                                      );
                                    },
                                    child: Text(
                                      "Give FeedBack",
                                      style: roboto700.copyWith(fontSize: 16),
                                      maxLines: 1,
                                    )),
                                Text(
                                  "Opt Out",
                                  style: roboto700.copyWith(fontSize: 16),
                                ),
                                Text(
                                  "Explore Similar",
                                  style: roboto700.copyWith(fontSize: 16),
                                )
                              ],
                            ),
                          ),
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
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -size.height / 3.7 : 0.0,
            child: WaveWidget(
              size: size,
              yOffset: size.height / 3.0,
              decoration:
                  BoxDecoration(color: Color.fromRGBO(172, 213, 250, 0.4)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListView(
              children: [
                SizedBox(
                  height: 10,
                ),
                MentorsInformationForClasses(height: height * 0.18),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: height * 0.15,
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0.7, 1],
                            colors: [
                              Color.fromRGBO(179, 172, 250, 1),
                              Color.fromRGBO(179, 172, 250, 1),
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '80%',
                              style: kalamTextStyle.copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            Text(
                              'Attendance',
                              style: kalamTextStyle.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 30, top: 20, left: 12, right: 12),
                        child: Container(
                          width: 2,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      Expanded(
                          child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(10, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Stack(
                              children: [
                                Container(
                                  width: width * 0.25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.7, 1],
                                      colors: [
                                        Color.fromRGBO(179, 172, 250, 1),
                                        Color.fromRGBO(179, 172, 250, 1),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '80%',
                                        style: kalamTextStyle.copyWith(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        'Attendance',
                                        style: kalamTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ResourcesGridView(height: height * 0.32),
                SizedBox(
                  height: 30,
                ),
                Container(
                  height: height * 0.22,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Projects',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: defaultDark,
                                  fontSize: 24),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(right : 20.0),
                            //   child: GestureDetector(onTap: (){
                            //     showModalBottomSheet(
                            //       context: context,
                            //       isScrollControlled: false,
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                            //       ),
                            //       isDismissible: true,
                            //       builder: (BuildContext bc) {
                            //         return  ProjectModalSheet();
                            //       },
                            //     );
                            //   },child: Text('View All',style: TextStyle(fontWeight: FontWeight.w700,color: defaultDark,fontSize:14 ),)),
                            // )
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
                              padding: const EdgeInsets.only(
                                  right: 20, top: 0, bottom: 0),
                              child: Container(
                                width: width * 0.45,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(25)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 22),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Project Title',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  color: defaultDark,
                                                  fontSize: 14),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
