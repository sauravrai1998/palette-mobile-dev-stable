import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/utils/konstants.dart';

class TimePickerOpportunity extends StatefulWidget {
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay?> onTimeChanged;
  final bool errorflag;
  const TimePickerOpportunity(
      {Key? key,
      this.initialTime,
      required this.onTimeChanged,
      this.errorflag = false})
      : super(key: key);

  @override
  _TimePickerOpportunityState createState() => _TimePickerOpportunityState();
}

class _TimePickerOpportunityState extends State<TimePickerOpportunity> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectTime(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        width: 134,
        //height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.initialTime == null
                  ? widget.errorflag
                      ? todoListActiveTab
                      : Colors.transparent
                  : Colors.transparent,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ]),
        child: Center(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5, left: 3),
                child: SvgPicture.asset(
                  'images/clock.svg',
                  color: widget.initialTime == null
                      ? widget.errorflag
                          ? todoListActiveTab
                          : Colors.grey
                      : defaultDark,
                  height: 19,
                  width: 19,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.initialTime != null
                            ? 'Event Time'
                        : '',
                    style: roboto700.copyWith(
                        fontSize: widget.initialTime != null ? 10 : 0,
                        color: defaultDark.withOpacity(0.5)),
                  ),
                  Text(
                      widget.initialTime == null
                          ? 'Event Time'
                          : "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, widget.initialTime!.hour, widget.initialTime!.minute))}",
                      style: roboto700.copyWith(
                          fontSize: 14,
                          color: widget.initialTime == null ? widget.errorflag  
                              ? todoListActiveTab
                              : defaultDark.withOpacity(0.6)
                              : defaultDark)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: widget.initialTime ?? TimeOfDay.now(),
    );
      widget.onTimeChanged(picked);
    
  }
}
