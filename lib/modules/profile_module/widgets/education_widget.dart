import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/enums.dart';
import 'package:palette/utils/konstants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EducationWidget extends StatefulWidget {
  final UserType selectedUser;
  final List education;

  EducationWidget({required this.selectedUser, required this.education});

  @override
  _EducationWidgetState createState() => _EducationWidgetState();
}

class _EducationWidgetState extends State<EducationWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'images/education.svg',
              width: 20,
              height: 20,
              color: defaultLight,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              widget.selectedUser == UserType.STUDENT
                  ? 'Education'
                  : 'Institute',
              style: kalamTextStyleSmall.copyWith(
                fontSize: 18,
                color: defaultLight,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.16,
          child: ListView.builder(
              itemCount: widget.education.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02),
                  child: Container(
                    decoration: BoxDecoration(
                      color: profileCardBackgroundColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.education[index][0],
                            style: kalamTextStyleSmall.copyWith(
                              fontSize: 18,
                              color: white,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.education[index][1],
                                style: kalamTextStyleSmall.copyWith(
                                  fontSize: 18,
                                  color: white.withOpacity(0.5),
                                ),
                              ),
                              if (widget.education[index].length > 2)
                                Text(
                                  widget.education[index][2],
                                  style: kalamTextStyleSmall.copyWith(
                                    fontSize: 18,
                                    color: white.withOpacity(0.5),
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
        )
      ],
    );
  }
}
