import 'package:flutter/material.dart';
import 'package:palette/modules/student_dashboard_module/models/event_list_model.dart';
import 'package:palette/modules/student_dashboard_module/screens/event_detail.dart';
import 'package:palette/utils/custom_date_formatter.dart';
import 'package:palette/utils/konstants.dart';

class EventApplicationCell extends StatelessWidget {
  final EventList model;
  EventApplicationCell({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 140,
      color: Colors.transparent,
      child: ListView.builder(
          itemCount: model.data.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index){
            var info = model.data[index];
            return  InkWell(
              onTap: (){

              },
              child: Container(
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
                padding: const EdgeInsets.only(left: 25),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context,  MaterialPageRoute(
                        builder: (context) => EventDetail(info: info,)),
                    );
                  },
                  child: Container(
                      width: 179,
                      alignment: Alignment.topLeft,
                      child:
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 11),
                            child: Text(info.name, style: kalamLight.copyWith(color: defaultDark, fontSize: 16)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 5, right: 25),
                            child: Text(info.venue, style: montserratNormal.copyWith(color: defaultDark.withOpacity(0.64)), maxLines: 2, overflow: TextOverflow.ellipsis,),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 9, bottom: 17 ),
                            child: Text(CustomDateFormatter.convertDateIntoString(info.startDate), style: montserratNormal.copyWith(color: defaultDark.withOpacity(0.64))),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            );
          }),
    );
  }

}