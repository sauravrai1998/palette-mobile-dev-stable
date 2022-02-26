import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/mentors_info_online_classes.dart';

import 'package:palette/common_components/student_view_components/project_modal_sheet.dart';
import 'package:palette/common_components/wave_widget.dart';
import 'package:palette/icons/imported_icons.dart';

class OnlineCoursesCertiAndFeedback extends StatefulWidget {
  @override
  _OnlineCoursesCertiAndFeedbackState createState() =>
      _OnlineCoursesCertiAndFeedbackState();
}

class _OnlineCoursesCertiAndFeedbackState
    extends State<OnlineCoursesCertiAndFeedback> {
  Widget udemyWidget = Positioned(
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

  int indexSelected = -1;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final bool keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            curve: Curves.easeOutQuad,
            top: keyboardOpen ? -(height - height * 0.25) / 3.7 : height * 0.25,
            child: WaveWidget(
              size: Size(width, height - height * 0.25),
              yOffset: (height - height * 0.25) / 9.0,
              decoration:
                  BoxDecoration(color: Color.fromRGBO(172, 213, 250, 0.4)),
            ),
          ),
          ListView(
            children: [
              indexSelected == -1
                  ? Container(
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
                    )
                  : Container(
                      height: 50,
                      color: defaultDark,
                      padding: EdgeInsets.only(left: 20, top: 0),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  indexSelected = -1;
                                });
                              },
                              child: Icon(
                                Icons.clear,
                                color: Colors.white,
                                size: 27,
                              )),
                          Spacer(),
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        indexSelected = -1;
                                      });
                                    },
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      size: 30,
                                      color: Colors.white,
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        indexSelected = -1;
                                      });
                                    },
                                    child: Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 27,
                                    )),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        indexSelected = -1;
                                      });
                                    },
                                    child: Icon(
                                      Icons.download_sharp,
                                      color: Colors.white,
                                      size: 27,
                                    )),
                              ),
                            ],
                          )
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
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    MentorsInformationForOnlineCourses(height: height * 0.18),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: height * 0.15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (indexSelected == 1) {
                                indexSelected = -1;
                              } else {
                                indexSelected = 1;
                              }
                              setState(() {});
                            },
                            child: Container(
                              width: width * 0.25,
                              decoration: indexSelected != 1
                                  ? BoxDecoration(
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
                                    )
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: defaultDark),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Icon(
                                      Imported.file_pdf,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  ),
                                  Text(
                                    'My Certificate',
                                    style: kalamTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (indexSelected == 2) {
                                indexSelected = -1;
                              } else {
                                indexSelected = 2;
                              }
                              print(indexSelected);
                              setState(() {});
                            },
                            child: Container(
                              width: width * 0.25,
                              decoration: indexSelected != 2
                                  ? BoxDecoration(
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
                                    )
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: defaultDark),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '5',
                                        style: kalamTextStyle.copyWith(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'My Certificate',
                                    style: kalamTextStyle.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
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
                                  padding: const EdgeInsets.only(
                                      right: 20, top: 0, bottom: 0),
                                  child: Container(
                                    width: width * 0.45,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(25)),
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
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: defaultDark,
                                                      fontSize: 14),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    'Project Subtitle',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
