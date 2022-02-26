import 'package:flutter/material.dart';
import 'package:palette/modules/student_dashboard_module/models/college_application_list_model.dart';
import 'package:palette/modules/student_dashboard_module/screens/college_application_detail.dart';
import 'package:palette/utils/konstants.dart';

class CollegeApplicationCell extends StatelessWidget {
  final CollegeApplicationList model;

  CollegeApplicationCell({required this.model, this.onTap});
  final Function? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // onTap!();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 130,
        color: Colors.transparent,
        child: ListView.builder(
            itemCount: model.data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              CollegeInfo info = model.data[index];
              return Container(
                  margin: EdgeInsets.fromLTRB(28, 15, 14, 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(11)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        spreadRadius: 5,
                        blurRadius: 8,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 25),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CollegeApplicationDetail(info: info)),
                      );
                    },
                    child: Container(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 11, right: 5),
                              child: Text(
                                info.universityName,
                                style: kalamLight.copyWith(
                                    color: defaultDark, fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, top: 5, right: 25),
                              child: Text(info.program,
                                  style: montserratNormal.copyWith(
                                      color: defaultDark.withOpacity(0.64))),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    left: 0, top: 9, bottom: 18),
                                child: Text(
                                  info.intake,
                                  style: montserratNormal.copyWith(
                                      color: defaultDark.withOpacity(0.64)),
                                ))
                          ],
                        )),
                  ));
            }),
      ),
    );
  }
}

class CollegeApplicationModel {
  String collegeName;
  String programName;
  String intake;
  CollegeApplicationModel(
      {required this.collegeName,
      required this.programName,
      required this.intake});
}
