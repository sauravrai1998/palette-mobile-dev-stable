import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette/modules/todo_module/widget/parent_advisor_todo_widgets/parent_todo_icon.dart';
import 'package:palette/utils/konstants.dart';

class ProfileCardForViewALL extends StatelessWidget {
  const ProfileCardForViewALL({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: 250,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              ProfileIconTodo(
                img: "images/profilejpg.png",
                height: 35,
                bgColor: Colors.white,
              ),
              Text(
                "Monica Geller",
                style: montserratBoldTextStyle.copyWith(
                    color: defaultDark, fontSize: 12),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.fromLTRB(8, 2, 8, 2),
            width: 230,
            child: Text(
              "Apply to Montogentory College",
              overflow: TextOverflow.ellipsis,
              style: montserratBoldTextStyle.copyWith(
                  color: defaultDark, fontSize: 12),
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(8, 2, 8, 2),
            width: 230,
            child: Text(
              "Due Date: ${DateFormat.yMMMd('en_US').format(DateTime.now())}",
              style: montserratBoldTextStyle.copyWith(
                  color: defaultDark, fontSize: 12),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Open",
                  style: montserratBoldTextStyle.copyWith(
                    color: openButtonColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}
