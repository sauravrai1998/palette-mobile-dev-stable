import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class MentorsInformationForClasses extends StatelessWidget {
  final height;
  MentorsInformationForClasses({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                child: Icon(Icons.person),
              ),
              SizedBox(
                height: 3,
              ),
              Text(
                'John Smith',
                style: kalamTextStyle.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w700),
              ),
              Text(
                '(Prof.)',
                style: kalamTextStyle.copyWith(
                    fontSize: 12, fontWeight: FontWeight.w700),
              )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 40, top: 20, left: 12, right: 12),
            child: Container(
              width: 2,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(50)),
            ),
          ),
          Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'John Smith',
                            style: kalamTextStyle.copyWith(
                                fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '15CA23 - 60 hrs',
                            style: kalamTextStyle.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ],
                  )),
                  Expanded(
                      child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(10, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CircleAvatar(
                          radius: 30,
                          child: Icon(Icons.person),
                        ),
                      );
                    }),
                  ))
                ],
              ))
        ],
      ),
    );
  }
}
