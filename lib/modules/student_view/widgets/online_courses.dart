import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:palette/common_components/common_components_link.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class OnlineCourses extends StatefulWidget {
  final List<dynamic> points;
  final String? value;
  final Function? callBackfn;

  OnlineCourses({required this.points, this.value, this.callBackfn});
  @override
  _OnlineCoursesState createState() => _OnlineCoursesState();
}

class _OnlineCoursesState extends State<OnlineCourses> {
  var listOfWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "${widget.value}",
                style: kalamLight.copyWith(color: defaultDark, fontSize: 24),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {},
                child: Text(
                  "View All",
                  style: kalamLight.copyWith(fontSize: 14, color: defaultDark),
                ),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(widget.points.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Container(
                    width: 170,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: defaultDark,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 13),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.points[index].course}",
                            style: tutoringStyle,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${widget.points[index].name}",
                                      style: tutoringStyle.copyWith(
                                          color: defaultLight),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "${widget.points[index].platform}",
                                      style: tutoringStyle.copyWith(
                                          color: defaultLight),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: CircularPercentIndicator(
                                  radius: 50.0,
                                  lineWidth: 10.0,
                                  percent: 30 / 100,
                                  startAngle: 270,
                                  center: Text(
                                    widget.points[index].rating,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  progressColor: defaultPurple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
