import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/student_view/screens/class_detailed_view.dart';

// ignore: must_be_immutable
class ClassesWidget extends StatefulWidget {
  var points = [];
  String? value;
  Function? callBackfn;
  ClassesWidget({required this.points, this.value, this.callBackfn});
  @override
  _ClassesWidgetState createState() => _ClassesWidgetState();
}

class _ClassesWidgetState extends State<ClassesWidget> {
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
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailedClassView()));
                },
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
            height: 70,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(widget.points.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 70,
                            width: index % 2 != 0 ? 115 : 65,
                            decoration: BoxDecoration(
                                color: defaultDark.withOpacity(0.82),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12),
                                    topLeft: Radius.circular(12))),
                          ),
                          Container(
                            height: 70,
                            width: index % 2 == 0 ? 115 : 65,
                            decoration: BoxDecoration(
                                color: defaultDark.withOpacity(0.5),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12))),
                          ),
                        ],
                      ),
                      Container(
                        height: 70,
                        width: 170,
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: Text(
                            "${widget.points[index].name}",
                            style: kalamLight.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: GestureDetector(
                          onTap: () {
                            //Naviagte
                          },
                          child: Container(
                            child: Icon(Icons.arrow_forward_ios,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      )
                    ],
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
