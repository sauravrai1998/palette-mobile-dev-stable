import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class GetObjectivesAndPreRequisites extends StatelessWidget {
  final String title;
  GetObjectivesAndPreRequisites({required this.title});

  Widget getIndentedText({text}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10, left: 30),
          child: Container(
            width: 8,
            height: 3,
            color: defaultLight,
            child: SizedBox(),
          ),
        ),
        Text("$text",
            style: kalamTextStyle.copyWith(
                fontSize: 14, fontWeight: FontWeight.w400))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title",
              style: kalamTextStyle.copyWith(
                  fontSize: 18, fontWeight: FontWeight.w700)),
          SizedBox(
            height: 5,
          ),
          getIndentedText(text: "Use data mining software to solve problems"),
          getIndentedText(
              text: "Analyse business problems and apply principles"),
        ],
      ),
    );
  }
}
