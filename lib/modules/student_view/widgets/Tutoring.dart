import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/tutoring_box.dart';

class Tutoring extends StatefulWidget {
  final List<dynamic> points;
  final String? value;
  final Function? callBackfn;

  Tutoring({required this.points, this.value, this.callBackfn});
  @override
  _TutoringState createState() => _TutoringState();
}

class _TutoringState extends State<Tutoring> {
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
                  // onViewAllTap(
                  //   context: this.context,
                  //   points: widget.points,
                  //   value: widget.value, callBackfn: widget.callBackfn,
                  // );
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
            height: 90,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                  widget.points.length == 0 ? 0 : widget.points.length,
                  (index) {
                return TutoringBox(data: widget.points[index]);
              }),
            ),
          )
        ],
      ),
    );
  }
}
