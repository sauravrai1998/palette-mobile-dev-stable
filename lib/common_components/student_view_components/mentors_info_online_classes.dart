import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class MentorsInformationForOnlineCourses extends StatefulWidget {
  final double height;
  MentorsInformationForOnlineCourses({required this.height});
  @override
  _MentorsInformationForOnlineCoursesState createState() =>
      _MentorsInformationForOnlineCoursesState();
}

class _MentorsInformationForOnlineCoursesState
    extends State<MentorsInformationForOnlineCourses> {
  mentorWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        children: [
          CircleAvatar(
            radius: 25,
            child: Icon(Icons.person),
          ),
          SizedBox(
            height: 3,
          ),
          Text(
            'John Smith',
            style: kalamTextStyle.copyWith(
                fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                child: PopupMenuButton(
                  padding: EdgeInsets.all(0),
                  shape: bottomRightCurvedShape,
                  color: Colors.white,
                  offset: Offset(-30, -30),
                  icon: Icon(
                    Icons.person,
                    color: defaultLight,
                  ),
                  elevation: 0,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      height: 230,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          height: 230,
                          width: 60,
                          child: ListView(
                            children: [
                              mentorWidget(),
                              mentorWidget(),
                              mentorWidget()
                            ],
                          ),
                        ),
                      ),
                      value: 0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'John Smith',
                style: kalamTextStyle.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
              Text(
                '(Prof.)',
                style: kalamTextStyle.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w700),
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 40, top: 20, left: 13, right: 12),
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(50)),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        'Data analytics using python',
                        style: kalam700.copyWith(
                            fontSize: 22, fontWeight: FontWeight.w700),
                        maxLines: 2,
                      ),
                    ),
                  ],
                )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'By , John Hopkins University',
                          style: kalamTextStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '15CA23 - 60 hrs',
                          style: kalamTextStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
