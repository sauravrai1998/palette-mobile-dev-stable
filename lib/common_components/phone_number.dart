import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/konstants.dart';

// ignore: must_be_immutable
class PhoneNumber extends StatefulWidget {
  var userModel;
  final Function? upDateCallBack;
  PhoneNumber({required this.userModel, required this.upDateCallBack});
  @override
  _PhoneNumberState createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber>
    with SingleTickerProviderStateMixin {
  getBody(_width) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8, right: 8, left: 8),
      child: Container(
        height: 30,
        // width: _width * 3 / 7,
        child: Column(
          children: [
            Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: defaultLight,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                height: 30,
                // width: _width * 3 / 7,
                child: Row(
                  children: [
                    Icon(
                      Icons.call,
                      color: defaultDark,
                      size: 18,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Semantics(
                      child: Text(
                        "${widget.userModel.phone.toString()}",
                        style: TextStyle(color: defaultDark),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Expanded(child: GestureDetector(
          onTap: () {
            setState(() {
              print('ca;;ed');
              widget.upDateCallBack!(popUp: false);
            });
          },
        )),
        Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
              child: Container(
                // width: 3.8 * width / 7,
                decoration: BoxDecoration(
                    color: defaultLight,
                    borderRadius: BorderRadius.circular(12)),
                child: getBody(width),
              ),
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    widget.upDateCallBack!(false);
                  });
                },
                child: SizedBox(
                  width: width * 1.3 / 7,
                )),
          ],
        ),
      ],
    );
  }
}
