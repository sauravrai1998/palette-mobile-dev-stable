import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/mentors_information.dart';
import 'package:palette/common_components/student_view_components/objectives_widget.dart';

class CourseDetails extends StatefulWidget {
  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails> {
  Widget getIndentedText({text}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 30),
          child: Container(
            width: 8,
            height: 3,
            color: defaultLight,
            child: SizedBox(),
          ),
        ),
        Text("$text",
            style: kalamTextStyle.copyWith(
                fontSize: 14, fontWeight: FontWeight.w400))
      ],
    );
  }

  int _currentPage = 0;
  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 0.85,
  );

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 5.0,
      width: isActive ? 9.0 : 6.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey[400],
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  List<Widget> _buildPageIndicator({numPages}) {
    List<Widget> list = [];
    for (int i = 0; i < numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  pageViewImage({response, date, time, sender, creator, des}) {
    PageController _ = PageController(
      initialPage: 0,
      viewportFraction: 1,
    );
  }

  bool showFeedBack = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;

    var _list = _buildPageIndicator(numPages: 3);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back_ios_sharp,
                            color: defaultDark,
                          )),
                      GestureDetector(
                        onTap: () {
                          showFeedBack = !showFeedBack;
                          setState(() {});
                        },
                        child: Stack(
                          children: [
                            SvgPicture.asset(
                              'images/circles.svg',
                              width: 50,
                              height: 50,
                              color: defaultDark,
                            ),
                            Positioned(
                              right: 5,
                              child: Row(
                                children: [
                                  Text(
                                    '5',
                                    style: kalamTextStyle.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 25,
                        ),
                        MentorsInformationForClasses(height: height * 0.18),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 20),
                          child: Text(
                              "Learn the fundamentals of Data Analytics and gain an understanding of the data ecosystem, the process and lifecycle of data analytics, career opportunities, and the different learning paths you can take to be a Data Analyst.",
                              style: kalamTextStyle.copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w400)),
                        ),
                        GetObjectivesAndPreRequisites(title: "Pre-requisites"),
                        GetObjectivesAndPreRequisites(title: "Objectives"),
                        Padding(
                          padding: const EdgeInsets.only(right: 30, top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: defaultDark,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 15),
                                    child: Text(
                                      'Opt out',
                                      style: kalam700.copyWith(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: defaultDark,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 7, horizontal: 15),
                                    child: Text(
                                      'Explore similar',
                                      style: kalam700.copyWith(
                                          fontSize: 14, color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: showFeedBack ? 240 : 50,
              width: width,
              child: showFeedBack
                  ? GestureDetector(
                      onTap: () {
                        showFeedBack = !showFeedBack;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: defaultDark,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(28),
                                bottomRight: Radius.circular(28))),
                        child: Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                  onPageChanged: (int page) {
                                    setState(() {
                                      _currentPage = page;
                                    });
                                  },
                                  controller: pageController,
                                  itemCount: 5,
                                  itemBuilder: (context, position) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          child: Icon(
                                                              Icons.person),
                                                          radius: 22,
                                                        ),
                                                        SizedBox(
                                                          width: 8,
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text('Rachel Green',
                                                                style: kalamTextStyle.copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700)),
                                                            Text(' Class of 9',
                                                                style: kalamTextStyle.copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Color(
                                                                        0xFF77838F))),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Stack(
                                                    children: [
                                                      SvgPicture.asset(
                                                        'images/circles.svg',
                                                        width: 45,
                                                        height: 45,
                                                        color: inactiveOtpColor,
                                                      ),
                                                      Positioned(
                                                        right: 5,
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              '5',
                                                              style: kalamTextStyle.copyWith(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Icon(
                                                              Icons.star,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 15),
                                                child: Text(
                                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam imperdiet, ligula in sodales ullamcorper, odioarcu venenatis erat, et varius massa erat vel mauris.',
                                                  style:
                                                      kalamTextStyle.copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                  maxLines: 4,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _list,
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showFeedBack = !showFeedBack;
                            setState(() {});
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.transparent,
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
