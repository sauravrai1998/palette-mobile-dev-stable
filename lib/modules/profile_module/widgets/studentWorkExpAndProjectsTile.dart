import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import '../../../utils/konstants.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum TileType {
  WORK_EXP,
  PROJECTS,
}

class StudentWorkExpAndProjects extends StatelessWidget {
  final List<StudentWorkExp> studentWorkExpList;
  final TileType value;
  StudentWorkExpAndProjects({
    required this.studentWorkExpList,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                value == TileType.WORK_EXP
                    ? Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: SvgPicture.asset(
                          'images/work_experience.svg',
                          width: 20,
                          height: 20,
                          color: defaultLight,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(
                          Imported.engineering_black_18dp_1,
                          color: defaultLight,
                        ),
                      ),
                Text(
                  value == TileType.WORK_EXP ? "Work Experience" : "Projects",
                  style: kalamLight,
                ),
                Spacer()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            studentWorkExpList.isEmpty
                ? Center(
                    child: Text(
                      'Not available',
                      style: kalamTextStyleSmall.copyWith(
                        color: white,
                        fontSize: 15,
                      ),
                    ),
                  )
                : Container(
                    height: 114,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final workExp = studentWorkExpList[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            height: 90,
                            // width: 210,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(11),
                              color: profileCardBackgroundColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      workExp.organizationName == null
                                          ? Container()
                                          : Text(
                                              workExp.organizationName!,
                                              style: kalamLight.copyWith(
                                                  fontSize: 16),
                                            ),
                                      workExp.role == null
                                          ? Container()
                                          : Expanded(
                                              child: Text(
                                              " - ${workExp.role}",
                                              style: kalamLight.copyWith(
                                                  fontSize: 16),
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                    ],
                                  ),
                                  Spacer(),
                                  workExp.role == null
                                      ? Container()
                                      : Text(
                                          "${workExp.role}",
                                          style: kalamLight.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                  workExp.startDate == null
                                      ? Container()
                                      : Text(
                                          "${workExp.startDate}",
                                          style: kalamLight.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      itemCount: studentWorkExpList.length,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
