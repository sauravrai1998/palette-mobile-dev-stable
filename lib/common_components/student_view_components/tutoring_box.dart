import 'package:flutter/material.dart';
import 'package:palette/modules/student_dashboard_module/models/tutoring_data_model.dart';
import 'package:palette/utils/konstants.dart';

class TutoringBox extends StatefulWidget {
  final TutoringDataModel data;
  TutoringBox({required this.data});
  @override
  _TutoringBoxState createState() => _TutoringBoxState();
}

class _TutoringBoxState extends State<TutoringBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                height: 90,
                width: 60,
                decoration: BoxDecoration(
                    color: defaultDark,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topLeft: Radius.circular(12))),
              ),
              Container(
                height: 90,
                width: 120,
                decoration: BoxDecoration(
                    color: defaultDark.withOpacity(0.8),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12))),
              ),
            ],
          ),
          Container(
            width: 170,
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.data.courseName}",
                    style: tutoringStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.map,
                          size: 16,
                        ),
                        Text(
                          "${widget.data.name}",
                          style: tutoringStyle,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0),
                    child: Text(
                      "${widget.data.time}",
                      style: tutoringStyle,
                    ),
                  ),
                  Text(
                    "${widget.data.rating}%",
                    style: tutoringStyle.copyWith(
                        color: defaultLight.withOpacity(0.5)),
                  ),
                ],
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
  }
}
