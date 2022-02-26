import 'package:flutter/material.dart';
import 'package:palette/modules/student_dashboard_module/models/job_application_list_model.dart';
import 'package:palette/modules/student_dashboard_module/screens/job_application_detail.dart';
import 'package:palette/utils/custom_date_formatter.dart';
import 'package:palette/utils/konstants.dart';

class JobApplicationCell extends StatelessWidget {
  final JobApplicationListModel model;

  final Function? onTap;
  JobApplicationCell({required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 130,
        color: Colors.transparent,
        child: ListView.builder(
            itemCount: model.data.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              JobInfo info = model.data[index];
              return Container(
                margin: EdgeInsets.fromLTRB(28, 12, 14, 15),
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
                padding: const EdgeInsets.only(left: 28, right: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              JobApplicationDetail(info: model.data[index])),
                    );
                  },
                  child: Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 11),
                            child: Text(info.organizationName,
                                style: kalamLight.copyWith(
                                    color: defaultDark, fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0, top: 5, right: 25),
                            child: Text(info.position,
                                style: montserratNormal.copyWith(
                                    fontSize: 10,
                                    color: defaultDark.withOpacity(0.64))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 0, top: 9, bottom: 17),
                            child: Builder(builder: (context) {
                              if (info.appliedDate == null) {
                                return Text('${info.applicationStatus}',
                                    style: montserratNormal.copyWith(
                                        fontSize: 10,
                                        color: defaultDark.withOpacity(0.64)));
                              }
                              return Text(
                                  '${info.applicationStatus} - ${CustomDateFormatter.convertIntoString(info.appliedDate!)}',
                                  style: montserratNormal.copyWith(
                                      fontSize: 10,
                                      color: defaultDark.withOpacity(0.64)));
                            }),
                          )
                        ],
                      )),
                ),
              );
            }),
      ),
    );
  }
}
