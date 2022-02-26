import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/animation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/modules/student_dashboard_module/screens/activities_student_dashboard.dart';
import 'package:palette/modules/student_dashboard_module/screens/carrer_student_dashboard_screen.dart';
import 'package:palette/modules/student_dashboard_module/screens/education_student_dashboard.dart';
import 'package:palette/modules/student_dashboard_module/screens/people_student_dashboard.dart';
import 'package:palette/utils/konstants.dart';

import '../../../main.dart';

class HomePageForStudent extends StatefulWidget {
  @override
  _HomePageForStudentState createState() => _HomePageForStudentState();
}

class _HomePageForStudentState extends State<HomePageForStudent>
    with SingleTickerProviderStateMixin {
  int _page1 = 0;
  int _page2 = 1;
  final _pageOptions1 = [
    EducationStudentDashboard(view: 'profile'),
    CareerStudentDashboard(view: 'profile'),
    ActivitiesStudentDashboard(view: 'profile'),
    PeopleStudentDashboard(view: 'profile'),
    PeopleStudentDashboard(view: 'profile'),
  ];

  final _pageOptions2 = [
    PeopleStudentDashboard(view: 'explore'),
    EducationStudentDashboard(view: 'explore'),
    CareerStudentDashboard(view: 'explore'),
    ActivitiesStudentDashboard(view: 'explore'),
    PeopleStudentDashboard(view: 'explore'),
  ];
  late Animation animation;
  late AnimationController _animationController;
  //icon = SvgPicture.asset('images/left_arrow.svg') as IconData;
  String text = "Explore";
  bool right = false;
  var radius = BorderRadius.only(topLeft: Radius.circular(20));
  var align = Alignment.centerLeft;
  bool reverse = false;

  bool onHorizontalDragStart = false;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750))
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                //icon = SvgPicture.asset('images/right_arrow.svg');
                text = "Profile";
                right = !right;
                radius = BorderRadius.only(topRight: Radius.circular(20));
                align = Alignment.centerRight;
                reverse = true;
              });
            } else if (status == AnimationStatus.dismissed) {
              setState(() {
                //icon = SvgPicture.asset('images/left_arrow.svg') as IconData;
                text = "Explore";
                radius = BorderRadius.only(topLeft: Radius.circular(20));
                align = Alignment.centerLeft;
                reverse = false;
              });
            }
          });

    animation = new Tween(
      begin: 0,
      end: 1.0,
    ).animate(
        new CurvedAnimation(parent: _animationController, curve: SineCurve()));
  }

  void toggle() {
    _animationController.isDismissed
        ? _animationController.forward()
        : _animationController.reverse();
  }
  /*void onChanged(bool value){
    setState(() {
      onHorizontalDragStart = true;
    });

  }
*/

  @override
  Widget build(BuildContext context) {
    double maxSlide = MediaQuery.of(context).size.width;

    bool _canBeDragged = false;
    var profile = Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _pageOptions1[_page1]);
    var explore = Container(
        color: Colors.yellow,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _pageOptions2[_page2]);
    var bottomnav1 = CurvedNavigationBar(
        color: darkBackgroundColor,
        buttonBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        height: 60,
        index: 0,
        items: <Widget>[
          Icon(
            Imported.education_icon,
            size: 30,
            color: _page1 == 0 ? darkBackgroundColor : Colors.white,
          ),
          Icon(
            Imported.career_icon,
            size: 30,
            color: _page1 == 1 ? darkBackgroundColor : Colors.white,
          ),
          Icon(
            Imported.activities,
            size: 30,
            color: _page1 == 2 ? darkBackgroundColor : Colors.white,
          ),
          Icon(
            Imported.person_icon,
            size: 30,
            color: _page1 == 3 ? darkBackgroundColor : Colors.white,
          ),
          Icon(
            Icons.verified_user,
            size: 30,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          debugPrint("current index is $index");
          setState(() {
            _page1 = index;
          });
        });
    var bottomnav2 = CurvedNavigationBar(
        color: darkBackgroundColor,
        buttonBackgroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        height: 60,
        index: 1,
        items: <Widget>[
          Icon(
            Icons.verified_user,
            size: 30,
            color: _page2 == 0 ? darkBackgroundColor : Colors.white,
          ),
          Icon(
            Imported.education_icon,
            size: 30,
            color: _page2 == 1 ? darkBackgroundColor : Colors.white,
          ),
          Icon(
            Imported.career_icon,
            size: 30,
            color: _page2 == 2 ? darkBackgroundColor : Colors.white,
          ),
          Icon(
            Imported.activities,
            size: 30,
            color: _page2 == 3 ? darkBackgroundColor : Colors.white,
          ),
          Icon(
            Imported.person_icon,
            size: 30,
            color: _page2 == 4 ? darkBackgroundColor : Colors.white,
          ),
        ],
        onTap: (index) {
          debugPrint("current index is $index");
          setState(() {
            _page2 = index;
          });
        });

    void _onDragStart(DragStartDetails details) {
      bool isDragOpenFromLeft = _animationController.isDismissed;
      bool isDragCloseFromRight = _animationController.isCompleted;
      _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
    }

    void _onDragUpdate(DragUpdateDetails details) {
      if (_canBeDragged) {
        var temp = details.primaryDelta;
        double delta = (temp == null ? 0 : temp) / maxSlide;
        _animationController.value -= delta;
      }
    }

    void _onDragEnd(DragEndDetails details) {
      //I have no idea what it means, copied from Drawer

      if (_animationController.isDismissed ||
          _animationController.isCompleted) {
        return;
      }
      if (reverse) {
        if (_animationController.value < 0.75) {
          _animationController.reverse();
        } else {
          _animationController.forward();
        }
      } else {
        if (_animationController.value > 0.25) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    }

    return TextScaleFactorClamper(
      child: SafeArea(
        child: Semantics(
          label:
              "Welcome to your dashboard. Here you can navigate between different pages related to your profile using the bottom navigation bar below. You can also switch to the explore view with similar pages and bottom navigation bar by swiping across the bottom from right to left. A left to right swipe on the bottom in the explore view will bring you back to the current profile view",
          child: Scaffold(
            body: Stack(
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, _) {
                    double slide = maxSlide * _animationController.value;
                    return Stack(
                      children: [
                        Transform(
                            transform: Matrix4.identity()..translate(-slide),
                            child: Stack(children: [
                              profile,
                              Positioned(
                                width: MediaQuery.of(context).size.width,
                                bottom: 0,
                                child: bottomnav1,
                              )
                            ])),
                        Transform.translate(
                          offset: Offset(
                              maxSlide * (1 - _animationController.value), 0),
                          child: Stack(children: [
                            explore,
                            Positioned(
                              width: MediaQuery.of(context).size.width,
                              bottom: 0,
                              child: bottomnav2,
                            )
                          ]),
                        ),
                      ],
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: animation,
                    builder: (context, _) {
                      double slide = animation.value == 1
                          ? 0
                          : (maxSlide - 64) * animation.value;
                      print(animation.value);
                      return GestureDetector(
                        onTap: toggle,
                        onHorizontalDragStart: _onDragStart,
                        onHorizontalDragUpdate: _onDragUpdate,
                        onHorizontalDragEnd: _onDragEnd,
                        child: Container(
                          alignment: align,
                          //padding: EdgeInsets.symmetric(horizontal: 15),
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 5,
                            right: 15,
                          ),
                          margin: !_animationController.isCompleted
                              ? _animationController.value > 0.5
                                  ? EdgeInsets.only(
                                      right: maxSlide - slide - 64)
                                  : EdgeInsets.only(right: 0)
                              : EdgeInsets.only(right: maxSlide - 64),
                          decoration: BoxDecoration(
                            borderRadius: radius,
                            color: defaultBlueDark,
                          ),
                          width: animation.isCompleted ? 65 : slide + 65,
                          // height: 70,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 2),
                                  height: 25,
                                  width: 30,
                                  child: _animationController.value > 0.5
                                      ? new SvgPicture.asset(
                                          'images/right_arrow.svg',
                                          color: Colors.white,
                                        )
                                      : new SvgPicture.asset(
                                          'images/left_arrow.svg',
                                          color: Colors.white,
                                        )),
                              SizedBox(
                                height: 7,
                              ),
                              Text(
                                '$text',
                                style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: white),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            /*: CurvedNavigationBar(
              color: darkBackgroundColor,
              buttonBackgroundColor: defaultBlueDark,
                height: 60,
              index: 1,
              items: <Widget>[
                Icon(Icons.verified_user,size: 20,color: Colors.white,),
                Icon(Icons.verified_user,size: 20,color: Colors.white,),
                Icon(Icons.verified_user,size: 20,color: Colors.white,),
              ],
              onTap: (index){
                debugPrint("current index is $index");

              }
            ),*/
          ),
        ),
      ),
    );
  }
}

class SineCurve extends Curve {
  // t = x
  final double count;

  SineCurve({this.count = 1});

  @override
  double transformInternal(double t) {
    var val = t < 0.5 ? 2 * t : 2 - 2 * t;
    return val; //f(x)
  }
}
