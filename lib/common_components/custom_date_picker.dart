import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/konstants.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onPickedDate;

  CustomDatePicker({
    Key? key,
    required this.initialDate,
    required this.onPickedDate,
  }) : super(key: key);
  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? pickedDate;
  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;

    return Semantics(
      label: 'Please select the date of birth',
      onTapHint: 'Please select the date of birth',
      child: Container(
          padding: const EdgeInsets.all(10.0),
          height: devHeight * 0.075,
          width: devWidth * 0.6,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: Offset(0, 1),
                  blurRadius: 8,
                )
              ]),
          child: GestureDetector(
            onTap: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    backgroundColor: white,
                    child: IntrinsicHeight(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: devHeight * 0.5,
                              child: Center(
                                child: CupertinoDatePicker(
                                  backgroundColor: Colors.transparent,
                                  mode: CupertinoDatePickerMode.date,
                                  onDateTimeChanged: (picked) {
                                    pickedDate = picked;
                                  },
                                  initialDateTime: DateTime(
                                    DateTime.now().year - 4,
                                    DateTime.now().month,
                                    DateTime.now().day,
                                  ),
                                  minimumYear: 1900,
                                  maximumYear: DateTime.now().year - 4,
                                ),
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: devWidth * 0.08,
                                    ),
                                    child: NextButton(
                                      clickFunction: () {
                                        widget.onPickedDate(
                                            pickedDate ?? widget.initialDate);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: devWidth * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'images/date_picker.svg',
                    width: 16,
                    height: 16,
                    color: defaultDark,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget dateTextWidget({DateTime? dob, DateTime? dobForTF}) {
    if (dob != null) {
      return Text(
        DateFormat('dd-MM-yyyy').format(dob),
        style: roboto700.copyWith(
          color: defaultDark,
          fontSize: 14,
        ),
      );
    } else {
      final dob = dobForTF;
      return Text(
        dob == null ? 'dd-mm-yyyy' : DateFormat('dd-MM-yyyy').format(dob),
        style: roboto700.copyWith(
          color: dob == null ? colorForPlaceholders : defaultDark,
          fontSize: 14,
        ),
      );
    }
  }
}
