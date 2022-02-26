import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/utils/konstants.dart';

// ignore: must_be_immutable
class ContactNumber extends StatefulWidget {
  var userModel;
  final Function? upDateCallBack;
  ContactNumber({required this.userModel, this.upDateCallBack});

  @override
  _ContactNumberState createState() => _ContactNumberState();
}

class _ContactNumberState extends State<ContactNumber>
    with SingleTickerProviderStateMixin {
  getBody(_width, emailFields) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 25, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Imported.mail_black_18dp_1,
                  size: 25,
                  color: defaultDark,
                ),
                SizedBox(
                  width: 10,
                ),
                Semantics(
                  child: Text(
                    "Contact Mail",
                    style: roboto700.copyWith(color: defaultDark, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
            child: Semantics(
              child: Text(
                "$emailFields",
                style: roboto700.copyWith(
                  fontWeight: FontWeight.w500,
                  color: defaultDark,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    String emailFields = widget.userModel.email.toString();

    return Column(
      children: [
        Expanded(child: GestureDetector(
          onTap: () {
            setState(() {
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
                width: 5 * width / 7,
                decoration: BoxDecoration(
                    color: defaultLight,
                    borderRadius: BorderRadius.circular(12)),
                child: getBody(width, emailFields),
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
