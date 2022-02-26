import 'package:flutter/material.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/student_dashboard_module/widgets/unread_counter_empty_widget.dart';

class UnreadCountIndicator extends StatelessWidget {
  const UnreadCountIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 2,
      right: 2,
      child: StreamBuilder(
          stream: unreadMessageCountMapStreamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return SizedBox();
            }
            final data = snapshot.data! as Map<String, int>;
            var counter = 0;
            data.forEach((key, value) {
              counter += value;
            });

            if (counter == 0) {
              return SizedBox();
            }

            return Container(
              height: 21,
              width: 21,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: TextScaleFactorClamper(
                    maxScaleFactor: 1.3,
                    child: Text(
                                  '$counter',
                                  style: TextStyle(color: Colors.white),
                      semanticsLabel: "$counter",
                                ),
                  )),
            );
          }),
    );
  }
}
